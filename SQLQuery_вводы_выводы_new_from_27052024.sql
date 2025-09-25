/* �������� ������ ��� ��������� � USD */
WITH BASE AS ( select ecp.RegistrationDate AS "����_�����������", ecp.Date AS "����_����������",
ecp.SubaccOwnerFirm_ShortName AS "Client_Name", SUBSTRING(ecp.Subacc_Code, 1, 11) AS "Contract_number", 
ecp.CurrencyAsset_ShortName AS "Currency",  
"Inflows" = CAST(CASE 
	WHEN (Price = 0) and CT_Const = 6 Then Size*1           /*���� ��*/
	WHEN (Price > 0) and CT_Const = 4 Then Size*Price       /*���� ��*/
	ELSE '0'
	--WHEN /*(Price = 0) and*/ CT_Const = 7 Then 'no'       /*����� ��*/
	--WHEN /*(Price > 0) and*/ CT_Const = 5 Then 'no'       /*����� ��*/
END AS float),
"Outflows" = CAST(CASE
	--WHEN /*(Price = 0) and*/ CT_Const = 6 Then 'no'          /*���� ��*/
	--WHEN /*(Price > 0) and*/ CT_Const = 4 Then 'no'          /*���� ��*/
	WHEN Price = 0 and CT_Const = 7 Then Size*1              /*����� ��*/
	WHEN Price > 0 and CT_Const = 5 Then Size*Price          /*����� ��*/
	ELSE '0'
END AS float),
CASE ecp.CT_Const
	WHEN 4 THEN '���� ��'
	WHEN 5 THEN '����� ��'
	WHEN 6 THEN '���� ��'
	WHEN 7 THEN '����� ��'
END AS "���_��������",
ecp.Asset_ShortName,
IsNULL(dba.ISIN, ecp.Asset_ShortName) AS "ISIN",
ecp.Size      AS "����������",
ecp.Price     AS "����_�������",
dba.id
from backQORT_TDB.dbo.ExportCorrectPositions ecp
left join backQORT_DB.dbo.Assets dba ON dba.ShortName = ecp.Asset_ShortName
where ecp.Date between 20240628 and 20240704  /* ����� ������� ���� ����������. OLD RegistrationDate between 20240420 and 20240425     -- between 20240511 and 20240516  */
and CT_Const IN (4, 5, 6, 7)
and dba.Enabled = 0             /*��������� ������ (�������� ����� ID) ���� = 0 �� ������ ������� */
and ecp.IsCanceled = 'n'       /*������ ���������� ������, ��� 'y' */
),

CROSS_CURS AS (Select crh.Date, crh.OldDate, crh.TradeAsset_ID, crh.PriceAsset_ID, crh.Bid from backQORT_DB.dbo.CrossRatesHist crh 
where OldDate = 20240516  /* ����� ���� ������ ����� */
and crh.TradeAsset_ID IN (9, 11, 173, 21, 112) and crh.PriceAsset_ID = 8
),
						/* ���� ��������� �� MarketInfoHist as mih ���������� � �������� ������ ����� CrossRatesHist as crh */
KOTIR AS ( Select dba.ShortName, mih.LastPrice AS "��������_����", 
CASE mih.PriceAsset_ID
	WHEN 8   THEN 'USD'
	WHEN 9   THEN 'EUR'
	WHEN 11  THEN 'CNY'
	WHEN 173 THEN 'RUB'
	WHEN 21  THEN 'GBP'
END AS "������_���������",
mih.PriceAsset_ID
from backQORT_DB.dbo.MarketInfoHist mih 
inner join backQORT_DB.dbo.Assets dba ON dba.id = mih.Asset_ID
where mih.OldDate = 20240516  /* ����� ���� ��������� ��� ��*/
and dba.Enabled = 0
and mih.TSSection_ID IN /* �������� ����� �� ����� ��������� ��������� - �����, � ����� = 0, � ����� � ������ ����� � ������� ������� */
(169, 170, 171, 173, 174, 175, 176, 177, 178, 179, 181, 184, 188, 189, 197, 198, 199, 200, 201, 186) )  /* ������ ��� � "bloomberg_%", ���� � ���������������� ������ */

Select
    ����_�����������, ����_����������,
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
    ���_��������,
    Asset_ShortName,
    ISIN,
    ����������,
    ����_�������,
    ��������_����,
    ������_���������,
    "������_��_�_USD" = CASE
        WHEN KOTIR.PriceAsset_ID = 8 THEN ��������_���� * ���������� * 1
        WHEN KOTIR.PriceAsset_ID = 173 THEN ��������_���� * ���������� * Bid
        WHEN KOTIR.PriceAsset_ID = 9 THEN ��������_���� * ���������� * Bid
        WHEN KOTIR.PriceAsset_ID = 21 THEN ��������_���� * ���������� * Bid
        ELSE '0'
    END
From BASE
LEFT JOIN KOTIR ON KOTIR.ShortName = BASE.Asset_ShortName
LEFT JOIN CROSS_CURS ON (BASE.Asset_ShortName  = 'USD' AND CROSS_CURS.TradeAsset_ID = 8)
                     OR (BASE.Asset_ShortName <> 'USD' AND BASE.id = CROSS_CURS.TradeAsset_ID)
					 OR (KOTIR.PriceAsset_ID = CROSS_CURS.TradeAsset_ID)
 ;