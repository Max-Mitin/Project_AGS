/* основной запрос БЕЗ пересчета в USD */
WITH BASE AS ( select ecp.RegistrationDate AS "Дата_регистрации", ecp.Date AS "Дата_исполнения",
ecp.SubaccOwnerFirm_ShortName AS "Client_Name", SUBSTRING(ecp.Subacc_Code, 1, 11) AS "Contract_number", 
ecp.CurrencyAsset_ShortName AS "Currency",  
"Inflows" = CAST(CASE 
	WHEN (Price = 0) and CT_Const = 6 Then Size*1           /*ввод ДС*/
	WHEN (Price > 0) and CT_Const = 4 Then Size*Price       /*ввод ЦБ*/
	ELSE '0'
	--WHEN /*(Price = 0) and*/ CT_Const = 7 Then 'no'       /*вывод ДС*/
	--WHEN /*(Price > 0) and*/ CT_Const = 5 Then 'no'       /*вывод ЦБ*/
END AS float),
"Outflows" = CAST(CASE
	--WHEN /*(Price = 0) and*/ CT_Const = 6 Then 'no'          /*ввод ДС*/
	--WHEN /*(Price > 0) and*/ CT_Const = 4 Then 'no'          /*ввод ЦБ*/
	WHEN Price = 0 and CT_Const = 7 Then Size*1              /*вывод ДС*/
	WHEN Price > 0 and CT_Const = 5 Then Size*Price          /*вывод ЦБ*/
	ELSE '0'
END AS float),
CASE ecp.CT_Const
	WHEN 4 THEN 'ввод ЦБ'
	WHEN 5 THEN 'вывод ЦБ'
	WHEN 6 THEN 'ввод ДС'
	WHEN 7 THEN 'вывод ДС'
END AS "Тип_операции",
ecp.Asset_ShortName,
IsNULL(dba.ISIN, ecp.Asset_ShortName) AS "ISIN",
ecp.Size      AS "Количество",
ecp.Price     AS "Цена_закупки",
dba.id
from backQORT_TDB.dbo.ExportCorrectPositions ecp
left join backQORT_DB.dbo.Assets dba ON dba.ShortName = ecp.Asset_ShortName
where ecp.Date between 20240628 and 20240704  /* выбор периода Даты исполнения. OLD RegistrationDate between 20240420 and 20240425     -- between 20240511 and 20240516  */
and CT_Const IN (4, 5, 6, 7)
and dba.Enabled = 0             /*Удаленная запись (значение равно ID) если = 0 то запись активна */
and ecp.IsCanceled = 'n'       /*Убрать отмененные записи, где 'y' */
),

CROSS_CURS AS (Select crh.Date, crh.OldDate, crh.TradeAsset_ID, crh.PriceAsset_ID, crh.Bid from backQORT_DB.dbo.CrossRatesHist crh 
where OldDate = 20240516  /* Выбор даты курсов валют */
and crh.TradeAsset_ID IN (9, 11, 173, 21, 112) and crh.PriceAsset_ID = 8
),
						/* Дата котировок из MarketInfoHist as mih одинаковая с таблицей курсов валют CrossRatesHist as crh */
KOTIR AS ( Select dba.ShortName, mih.LastPrice AS "Рыночная_цена", 
CASE mih.PriceAsset_ID
	WHEN 8   THEN 'USD'
	WHEN 9   THEN 'EUR'
	WHEN 11  THEN 'CNY'
	WHEN 173 THEN 'RUB'
	WHEN 21  THEN 'GBP'
END AS "Валюта_котировки",
mih.PriceAsset_ID
from backQORT_DB.dbo.MarketInfoHist mih 
inner join backQORT_DB.dbo.Assets dba ON dba.id = mih.Asset_ID
where mih.OldDate = 20240516  /* Выбор даты котировки для ЦБ*/
and dba.Enabled = 0
and mih.TSSection_ID IN /* проблема когда из квика прилетели котировки - дубли, с ценой = 0, в итоге в отчете дубли с нулевой оценкой */
(169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189, 197, 198, 199, 200, 201, 186) )  /* оценка идёт с "bloomberg_%", либо с пользовательской секции */

Select
    Дата_регистрации, Дата_исполнения,
    Client_Name,
    Contract_number,
    Currency,
	Inflows, Outflows,
    CASE
        WHEN Asset_ShortName = 'USD' THEN Inflows
		WHEN Asset_ShortName = 'KZT' THEN Inflows * CROSS_CURS.Bid
		WHEN Asset_ShortName = 'EUR' THEN Inflows * CROSS_CURS.Bid
		WHEN Asset_ShortName = 'RUB' THEN Inflows * CROSS_CURS.Bid
        ELSE '0'
    END AS "Inflows_USD",
    CASE
        WHEN Asset_ShortName = 'USD' THEN Outflows * (-1)
		WHEN Asset_ShortName = 'KZT' THEN Outflows * CROSS_CURS.Bid * (-1)
		WHEN Asset_ShortName = 'EUR' THEN Outflows * CROSS_CURS.Bid * (-1)
		WHEN Asset_ShortName = 'RUB' THEN Outflows * CROSS_CURS.Bid * (-1)
        ELSE '0'
    END AS "Outflows_USD",
    Тип_операции,
    Asset_ShortName,
    ISIN,
    Количество,
    Цена_закупки,
    Рыночная_цена,
    Валюта_котировки,
    "Оценка_ЦБ_в_USD" = CASE
        WHEN KOTIR.PriceAsset_ID = 8 THEN Рыночная_цена * Количество * 1
        WHEN KOTIR.PriceAsset_ID = 173 THEN Рыночная_цена * Количество * Bid
        WHEN KOTIR.PriceAsset_ID = 9 THEN Рыночная_цена * Количество * Bid
        WHEN KOTIR.PriceAsset_ID = 21 THEN Рыночная_цена * Количество * Bid
        ELSE '0'
    END
From BASE
LEFT JOIN KOTIR ON KOTIR.ShortName = BASE.Asset_ShortName
LEFT JOIN CROSS_CURS ON (BASE.Asset_ShortName  = 'USD' AND CROSS_CURS.TradeAsset_ID = 8)
                     OR (BASE.Asset_ShortName <> 'USD' AND BASE.id = CROSS_CURS.TradeAsset_ID)
					 OR (KOTIR.PriceAsset_ID = CROSS_CURS.TradeAsset_ID)
 ;
