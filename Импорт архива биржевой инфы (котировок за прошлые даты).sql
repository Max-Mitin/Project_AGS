---Пример АРКИ
insert into backQORT_TDB.dbo.ImportMarketInfo (Asset_ShortName, TSSection_Name, IsProcessed, OldDate, IsProcent, ClosePrice, LastBid, LastPrice) 
values ('ОФЗ-26238-ПД', 'МБ Т+1: Корп. облигации', 1, 20230626, 'y', 71, 71, 71);
---Конечная таблица для загрузки
Select * from backQORT_TDB.dbo.ImportMarketInfo where IsProcent <> 'n';
delete from backQORT_TDB.dbo.ImportMarketInfo where TSSection_Name = 'Custom';
---Из письма Кати, поля которые она хочет видеть в конечной таблице
Asset_ShortName,  --из excel
TSSection_Name, --из excel
IsProcessed,  -- 1
OldDate, --из excel 
IsProcent, --‘n’
ClosePrice,  -- из excel price
LastPrice, -- из excel price
AvPrice, -- из excel price
MarketPrice -- из excel price

USE [backQORT_TDB]
GO
---моя промежуточная таблица
Select * from backQORT_TDB.dbo.TMPForImportMarketINF;
delete from backQORT_TDB.dbo.TMPForImportMarketINF;

CREATE TABLE [dbo].[TMPForImportMarketINF](
[Asset_ShortName] [varchar](48) NULL,
[TSSection_Name] [varchar](64) NULL,
[IsProcessed] [smallint] NULL,
[OldDate] [MDATE] NULL,
[IsProcent] [varchar](48) NULL,
[ClosePrice] [float] NULL,
[LastPrice] [float] NULL,
[AvPrice] [float] NULL,
[MarketPrice] [float] NULL
);

GO
---тестовый инсерт в промежутку
INSERT INTO backQORT_TDB.dbo.TMPForImportMarketINF (Asset_ShortName, TSSection_Name, IsProcessed, OldDate, IsProcent, ClosePrice, LastPrice, AvPrice, MarketPrice)
VALUES ('GOOGL', 'Bloomberg_US', 1, 20230601, 'n', 122.87, 122.87, 122.87, 122.87);
---импорт в таблицу GUI Архив Биржевой информации !!!БОЙ!!!
INSERT INTO backQORT_TDB.dbo.ImportMarketInfo (Asset_ShortName, TSSection_Name, IsProcessed, OldDate, IsProcent, ClosePrice, LastPrice, AvPrice, MarketPrice)
SELECT Asset_ShortName, TSSection_Name, IsProcessed, OldDate, IsProcent, ClosePrice, LastPrice, AvPrice, MarketPrice
FROM 
    backQORT_TDB.dbo.TMPForImportMarketINF;  


Select * from backQORT_DB.dbo.MarketInfoHist where ID = 1;
delete backQORT_DB.dbo.MarketInfoHist where ID  IN (1, 4, 7, 10, 2, 8, 5, 11, 6, 12, 3, 9, 84, 92, 850, 851, 852, 
853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 283, 284, 285, 286, 
287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305);
