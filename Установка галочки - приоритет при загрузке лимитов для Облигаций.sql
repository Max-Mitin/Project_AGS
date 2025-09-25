
select * from Assets where id IN (select DISTINCT(Asset_ID) from MarketInfoHist where IsProcent = 'y');
/***********ТЕСТ****************/
select at.shortname, at.name, sc.Asset_ID, sc.IsPriority, ts.Name from Assets at 
 join Securities sc ON sc.Asset_id = at.id
 join TSSections ts ON ts.id = sc.TSSection_ID
where at.id IN (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586)
and ts.id in(169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189);

update Securities set IsPriority = 'y' where Asset_id in (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586) 
and TSSection_ID in (169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189);

select * from Securities where Asset_id in (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586) 
and TSSection_ID in (169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189);

select * from backQORT_DB.dbo.Assets where shortname = 'XS2380057799';
select * from backQORT_DB.dbo.Securities sec order by Asset_ID;
select * from backQORT_DB.dbo.TSSections order by id;

169,	Bloomberg_BGN
170,	Bloomberg_US
171,	Bloomberg_LI
173,	Bloomberg_GR
174,	Bloomberg_TH
175,	Bloomberg_FP
176,	Bloomberg_LNC
177,	Bloomberg_JP
178,	Bloomberg_EXCH
179,	Bloomberg_LX
/*****************************/
/*OMS*/
select at.shortname, at.name, sc.Asset_ID, sc.IsPriority, ts.Name from backQORT_DB.dbo.Assets at 
 join backQORT_DB.dbo.Securities sc ON sc.Asset_id = at.id
 join backQORT_DB.dbo.TSSections ts ON ts.id = sc.TSSection_ID
where at.id IN (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586)
and ts.id in(164);

------
select at.shortname, at.name, sc.Asset_ID, sc.IsPriority, ts.Name from Assets at 
 join Securities sc ON sc.Asset_id = at.id
 join TSSections ts ON ts.id = sc.TSSection_ID
where at.id IN (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586)
and ts.id in(169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189);

select * from Securities where Asset_id in (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586) 
and TSSection_ID in (169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189);



/*ПРОД*/
***************************
select at.shortname, at.name, sc.Asset_ID, sc.IsPriority, ts.Name from backQORT_DB.dbo.Assets at 
 join backQORT_DB.dbo.Securities sc ON sc.Asset_id = at.id
 join backQORT_DB.dbo.TSSections ts ON ts.id = sc.TSSection_ID
where at.id IN (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586)
and ts.id in(169, 170, 171, 173, 174, 175, 176, 177, 178, 179);

update backQORT_DB.dbo.Securities set IsPriority = 'y' where Asset_id in (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586) 
and TSSection_ID in (169, 170, 171, 173, 174, 175, 176, 177, 178, 179);

select * from  backQORT_DB.dbo.Securities where Asset_id in (454, 488, 489, 491, 494, 532, 533, 534, 535, 545, 558, 559, 560, 561, 565, 568, 574, 575, 576, 577, 586) 
and TSSection_ID in (169, 170, 171, 173, 174, 175, 176, 177, 178, 179);

select * from backQORT_DB.dbo.Assets where shortname = 'XS2380057799';
select * from backQORT_DB.dbo.Securities sec order by Asset_ID;
select * from backQORT_DB.dbo.TSSections order by id;

169,	Bloomberg_BGN
170,	Bloomberg_US
171,	Bloomberg_LI
173,	Bloomberg_GR
174,	Bloomberg_TH
175,	Bloomberg_FP
176,	Bloomberg_LNC
177,	Bloomberg_JP
178,	Bloomberg_EXCH
179,	Bloomberg_LX
*****************************
