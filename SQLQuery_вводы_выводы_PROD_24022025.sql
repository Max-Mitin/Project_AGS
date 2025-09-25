with range_date as
(
  select cast(FORMAT(cast(@start_date as date), 'yyyMMdd') as int) as start_date,
		cast(FORMAT(cast(@end_date as date), 'yyyMMdd') as int) as end_date
),
CROSS_CURS AS 
(
	Select crh.Date, crh.OldDate, crh.TradeAsset_ID, crh.PriceAsset_ID, a.ShortName, crh.Bid
	from backQORT_DB.dbo.CrossRatesHist crh 
	      join range_date rd on OldDate between rd.start_date and rd.end_date
		  join backQORT_DB.dbo.Assets a on a.id = crh.TradeAsset_ID
	where crh.PriceAsset_ID = 8
),
KOTIR AS 
( 
  Select dba.ShortName, CASE WHEN dba.AssetClass_Const in (6,7,9) THEN (mih.LastPrice * dba.BaseValue / 100) ELSE mih.LastPrice END AS "Рыночная_цена", 
		CA.ShortName AS "Валюта_котировки", mih.PriceAsset_ID, mih.OldDate
  from backQORT_DB.dbo.MarketInfoHist mih
		join backQORT_DB.dbo.Assets CA ON mih.PriceAsset_ID = CA.ID
		join backQORT_DB.dbo.TSSections TS (nolock) on mih.TSSection_ID = TS.id
		join backQORT_DB.dbo.Assets dba ON dba.id = mih.Asset_ID
		join range_date rd on mih.OldDate between rd.start_date and rd.end_date
   where dba.Enabled = 0 and (TS.Name like 'Bloomberg%' or TS.Name in ('Пользовательская секция','AGS Funds'))
),
transfer_money as (
	select  ecp.SystemID--, ecp.SubaccOwnerFirm_BOCode,ecpDB.CPCorrectPos_ID, ecp2.SubaccOwnerFirm_BOCode
	from backQORT_TDB.dbo.ExportCorrectPositions ecp 
	    join range_date rd on ecp.Date between rd.start_date and rd.end_date
		join backQORT_DB.dbo.CorrectPositions ecpDB on ecpDB.id = ecp.SystemID
		join backQORT_DB.dbo.CorrectPositions ecp2DB on ecp2DB.id = ecpDB.CPCorrectPos_ID
		join backQORT_TDB.dbo.ExportCorrectPositions ecp2 on ecp2.SystemID = ecp2DB.id
	where  ecp.CT_Const in (11,12) and ecp.SubaccOwnerFirm_BOCode != ecp2.SubaccOwnerFirm_BOCode
)
select  ecp.RegistrationDate AS "Дата_регистрации", ecp.Date AS "Дата_исполнения",
        dbf.Name AS "Client_Name", SUBSTRING(ecp.Subacc_Code, 1, 11) AS "Contract_number", 
        ecp.CurrencyAsset_ShortName AS "Currency",
	    CROSS_CURS.Bid as "CrossRate",
   cast(case when Price = 0 and ecp.CT_Const in (6,7,11) then Size*1*CROSS_CURS.Bid else Size*KOTIR.Рыночная_цена*CROSS_CURS.Bid end AS float) as "Оценка в USD", -- без конвертации
   CASE WHEN ecp.CT_Const =4 THEN 'ввод ЦБ'		
		WHEN ecp.CT_Const =5 THEN 'вывод ЦБ'
		WHEN ecp.CT_Const =6 and ecp.Comment = 'Cash transfer for fund issuance' THEN 'Зачисление по заявке на выдачу паев'
		WHEN ecp.CT_Const =6 THEN 'ввод ДС'
		WHEN ecp.CT_Const =7 and ecp.Comment = 'Cash transfer for fund issuance'  THEN  'Оплата заявки на выдачу паев'
		WHEN ecp.CT_Const =7 THEN 'вывод ДС'
		WHEN ecp.CT_Const =11 THEN 'перевод ДС'
		WHEN ecp.CT_Const =12 THEN 'перевод ЦБ'
	END AS "Тип_операции",
	Asset_ShortName,
    ISIN,
    ecp.Size AS  Количество,
    ecp.Price AS "Цена_закупки",
    Рыночная_цена,
    Валюта_котировки,
   CROSS_CURS.ShortName
from backQORT_TDB.dbo.ExportCorrectPositions ecp
	join backQORT_DB.dbo.Assets dba ON dba.ShortName = ecp.Asset_ShortName
	left join backQORT_DB.dbo.Firms dbf ON dbf.BOCode = ecp.SubaccOwnerFirm_BOCode
	join range_date rd on ecp.Date between rd.start_date and rd.end_date
	LEFT JOIN KOTIR ON KOTIR.ShortName = ecp.Asset_ShortName and KOTIR.OldDate = ecp.Date 
    LEFT JOIN CROSS_CURS ON (ecp.CT_Const in (6,7,11) and ecp.Asset_ShortName = CROSS_CURS.ShortName 
			OR KOTIR.PriceAsset_ID = CROSS_CURS.TradeAsset_ID) AND (CROSS_CURS.OldDate = ecp.Date)
    left join transfer_money tm on ecp.SystemID = tm.SystemID
where CT_Const IN (4, 5, 6, 7,11, 12) and (CT_Const in (11,12) and tm.SystemID > 0 or CT_Const in (4, 5, 6, 7) )
     and dba.Enabled = 0  and ecp.IsCanceled = 'n' 
