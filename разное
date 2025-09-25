select * from backQORT_TDB.dbo.AggregateTrades;

select * from backQORT_DB.dbo.TradeWarnings;

select * from backQORT_DB.dbo.Trades;

select * from backQORT_DB.dbo.CrossRates;
select * from backQORT_TDB.dbo.CrossRates;
 select * from backQORT_TDB.dbo.SubAccs;

---Сначала загружаем Эмитента, потом Актив, а потом загружаем Инструмент
---Загрузка Эмитента
select * from backQORT_TDB.dbo.Firms;
select * from backQORT_TDB.dbo.Firms where "Name" like 'Franklin Templeton Investment';
insert into backQORT_TDB.dbo.Firms (IsProcessed, ET_Const,   "Name",              EngName,                FirmShortName,  BOCode, FT_Flags,  EngShortName,  IsTaxResident, IsResident, IsFirm)
                            values (1,            2,        'AGRO 6 09/21/27', 'AGRO 6 09/21/27',         'USL00849AA47',   'AUTO',     128, 'USL00849AA47',         'n',         'n',     'y');


---Загрузка актива
select * from backQORT_DB.dbo.TSSections;
select * from backQORT_TDB.dbo.Assets where Marking IN ('PIAHYII', '0P000101SN');
select ISIN, COUNT(*) from backQORT_TDB.dbo.Assets where isin IN ('LU0128522157', 'LU0908500753', 'IE00BFM6TB42', 'IE00B5BMR087', 'LU0300737037', 'LU0171281750', 'LU0205193047', 'LU0857590862',
'LU0229948087', 'LU0441853263', 'LU0260870158', 'LU1021349151', 'US69047Q1022', 'US75281A1097', 'US8454671095', 'US1921085049', 'US72919P2020', 'US5657881067', 'CH0048265513', 
'LU0072463663', 'LU0689472784') 
GROUP by ISIN
HAVING COUNT(*)>1;
order by ISIN;--PIAHYII
select * from backQORT_TDB.dbo.Assets where ShortName IN ('ZURN'); --- ++++
select * from backQORT_TDB.dbo.Assets where Marking IN ('US46429B6719');
delete from backQORT_TDB.dbo.Assets where Marking IN ('USL00849AA47');
update backQORT_DB.dbo.Assets set AssetSort_Const = 33, AssetClass_Const = 9 where Marking = 'USL00849AA47'; 
insert into backQORT_TDB.dbo.Assets 
       (IsProcessed, ET_Const, AssetType_Const, AssetClass_Const, AssetSort_Const, Marking,         ISIN,          ShortName,           ViewName,       BaseCurrencyAsset,           IsForQualInv,  IsTrading)
values (1,           2,         1,               9,                33,            'USL00849AA47',  'USL00849AA47',     'USL00849AA47', 'USL00849AA47',              'USD',                    'y' ,     'y'      );




---Добавление инструмента
select * from backQORT_TDB.dbo.Securities where SecCode = 'SCHPFAA LX';                                      ---SecCode IN ('0P000101SN','PIAHYII');  
insert into backQORT_TDB.dbo.Securities (IsProcessed, ET_Const, SecCode,              Asset_ShortName,         TSSection_Name,           ShortName,               "Name",                             LotSize)
                                 values (1,           2,       'USL00849AA47',            'USL00849AA47',    'Bloomberg_BGN',           'USL00849AA47',            'AGRO 6 09/21/27',           1);

update backQORT_TDB.dbo.Securities set  "Name" = 'CITIGROUP GL C 3 04/02/24', LotSize = 1 where ShortName = 'C 3 04/02/24'; 
delete from backQORT_TDB.dbo.Securities where SecCode IN ('0P000101SN','PIAHYII');



--Отчет 1
select * from backQORT_TDB.dbo.CorrectPositions;
select * from backQORT_TDB.dbo.CheckCorrectPositions;
select * from backQORT_TDB.dbo.CorrectPosMLOperationFactors;
select * from backQORT_TDB.dbo.ExportCorrectPositions
where RegistrationDate between 20240420 and 20240425    ---20230818 and 20230823
and CT_Const IN (4, 5, 6, 7)
--and PlanDate <> 0
--and CurrencyAsset_ShortName = ' '
order by date, GetSubaccOwnerFirm_ShortName;
select * from backQORT_TDB.dbo.ExportCorrectPositions
where Date between 20240511 and 20240516
and CT_Const IN (4, 5, 6, 7);

select * from backQORT_DB.dbo.Assets where ISIN = 'GB00BQRRMP41';
select * from backQORT_DB.dbo.MarketInfo where Asset_ID = 799;
select * from backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'RIO';

--Связка с валютой котировки 
select * from backQORT_DB.dbo.Assets where ID IN (8, 9, 11, 173, 37); -- 8 USD  9 EUR  173 RUB  11 CNY  112 KZT  37 AED
select * from backQORT_DB.dbo.Assets where ID IN (9, 11, 12, 17, 21, 24, 27, 29, 34, 35, 37, 41, 45, 51, 56, 65, 67, 69, 81, 82, 92, 93, 97, 104, 109, 112, 113, 114, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 173, 789); 
select ast.ViewName, ast.id, mi.PriceAsset_ID, mi.* from backQORT_DB.dbo.MarketInfo mi
inner join backQORT_DB.dbo.Assets ast ON ast.id = mi.PriceAsset_ID;  --RU0007661625

select ast.*, mi.* from backQORT_DB.dbo.MarketInfo mi
right join backQORT_DB.dbo.Assets ast ON ast.id = mi.PriceAsset_ID;

select * from backQORT_DB.dbo.MarketInfo mi;
select * from backQORT_DB.dbo.Assets order by id; ---id=524 ShortName =GAZP
select * from backQORT_DB.dbo.Assets where ShortName = 'GBX';
select * from backQORT_TDB.dbo.ExportCorrectPositions ecp  where IsCanceled = 'n' order by BackID; ---48 строка: Asset_ShortName RU0007661625
select * from backQORT_TDB.dbo.ExportCorrectPositions ecp where backID IN ('{4B9771B0-425F-44BE-8D10-1747CA6C85C1}', '{6026D2EE-8405-49F6-8813-818A76DEB85D}', 
'{70F8B9AE-437E-43DF-BF72-880F2A04B4C7}', '{EA4D4B58-09D5-49E8-BF5F-8D5928036F3E}', '{F056F87E-54B3-40E4-B500-B108020AD8D7}');
update backQORT_TDB.dbo.ExportCorrectPositions set Asset_ShortName = 'GAZP' where backID = '{E1BBB5D7-8F5E-4CBD-87DF-9957A7BC487C}';
select * from backQORT_DB.dbo.Assets where id = 237;

select ecp.RegistrationDate AS "Date", ecp.SubaccOwnerFirm_ShortName AS "Client Name", SUBSTRING(ecp.Subacc_Code, 1, 11) AS "Contract number", 
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
	WHEN (Price = 0) and CT_Const = 7 Then Size*1              /*вывод ДС*/
	WHEN (Price > 0) and CT_Const = 5 Then Size*Price          /*вывод ЦБ*/
	ELSE '0'
END AS float),
CASE ecp.CT_Const
	WHEN 4 THEN 'ввод ЦБ'
	WHEN 5 THEN 'вывод ЦБ'
	WHEN 6 THEN 'ввод ДС'
	WHEN 7 THEN 'вывод ДС'
END AS 'Тип операции',
ecp.Asset_ShortName,
IsNULL(dba.ISIN, ecp.Asset_ShortName) AS "ISIN",
ecp.Size AS "Количество",
ecp.Price AS "Цена закупки",
mi.LastPrice AS 'Рыночная цена',
CASE mi.PriceAsset_ID
	WHEN 8   THEN 'USD'
	WHEN 9   THEN 'EUR'
	WHEN 173 THEN 'RUB'
END AS 'Валюта котировки',
ecp.Size*mi.LastPrice AS 'Рыночная стоимость'
from backQORT_TDB.dbo.ExportCorrectPositions ecp
left join backQORT_DB.dbo.Assets dba ON dba.ShortName = ecp.Asset_ShortName
left join backQORT_DB.dbo.MarketInfo mi ON mi.Asset_ID = dba.id 
where RegistrationDate between 20230609 and 20230614  ---- between 20230609 and 20230615
and CT_Const IN (4, 5, 6, 7)
--and PlanDate <> 0
and dba.Enabled = 0
order by date, SubaccOwnerFirm_ShortName;



---импорт котировок из файла BLDL
insert into backQORT_TDB.dbo.ImportMarketInfo 
(Asset_ShortName, TSSection_Name, IsProcessed, OldDate, PriceAsset_ShortName) 
values ('GOOGL', 'Bloomberg_US', 1, 20230703,'USD');
select * from backQORT_DB.dbo.Assets where ISIN = 'GB0007188757';
select * from backQORT_DB.dbo.Assets where ShortName = 'NBHYEAH';
select * from backQORT_DB.dbo.Assets where id = 533;
select * from backQORT_TDB.dbo.ImportMarketInfo order  by importInsertDate desc; --where IsProcent = 'y';
select * from backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'US71654QBH48'  order by OldDate desc; --and TSSection_Name='Bloomberg_ID'
select * from backQORT_DB.dbo.TSSections;
---по инструменту с % ценой
select * from backQORT_TDB.dbo.Securities where IsProcent = 'y' and IsPriority;
select * from backQORT_TDB.dbo.Securities where Asset_ShortName = 'US900123CV04';
update backQORT_TDB.dbo.Securities set IsProcessed = 1, IsProcent = 'y' where Asset_ShortName = 'US900123CV04';---надо insert с et_const = 4
insert into backQORT_TDB.dbo.Securities (IsProcessed, ET_Const, SecCode,              Asset_ShortName,         TSSection_Name,           ShortName,               "Name",                    IsProcent,         LotSize)
                                 values (1,           4,       'US900123CV04',            'US900123CV04',    'Bloomberg_BGN',           'US900123CV04',            'TURKEY 6.35 08/10/24',   'y',                1);


select * from backQORT_DB.dbo.Securities where ShortName = 'US900123CV04';

select * from backQORT_DB.dbo.Assets where ViewName like '%Draft%';

select * from backQORT_DB.dbo.MarketInfoHist where short Asset_ID = 539 order by OldDate desc;
select * from backQORT_DB.dbo.Assets where id IN (select DISTINCT(Asset_ID) from backQORT_DB.dbo.MarketInfoHist where IsProcent = 'y');

---LU0955988976 IE00B8FMZ671
----Синхронизация таблиц dbo.Trades и dbo.Trades (QO-213496)
select * from backQORT_TDB.dbo.Trades where backQORT_TDB.dbo.Trades.SystemID IN (19, 20, 21, 22, 38, 24, 23, 39, 40, 25, 31, 32, 34, 35, 36, 30, 33, 37, 41, 42, 43, 45, 44, 46, 47 );   --233
select * from backQORT_DB.dbo.Trades;
---delete from backQORT_TDB.dbo.Trades where backQORT_TDB.dbo.Trades.SystemID NOT IN (19, 20, 21, 22, 38, 24, 23, 39, 40, 25, 31, 32, 34, 35, 36, 30, 33, 37, 41, 42, 43, 45, 44, 46, 47 );


select * from backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'MOMO';
delete backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'XS1405777596';
----вся информация по ЦБ дата котировки это OldDate
select IsProcent, A.ShortName as Asset_ShortName, TS.Name as TSSectionName, ACur.ShortName as PriceCurName, * from MarketInfoHist MIH (nolock)
Join Assets A (nolock) on A.id = MIH.Asset_ID
Join Assets ACur (nolock) on ACur.id = MIH.PriceAsset_ID
Join TSSections TS (nolock) on TS.id = A.PricingTSSection_ID
where MIH.Asset_ID in (select id from assets (nolock) where isin in ('IE00B4024J04'))order by MIH.OldDate desc;


/*В GUI отображаются таблицы основной БД, таблице "Биржевая информация на день торгов" соответствует таблица MarketrInfo БД.
Если же вам необходимо загрузить биржевую информацию через ПБД, это можно сделать с помощью таблицы ImportMarketInfo ПБД.*/
---история котировок в БД
select * from backQORT_DB.dbo.MarketInfoHist order by OldDate  --- where Asset_ID = 471;
select * from Assets where isin in ('LU0955988976');
---Таблица субсчетов
select * from backQORT_TDB.dbo.Subaccs;
----Кросс-курсы
Select * from backQORT_DB.dbo.CrossRatesHist where PriceAsset_ID = 8 and TradeAsset_ID in (9, 11, 173) order by TradeAsset_ID;
Select * from backQORT_DB.dbo.PositionHist 
---импорт курсов валют
Select * from backQORT_TDB.dbo.CrossRates where errorlog like '%_%';
---Опердни
Select * from backQORT_DB.dbo.OperationDays order by 2 desc;
select * from OperationDays order by Day;
Select * from backQORT_DB.dbo.PositionHist order by Date desc;
----ТЕСТ DEV
Select * from backQORT_DB_DEV.dbo.OperationDays order by 1 desc;

Select * from backQORT_DB_DEV.dbo.PositionHist order by Date desc;
Select * from backQORT_DB_DEV.dbo.OperationDays order by 2 desc;


select * from OperationDays (nolock) where Day >= 20230601 order by Day;
select * from PositionHist (nolock) where OldDate = 20230701;
----srvPositioner (QO-214174)
sp_helptext p_update_poshist
go
select * from ScriptsHistory (nolock) order by scriptVersion desc;

select * from PositionHist where OldDate=20230524 and Subacc_Id=2 and Account_id=59 and Asset_Id=454;

USE backQORT_DB
select date,OldDate, * from PositionHist (nolock);

select * from backQORT_DB_DEV.dbo.OperationDays order by Day;

----Проверить корректировки по счету отправленные из Корта в Квик
Select * from backQORT_DB.dbo.Subaccs;
select * from backQORT_DB.dbo.CorrectPositions where id = 563

select * from Subaccs where ID = 517;
select * from CorrectPositions where (created_date=20231205 and Subacc_ID=517) or id in (1123,1124);




select
    CONVERT (date, SYSDATETIME()) date_beg,
    CONVERT (date, SYSDATETIME()) date_end;

select  RegistrationDate from backQORT_TDB.dbo.ExportCorrectPositions
where RegistrationDate = 20230213;

select CONVERT(varchar,CAST(CAST(RegistrationDate as varchar(8)) as smalldatetime), 104) from backQORT_TDB.dbo.ExportCorrectPositions
where RegistrationDate = 20230213;

select RegistrationDate from backQORT_TDB.dbo.ExportCorrectPositions
where CONVERT(varchar,CAST(CAST(RegistrationDate as varchar(8)) as smalldatetime), 104) = '13.02.2023';



select CONVERT(varchar,CAST(CAST(RegistrationDate as varchar(8)) as smalldatetime), 104) from backQORT_TDB.dbo.ExportCorrectPositions
where CONVERT(varchar,CAST(CAST(RegistrationDate as varchar(8)) as smalldatetime), 104) = '13.02.2023';
select cast(FORMAT(cast(RegistrationDate), 'yyyMMdd') as int) from backQORT_TDB.dbo.ExportCorrectPositions


select CONVERT(varchar,CAST(CAST('20230609' as varchar(8)) as smalldatetime), 101)  from DUAL;


select * from backQORT_TDB.dbo.Assets where ISIN='US5949181045';

select * from MarketInfoHist where Asset_ID=447 and olddate='20230704';


select CONVERT(varchar,CAST(CAST(RegistrationDate as varchar(8)) as smalldatetime), 104) from backQORT_TDB.dbo.ExportCorrectPositions
/* МОНИТОРИНГ */
---образец
select 1 as result_id, concat('Для актива ', A.ShortName, ': ', A.ISIN, ' не указан эмитент.') as result 
from Assets A (nolock) Where EmitentFirm_ID = -1 and A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(ISIN) = 12;
---АКТИВЫ---
---NAME test
select 1 as result_id, concat('Для актива ', A.ShortName, ': ', A.ISIN, ' не указано полное наименование.') as result 
from Assets A where A.Name is null OR A.Name ='';
---NAME prod
select 1 as result_id, concat('Для актива ', A.ShortName, ': ', A.ISIN, ' не указано полное наименование.') as result 
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12 and A.Name is null and A.Name ='';
---A.ShortName <> A.ISIN
select 1 as result_id, concat('Для облигации ', A.ISIN, ' код актива не совпадает с ISIN.') as result 
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and A.AssetClass_Const in (6,7,9) and A.ShortName <> A.ISIN;
---A.ViewName <> A.ISIN
select 1 as result_id, concat('Для облигации ', A.ISIN, ' краткое наименование не совпадает с ISIN.') as result
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and A.AssetClass_Const in (6,7,9) and A.ViewName <> A.ISIN;
---A.Voices <> 1
select 1 as result_id, concat('Для актива ', A.ShortName, ':', A.ISIN, '.', ' не заполнено поле кол-во голосов') as result
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and A.Voices <> 1;
---Marking is NOT null and A.Marking <> ISIN for AssetClass_const in (6,7,9)
WITH ACTIV AS (select 
CASE
WHEN A.Marking in ('', null) THEN concat('Для актива ', A.ShortName, ':', A.ISIN, '.', ' не заполнено поле Маркировка ЦБ')
WHEN A.Marking <> A.ISIN and A.AssetClass_const in (6,7,9) THEN concat('Для актива ', A.ShortName, ':', A.ISIN, '.', ' для облигаций поле Маркировка ЦБ не совпадает с ISIN')
END AS result
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12)

select
CASE
WHEN A.Marking in ('', null) THEN 1
WHEN A.Marking <> A.ISIN and A.AssetClass_const in (6,7,9) THEN 2
END AS result_id,
CASE
WHEN A.Marking in ('', null) THEN concat('У актива ', A.ViewName, ':', A.ISIN, '.', ' не заполнено поле Маркировка')
WHEN A.Marking <> A.ISIN and A.AssetClass_const in (6,7,9) THEN concat('У облигации ', A.ViewName, ':', A.ISIN, '.', ' поле Маркировка не соответствует ISIN')
END AS result 
from Assets A (nolock) Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and (A.Marking = '' or (A.Marking <> A.ISIN and A.AssetClass_const in (6,7,9))) order by 1;
---PricingTSSection_ID is not null
select 1 as result_id, concat('У актива ', A.ViewName, ':', A.ISIN, '.', ' не заполнена секция для переоценки') as result
from Assets A (nolock) 
Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and A.PricingTSSection_ID = '' or A.PricingTSSection_ID is null;
---BaseValue IN ( '', 0)
select 1 as result_id, concat('У облигации ', A.ViewName, ':', A.ISIN, '.', ' не заполнена номинал') as result
from Assets A (nolock) 
Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and A.BaseValue IN ( '', 0)
and  A.AssetClass_const in (6,7,9);
---BaseCurrencyAsset_ID IN (-1, '')
select 1 as result_id, concat('У актива ', A.ViewName, ':', A.ISIN, '.', ' не указана валюта номинала') as result
from Assets A (nolock) 
Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
and BaseCurrencyAsset_ID IN (-1, '');
---securities for assets is true
select  1 as result_id, concat('У актива ', A.ViewName, ':', A.ISIN, '.', ' не указан инструмент на секции') as result from assets a 
where 
not exists (select * from securities s  (nolock) where s.IsTrading = 'y' and s.asset_id = a.id and TSSection_ID in (select id from TSSections (nolock) where name like 'Bloomberg_%'))
and A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12;
---черновик
select *
from Assets A (nolock) 
Where A.Enabled = 0 and A.AssetType_Const = 1 and A.IsTrading = 'y' and len(A.ISIN) = 12
---ИНСТРУМЕНТЫ---
select s.SecCode, a.ShortName from securities s
left join Assets A ON a.ID = s.Asset_ID
where s.Enabled = 0 and s.IsTrading = 'y'
and s.SecCode <> a.ShortName
;


select * from backQORT_TDB.dbo.Assets where Marking IN ('PIAHYII', '0P000101SN');

select * from backQORT_DB.dbo.Assets where Marking IN ('PIAHYII', '0P000101SN');
select * from backQORT_DB.dbo.Assets order by id;

select * from backQORT_DB.dbo.Assets where BaseCurrencyAsset_ID = 21;

select * from backQORT_DB.dbo.Assets where name like '%GBP%'; -- GBX = 789 , GBP = 21

/* проверка котировок по бумаге */ 
select IsProcent, A.ShortName as Asset_ShortName, TS.Name as TSSectionName, ACur.ShortName as PriceCurName, MIH.ClosePrice, MIH.MarketPrice, MIH.AvPrice, MIH.LastPrice, * from backQORT_DB.dbo.MarketInfoHist MIH (nolock)
Join backQORT_DB.dbo.Assets A (nolock) on A.id = MIH.Asset_ID
Join backQORT_DB.dbo.Assets ACur (nolock) on ACur.id = MIH.PriceAsset_ID
Join backQORT_DB.dbo.TSSections TS (nolock) on TS.id = A.PricingTSSection_ID
where MIH.Asset_ID in (select id from backQORT_DB.dbo.assets (nolock) where isin in ('IE00B3B8PX14'))order by MIH.OldDate;

DGE Bloomberg_LNC
select * from backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'DGE';



select Enabled, * from backQORT_DB.dbo.Trades where id=21;



---на БД проверка
select * from backQORT_DB.dbo.Trades where ID IN (626);



update backQORT_TDB.dbo.DataAlerts set RecordStatus = 2 where id = 4772;

select * from backQORT_TDB.dbo.DataAlerts where RecordStatus = 2;
select * from backQORT_TDB.dbo.DataAlerts where id = 4272;


---Таблица субсчетов
select * from backQORT_DB.dbo.Subaccs where SubAccCode = 'CL000000122';



select * from backQORT_DB.dbo.Firms where Name like '%Морокина%'; ---567


select * from backQORT_DB.dbo.ClientAgrees where OwnerFirm_ID=567;


select * from backQORT_DB.dbo.Subaccs where OwnerFirm_ID=567;

select * from backQORT_DB.dbo.Subaccs where ID = 919;

select * from backQORT_DB.dbo.Firms where Name like '%Ананьев%';

select Firm_ID,Tariff_ID,ClientAgree_ID,Agent_ID,CalcSubAcc_ID,StartDate,* from backQORT_DB.dbo.ClientTariffs where Firm_ID=468;


select * from backQORT_DB.dbo.CommissionCorrections order by 2,3; ---типы
select * from backQORT_DB.dbo.Commissions order by 1;

----ИМЯ-------------------------------CT_Const------
--Брокерская комиссия фикс.             55
--Дополнительная комиссия               32
--Комиссия за вывод ДС                  71
--Комиссия за задолженность по ГО       57
--Комиссия за конвертацию               30
--Комиссия за перевод                   29
select * from backQORT_TDB.dbo.ExportCorrectPositions where CT_Const IN (29, 30, 32, 55, 57, 71) order by CT_Const;


---Заявки(Ордера)
select * from backQORT_DB.dbo.Orders;
select * from backQORT_DB.dbo.Orders where OrderNum = 24052000000001;
dbo.P_TotalDeleteFromTable

---этапы сделки
select * from backQORT_DB.dbo.Phases ph where Trade_id = 1271;
select * from backQORT_DB.dbo.Trades where ID = 1271; 
select * from backQORT_DB.dbo.Phases (nolock) where Trade_ID=4526 order by PC_Const;

update backQORT_DB.dbo.Trades
set PayStatus='n',PayDate=0,PutStatus='n',PutDate=0
where id=1271


select * from Commissions (nolock) where id in (29)
select * from CommissionAssets (nolock) where Commission_ID in (29)
select * from CommissionAssetOptions (nolock) where Commission_ID in (29)
select * from CommissionCurrencies (nolock) where Commission_ID in (29) and CCT_Const = 2
select * from CommissionAccounts (nolock) where Commission_ID in (29)

----Правка НКД  backQORT_TDB.dbo.AccruedInt и backQORT_TDB.dbo.ImportMarketInfo
Select * from backQORT_TDB.dbo.AccruedInt;

Select * from backQORT_TDB.dbo.AccruedInt where Asset_ShortName = 'XS2285992397' and date between '20250522' and '20250609';
Select * from backQORT_TDB.dbo.AccruedInt where  AID = 127742;

update backQORT_TDB.dbo.AccruedInt set Volume = '649,31' where AID = 127742;


Select * from backQORT_TDB.dbo.ImportMarketInfo where Asset_ShortName = 'XS2285992397' and OldDate between '20250522' and '20250609' and Accruedint IS NOT NULL order by AID;
