_union_IC
----------
SELECT mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID, mdl_ic_discoveg_ac.RoofRPark, Sum(mdl_ic_discoveg_ac.SqFt) AS TotArea, "VEG" as ictype, Count(mdl_ic_discoveg_ac.ICID) AS CountOfICID
FROM mdl_ic_discoveg_ac
GROUP BY mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID, mdl_ic_discoveg_ac.RoofRPark;

union

SELECT mdl_ic_drywell_ac.ParcelID, mdl_ic_drywell_ac.DivideID, mdl_ic_drywell_ac.RoofRPark, Sum(mdl_ic_drywell_ac.SqFt) AS TotArea, "DW" as ictype, Count(mdl_ic_drywell_ac.ICID) AS CountOfICID
FROM mdl_ic_drywell_ac
GROUP BY mdl_ic_drywell_ac.ParcelID, mdl_ic_drywell_ac.DivideID, mdl_ic_drywell_ac.RoofRPark;

union

SELECT mdl_ic_store_ac.ParcelID, mdl_ic_store_ac.DivideID, mdl_ic_store_ac.RoofRPark, Sum(mdl_ic_store_ac.SqFt) AS TotArea, "STORE" as ictype, Count(mdl_ic_store_ac.ICID) AS CountOfICID
FROM mdl_ic_store_ac
GROUP BY mdl_ic_store_ac.ParcelID, mdl_ic_store_ac.DivideID, mdl_ic_store_ac.RoofRPark;

union
SELECT mdl_ic_SWPlnt_ac.ParcelID, mdl_ic_SWPlnt_ac.DivideID, mdl_ic_SWPlnt_ac.RoofRPark, Sum(mdl_ic_SWPlnt_ac.SqFt) AS TotArea, "SP" AS ictype, Count(mdl_ic_SWPlnt_ac.ICID) AS CountOfICID
FROM mdl_ic_SWPlnt_ac
GROUP BY mdl_ic_SWPlnt_ac.ParcelID, mdl_ic_SWPlnt_ac.DivideID, mdl_ic_SWPlnt_ac.RoofRPark;

UNION SELECT mdl_ic_Infilt_ac.ParcelID, mdl_ic_Infilt_ac.DivideID, mdl_ic_Infilt_ac.RoofRPark, Sum(mdl_ic_Infilt_ac.SqFt) AS TotArea, "IN" AS ictype, Count(mdl_ic_Infilt_ac.ICID) AS CountOfICID
FROM mdl_ic_Infilt_ac
GROUP BY mdl_ic_Infilt_ac.ParcelID, mdl_ic_Infilt_ac.DivideID, mdl_ic_Infilt_ac.RoofRPark;


app_DiscoVeg_EX
----------
INSERT INTO mdl_ic_DiscoVeg_ac ( ParcelID, DivideID, RoofRPark, assumeKey, ApplyAreaTF, SqFt, Effectiveness, Comment, TimeFrame, AppendDate )
SELECT mst_ic_DiscoVeg_ac.ParcelID, mst_ic_DiscoVeg_ac.DivideID, mst_ic_DiscoVeg_ac.RoofRPark, mst_ic_DiscoVeg_ac.assumekey, mst_ic_DiscoVeg_ac.ApplyAreaTF, mst_ic_DiscoVeg_ac.SqFt, mst_ic_DiscoVeg_ac.Effectiveness, mst_ic_DiscoVeg_ac.Comment, mst_ic_DiscoVeg_ac.TimeFrame, mst_ic_DiscoVeg_ac.AppendDate
FROM mdl_DirSC_ac INNER JOIN mst_ic_DiscoVeg_ac ON (mdl_DirSC_ac.DivideID = mst_ic_DiscoVeg_ac.DivideID) AND (mdl_DirSC_ac.ParcelID = mst_ic_DiscoVeg_ac.ParcelID)
WHERE (((mst_ic_DiscoVeg_ac.TimeFrame)="EX"));


app_DiscoVeg_FU
----------
INSERT INTO mdl_ic_DiscoVeg_ac ( ParcelID, DivideID, RoofRPark, assumeKey, SqFt, Effectiveness, ApplyAreaTF, Comment, TimeFrame, AppendDate )
SELECT mst_ic_DiscoVeg_ac.ParcelID, mst_ic_DiscoVeg_ac.DivideID, mst_ic_DiscoVeg_ac.RoofRPark, mst_ic_DiscoVeg_ac.assumekey, mst_ic_DiscoVeg_ac.SqFt, mst_ic_DiscoVeg_ac.Effectiveness, mst_ic_DiscoVeg_ac.ApplyAreaTF, mst_ic_DiscoVeg_ac.Comment, mst_ic_DiscoVeg_ac.TimeFrame, mst_ic_DiscoVeg_ac.AppendDate
FROM mdl_DirSC_ac INNER JOIN mst_ic_DiscoVeg_ac ON (mdl_DirSC_ac.DivideID = mst_ic_DiscoVeg_ac.DivideID) AND (mdl_DirSC_ac.ParcelID = mst_ic_DiscoVeg_ac.ParcelID)
WHERE (((mst_ic_DiscoVeg_ac.TimeFrame)="FU"));


app_Drywell_EX
----------
INSERT INTO mdl_ic_DryWell_ac ( ParcelID, DivideID, RoofRPark, assumeKey, SqFt, ApplyAreaTF, Comment, TimeFrame, AppendDate )
SELECT mst_ic_Drywell_ac.ParcelID, mst_ic_Drywell_ac.DivideID, mst_ic_Drywell_ac.RoofRPark, mst_ic_Drywell_ac.assumeKey, mst_ic_Drywell_ac.SqFt, mst_ic_Drywell_ac.ApplyAreaTF, mst_ic_Drywell_ac.Comment, mst_ic_Drywell_ac.TimeFrame, mst_ic_Drywell_ac.AppendDate
FROM mdl_DirSC_ac INNER JOIN mst_ic_Drywell_ac ON (mdl_DirSC_ac.DivideID = mst_ic_Drywell_ac.DivideID) AND (mdl_DirSC_ac.ParcelID = mst_ic_Drywell_ac.ParcelID)
WHERE (((mst_ic_Drywell_ac.TimeFrame)="EX"));


app_Drywell_FU
----------
INSERT INTO mdl_ic_DryWell_ac ( ParcelID, DivideID, RoofRPark, assumeKey, SqFt, ApplyAreaTF, Comment, TimeFrame, AppendDate )
SELECT mst_ic_Drywell_ac.ParcelID, mst_ic_Drywell_ac.DivideID, mst_ic_Drywell_ac.RoofRPark, mst_ic_Drywell_ac.assumeKey, mst_ic_Drywell_ac.SqFt, mst_ic_Drywell_ac.ApplyAreaTF, mst_ic_Drywell_ac.Comment, mst_ic_Drywell_ac.TimeFrame, mst_ic_Drywell_ac.AppendDate
FROM mdl_DirSC_ac INNER JOIN mst_ic_Drywell_ac ON (mdl_DirSC_ac.DivideID = mst_ic_Drywell_ac.DivideID) AND (mdl_DirSC_ac.ParcelID = mst_ic_Drywell_ac.ParcelID)
WHERE (((mst_ic_Drywell_ac.TimeFrame)="FU"));


del_discoVeg_All
----------
DELETE mdl_ic_DiscoVeg_ac.*
FROM mdl_ic_DiscoVeg_ac;


del_discoVeg_SAN
----------
DELETE mdl_ic_DiscoVeg_ac.assumeKey
FROM mdl_ic_DiscoVeg_ac
WHERE (((mdl_ic_DiscoVeg_ac.assumeKey)="_SAN"));


del_Drywell_All
----------
DELETE mdl_ic_DryWell_ac.*
FROM mdl_ic_DryWell_ac;


ICFt00Initialize
----------
UPDATE mdl_DirSC_ac SET mdl_DirSC_ac.ICFtRoof = 0, mdl_DirSC_ac.ICFtParking = 0, mdl_DirSC_ac.c_RFtosurfFt = 0, mdl_DirSC_ac.c_PKtosurfFt = 0, mdl_DirSC_ac.c_RFtosurfImpFt = 0, mdl_DirSC_ac.c_PKtosurfImpFt = 0;


ICFt01UnionDelete
----------
DELETE [_union_IC_sum].*
FROM _union_IC_sum;


ICFt02UnionAppend
----------
INSERT INTO _union_IC_sum ( ParcelID, DivideID, RoofRPark, SumOfTotArea )
SELECT [_union_IC].ParcelID, [_union_IC].DivideID, [_union_IC].RoofRPark, Sum([_union_IC].TotArea) AS SumOfTotArea
FROM _union_IC
GROUP BY [_union_IC].ParcelID, [_union_IC].DivideID, [_union_IC].RoofRPark;


ICFt03UpdateParkICFt
----------
UPDATE _union_IC_sum INNER JOIN mdl_DirSC_ac ON ([_union_IC_sum].DivideID = mdl_DirSC_ac.DivideID) AND ([_union_IC_sum].ParcelID = mdl_DirSC_ac.ParcelID) SET mdl_DirSC_ac.ICFtParking = [sumoftotarea]
WHERE ((([_union_IC_sum].RoofRPark)="P"));


ICFt03UpdateRoofICFt
----------
UPDATE _union_IC_sum INNER JOIN mdl_DirSC_ac ON ([_union_IC_sum].DivideID = mdl_DirSC_ac.DivideID) AND ([_union_IC_sum].ParcelID = mdl_DirSC_ac.ParcelID) SET mdl_DirSC_ac.ICFtRoof = [sumoftotarea]
WHERE ((([_union_IC_sum].RoofRPark)="R"));


ICFt04appSanitaryPark
----------
INSERT INTO mdl_ic_discoveg_ac ( ParcelID, DivideID, RoofRPark, assumeKey, SqFt, ApplyAreaTF, Effectiveness, Comment )
SELECT mdl_DirSC_ac.ParcelID, mdl_DirSC_ac.DivideID, "P" AS Expr1, "_SAN" AS assumeKey, [PKAreaFt]-[ICFtParking] AS NewSqFt, "NA" AS ApplyAreaTF, IIf([GenEX]="SFR",0.7,0) AS Effectiveness, "DiscoClass S" AS Comment
FROM mdl_DirSC_ac
WHERE ((([PKAreaFt]-[ICFtParking])>0) AND ((mdl_DirSC_ac.DiscoClass)="S"));


ICFt04appSanitaryRoof
----------
INSERT INTO mdl_ic_discoveg_ac ( ParcelID, DivideID, RoofRPark, SqFt, assumeKey, ApplyAreaTF, Effectiveness, Comment )
SELECT mdl_DirSC_ac.ParcelID, mdl_DirSC_ac.DivideID, "R" AS Expr1, [RFAreaFt]-[ICFtRoof] AS NewSqFt, "_SAN" AS assumeKey, "NA" AS ApplyareaTF, IIf([GenEX]="SFR",0.7,0) AS Effectiveness, "DiscoClass S" AS Comment
FROM mdl_DirSC_ac
WHERE ((([RFAreaFt]-[ICFtRoof])>0) AND ((mdl_DirSC_ac.DiscoClass)="S"));


ICVegAppendPark
----------
INSERT INTO _sumDiscoVegPark ( ParcelID, DivideID, SumOfSqFt, ImpSqFt )
SELECT mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID, Sum(mdl_ic_discoveg_ac.SqFt) AS SumOfSqFt, Sum(Int([SqFt]*(1-[Effectiveness]))) AS ImpSqFt
FROM mdl_ic_discoveg_ac
WHERE (((mdl_ic_discoveg_ac.RoofRPark)="P"))
GROUP BY mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID;


ICVegAppendRoof
----------
INSERT INTO _sumDiscoVegRoof ( ParcelID, DivideID, SumOfSqFt, ImpSqFt )
SELECT mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID, Sum(mdl_ic_discoveg_ac.SqFt) AS SumOfSqFt, Sum(Int([SqFt]*(1-[Effectiveness]))) AS ImpSqFt
FROM mdl_ic_discoveg_ac
WHERE (((mdl_ic_discoveg_ac.RoofRPark)="R"))
GROUP BY mdl_ic_discoveg_ac.ParcelID, mdl_ic_discoveg_ac.DivideID;


ICVegDelPark
----------
DELETE [_sumDiscoVegPark].*
FROM _sumDiscoVegPark;


ICVegDelRoof
----------
DELETE [_sumDiscoVegRoof].*
FROM _sumDiscoVegRoof;


ICVegUpdatePark
----------
UPDATE mdl_DirSC_ac INNER JOIN _sumDiscoVegPark ON (mdl_DirSC_ac.DivideID = [_sumDiscoVegPark].DivideID) AND (mdl_DirSC_ac.ParcelID = [_sumDiscoVegPark].ParcelID) SET mdl_DirSC_ac.c_PKtosurfFt = [sumofSQft], mdl_DirSC_ac.c_PKtosurfImpFt = [impSqFt];


ICVegUpdateRoof
----------
UPDATE _SumDiscoVegRoof INNER JOIN mdl_DirSC_ac ON ([_SumDiscoVegRoof].DivideID = mdl_DirSC_ac.DivideID) AND ([_SumDiscoVegRoof].ParcelID = mdl_DirSC_ac.ParcelID) SET mdl_DirSC_ac.c_RFtosurfFt = [sumofSQft], mdl_DirSC_ac.c_RFtosurfImpFt = [impSqFt];


SetEXBaseFlow
----------
UPDATE mdl_DirSC_ac SET mdl_DirSC_ac.BaseFlow = [BaseFlowEX];


