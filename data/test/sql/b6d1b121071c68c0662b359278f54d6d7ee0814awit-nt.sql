
SELECT mx.tid, NewTrans_Create_Date date,
       CASE WHEN
        (SELECT COUNT(*) FROM tblNewTyreStock
         WHERE mx.serial=NewStock_Tyre_Serial AND mx.code=NewStock_Tyre_Code)>0
        THEN 1 ELSE 0
        END InStock, Comp_Name
FROM
(SELECT NewTransDetail_NewTrans_ID tid, NewTransDetail_Tyre_Serial serial, NewTransDetail_Tyre_Code code
FROM tblNewTyreTransactionDetail
WHERE NewTransDetail_NewTrans_ID LIKE 'NTO1301001%'
GROUP BY NewTransDetail_NewTrans_ID) mx
LEFT OUTER JOIN tblNewTyreTransaction
ON mx.tid=NewTrans_ID
LEFT OUTER JOIN tblDocument
ON mx.tid=Doc_Transaction_ID
LEFT OUTER JOIN tblCompany
ON Doc_Comp_ID=Comp_ID
ORDER BY NewTrans_Create_Date DESC

--SELECT NewTransDetail_Tyre_Serial NewStock_Tyre_Serial, NewTransDetail_Tyre_Code NewStock_Tyre_Code
--FROM tblNewTyreTransactionDetail
--WHERE NewTransDetail_NewTrans_ID='NTO13010014'

--INSERT INTO tblNewTyreStock
--SELECT NewTransDetail_Tyre_Serial NewStock_Tyre_Serial, NewTransDetail_Tyre_Code NewStock_Tyre_Code
--FROM tblNewTyreTransactionDetail
--WHERE NewTransDetail_NewTrans_ID='NTO13010015' --'NTO13010014' --'NTO13010020'

--SELECT NewTransDetail_NewTrans_ID, MAX(NewTransDetail_Serial), COUNT(NewTransDetail_Tyre_Serial)
--FROM tblNewTyreTransactionDetail
--WHERE NewTransDetail_NewTrans_ID LIKE 'NTO1301002%'
--GROUP BY NewTransDetail_NewTrans_ID


--SELECT * FROM tblNewTyreStock

--SELECT mx.tid
--FROM
--(SELECT NewTransDetail_NewTrans_ID tid, NewTransDetail_Tyre_Serial, NewTransDetail_Tyre_Code
--FROM tblNewTyreTransactionDetail
--WHERE NewTransDetail_Tyre_Serial LIKE '5211321%'
--GROUP BY NewTransDetail_NewTrans_ID) mx


--SELECT mx.tid, ProdTrans_Create_Date date,
  --CASE WHEN
    --(SELECT COUNT(*) FROM tblProductionStock WHERE ProdStock_Casing_ID=mx.casing)>0
  --THEN 1 ELSE 0
  --END InStock, Comp_Name
--FROM 
--(SELECT ProdTransDetail_ProdTrans_ID tid, MAX(ProdTransDetail_Serial) sn, ProdTransDetail_Casing_ID casing
--FROM tblProductionTransactionDetail
--WHERE ProdTransDetail_ProdTrans_ID LIKE 'PRO%'
--GROUP BY ProdTransDetail_ProdTrans_ID) mx
--LEFT OUTER JOIN tblCasing
--ON mx.casing=Casing_ID
--LEFT OUTER JOIN tblCompany
--ON Casing_Owner_ID=Comp_ID

--LEFT OUTER JOIN tblProductionTransaction
--ON mx.tid=ProdTrans_ID
--WHERE Casing_OwnerBranch_ID=-1
--ORDER BY ProdTrans_Create_Date DESC

;

