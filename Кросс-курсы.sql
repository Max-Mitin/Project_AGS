----ПБД
with course_usd as 
       (
       select cr.Date, cr.bid, TradeAsset_ShortName as usd_name,  PriceAsset_ShortName as kzt_name, qty
       from CrossRates  cr
       where cr.TradeAsset_ShortName = 'USD'  and cr.PriceAsset_ShortName = 'KZT'
       ),
       course_other as 
       (
       select cr.Date, cr.bid, TradeAsset_ShortName as other_name,  PriceAsset_ShortName as kzt_name
       from CrossRates  cr
       where cr.TradeAsset_ShortName in ('GBX') and cr.PriceAsset_ShortName = 'KZT'     
       )
       insert into CrossRates (IsProcessed, InfoSource, Date, TradeAsset_ShortName, PriceAsset_ShortName,  Bid, Ask, Qty, Time)
       select distinct 1, 'MainCurBank', cr_other.Date, cr_other.other_name, cr_usd.usd_name, cr_other.Bid/cr_usd.Bid, cr_other.Bid/cr_usd.Bid,1, 120336874 
       from course_other  cr_other
             join course_usd cr_usd on cr_other.Date = cr_usd.Date
       where cr_other.Date = convert(int,convert(varchar, 20240503, 112)) -- Здесь подставить нужную дату, по умолчанию - сегодня
       union
       select distinct 1, 'MainCurBank', cr_usd.Date, cr_usd.kzt_name, cr_usd.usd_name, qty/cr_usd.Bid, qty/cr_usd.Bid,1, 120336874
       from course_usd cr_usd
       where cr_usd.Date = convert(int,convert(varchar, 20240503, 112)); -- Здесь подставить нужную дату, по умолчанию - сегодня


/* */

 'KZT' ('AED', 'EUR','RUB','CNY','GBP') GBX
---Выполнять перед добавлением крос-курса для пенсов стерлинга GBX (пенсы стерлингов)
Insert into CrossRates (IsProcessed, InfoSource, Date, TradeAsset_ShortName, PriceAsset_ShortName,  Bid, Ask, Qty, Time)
select 1, 'MainCurBank',  Date, 'GBX', 'KZT', Bid/100, Ask/100, Qty, Time
from backQORT_TDB.dbo.CrossRates
where TradeAsset_ShortName = 'GBP' and PriceAsset_ShortName = 'KZT'
and Date = convert(int,convert(varchar, 20240503, 112));
/*ПБД Проверить после выполнения скрипта наличие добавленного кросс-курса 
TradeAsset - валюта котируемая(для которой цену(PriceAsset) ставят по умолчанию в KZT=112,  PriceAsset - валюта цены в которой продажа/покупка, если =8 это кросс курс в $ */
select * from  CrossRates where 
--TradeAsset_ShortName IN ( 'GBX' ) and
PriceAsset_ShortName='USD' and 
date like '20240614' order by date desc;

delete from backQORT_TDB.dbo.CrossRates where AID=1813594;

select * from  CrossRates order by date desc;

--на БД проверка (переключить подключение)см описание проверки для ПБД
select * from  CrossRatesHist where TradeAsset_ID = 37 and date like '202406__' order by date desc;

Select ass.ShortName, crh.* from  CrossRatesHist crh
join Assets ass ON crh.TradeAsset_ID = ass.id
where PriceAsset_ID = 8 and OldDate = '20240503' and ass.ShortName = 'GBX';

select * from  CrossRates where 
TradeAsset_ShortName = 'GBP' and
--PriceAsset_ShortName='USD' and 
date like '202311__' order by date desc;

---БД Проверить кросс-курсы по валютам на дату или ВСЕ без даты
Select
* from backQORT_DB.dbo.CrossRatesHist crh 
--crh.Date, crh.OldDate, crh.TradeAsset_ID, crh.PriceAsset_ID, crh.Bid from backQORT_DB.dbo.CrossRatesHist crh 
where 
OldDate = 20240612  /* Выбор даты курсов валют */  
--and TradeAsset_ID IN (9, 11, 37, 173) 
and PriceAsset_ID = 8;

---ПБД Проверить кросс-курсы по валютам на дату или ВСЕ без даты
Select
* from backQORT_TDB.dbo.CrossRates cr
--crh.Date, crh.OldDate, crh.TradeAsset_ID, crh.PriceAsset_ID, crh.Bid from backQORT_DB.dbo.CrossRatesHist crh 
where 
Date = 20240612  /* Выбор даты курсов валют */  
--and TradeAsset_ID IN (9, 11, 37, 173) 
--and PriceAsset_ID = 8;

---ПБД проверить в обоих таблицах, что есть курсы по нужной валюте (по которой будем делать кросс) и по доллару есть, по обоим валютам курсы должны быть
       select cr.Date, cr.bid, TradeAsset_ShortName as other_name,  PriceAsset_ShortName as kzt_name
       from CrossRates  cr
       where cr.TradeAsset_ShortName in ('AED') and cr.PriceAsset_ShortName = 'KZT'    order by cr.Date desc
	   
	   select cr.Date, cr.bid, TradeAsset_ShortName as usd_name,  PriceAsset_ShortName as kzt_name, qty
       from CrossRates  cr
       where cr.TradeAsset_ShortName = 'USD'  and cr.PriceAsset_ShortName = 'KZT'    order by cr.Date desc;



select * from backQORT_DB.dbo.Assets order by ID ;
select * from backQORT_DB.dbo.Assets where Name = 'CAD' order by ID ; --id 164 Канадский доллар
select * from backQORT_DB.dbo.Assets where Name = 'NOK' order by ID ; --id 165 Норвежская крона
select * from backQORT_DB.dbo.Assets where Name = 'CHF' order by ID ; --id 169 Швейцарский франк
select * from backQORT_DB.dbo.Assets where Name = 'AED' order by ID ; --id  37  AED
select * from backQORT_DB.dbo.Assets where Name = 'KZT'
select * from  CrossRateshist where OldDate = '20231214';

insert into CrossRates (IsProcessed, InfoSource, Date, TradeAsset_ShortName, PriceAsset_ShortName,  Bid, Ask, Qty, Time) VALUES (1, 'MainCurBank', 20231001, 'CAD', 'KZT', 353.5, 353.5, 1, 120336874);

select * from backQORT_DB.dbo.Assets where ID IN (9, 11, 12, 17, 21, 24, 27, 29, 34, 35, 37, 41, 45, 51, 56, 65, 67, 69, 81, 82, 92, 93, 97, 104, 109, 112, 113, 114, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 173, 789); 
