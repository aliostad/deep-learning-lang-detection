SET XACT_ABORT ON
BEGIN TRAN

--*************************************************************************************************
--  сопоставление записей спр 500
--*************************************************************************************************
--в 500 спр. СПД 2121 записей (+20 записей-дублей, ктр д.б. удалены)
select 
    A.id    AS AnalitId                                                                             --id счета ДЕПО в СПД
    ,F.ID_F   AS FansyId                                                              --id, номер и наименование счета ДЕПО в ФЭНСИ
    into #Temp
from [SPD-NAV].GL_SPD.dbo.Analit A
left join [SPD-NAV].GL_SPD.dbo.Analit A109 on A109.IDAnalitType=109 and A109.IDAnalit=A.Int01
left join [SPD-NAV].GL_SPD.dbo.Analit A501 on A501.IDAnalitType=501 and A501.IDAnalit=A.Int02
left join   (
                select T.ID ID_F, T.NUMBER, T.NAME NAMEDEPO, F.SELF_ID, F.NAME 
                from [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS T
                left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS_REC R on R.CLIENT=T.ID and R.E_DATE='01.01.9999' 
                left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F on F.SELF_ID=T.FACE and F.LAST_FLAG=1
                where PLAN_ID=4
            ) F on F.NUMBER=A.NameAnalit collate Cyrillic_General_CI_AS
where A.IDAnalitType=500 
    and A.IDAnalit  not in (5854, 5825, 3305842, 5840, 5827, 5844, 5830, 5832, 5845, 5563, 5828, 5836, 5823, 5312, 5838, 5837, 5853, 5843, 5849, 5824)


--результаты сопоставления
--select * from #Temp where ID_F is null
--        --  всего записей                   - 2121
--        --  сопоставляются по № счета       - 2121
--        --  не сопоставляются по № счета    - 0

----для сопоставившегося счета ДЕПО выходим на разных ЮЛ-депонентов в НСИ 
--select 
--    T.NameAnalit    
----  ,T.id_Deponent, T.IDAnalit_Deponent, T.NameAnalit_Deponent
----  ,T.SELF_ID, T.NAME
--    ,LE1.Name, LE1.FullName, LE1.INN, LE1.OGRN, LE1.OKPO
--    ,LE2.Name Name_F, LE2.FullName FullName_F, LE2.INN INN_F, LE2.OGRN OGRN_F, LE2.OKPO OKPO_F
--from #Temp T
--left join NaviconMDM.dbo.CodesMappingDetails M1 on M1.ClientName='SPD' and M1.EntityName='LegalEntity' and M1.ClientId=T.id_Deponent
--left join NaviconMDM.dbo.CodesMappingDetails M2 on M2.ClientName='FANSY' and M2.EntityName='LegalEntity' and M2.ClientId=T.SELF_ID
--left join NaviconMDM.dbo.CodesMappingDetails M3 on M3.ClientName='NSI' and M3.EntityName='LegalEntity' and M3.MasterCode=M1.MasterCode
--left join NaviconMDM.dbo.CodesMappingDetails M4 on M4.ClientName='NSI' and M4.EntityName='LegalEntity' and M4.MasterCode=M2.MasterCode
--left join MDS.mdm.Infinitum_LegalEntity LE1 on LE1.Code=M3.ClientId collate Cyrillic_General_100_CS_AS
--left join MDS.mdm.Infinitum_LegalEntity LE2 on LE2.Code=M4.ClientId collate Cyrillic_General_100_CS_AS
--where 1=1
--    and M1.MasterCode<>M2.MasterCode
--order by 
--    LE1.Name



--*************************************************************************************************
--  сопоставление записей спр 503
--*************************************************************************************************
/*
--дубли в 503 спр (по номеру счета) = 15 записей
select A.id, A.IDAnalit, A.NameAnalit, A.Int01, A.Int02, A.Int03, A.Int04, A.Int05, A.Text01, A.Text02
from [SPD-NAV].GL_SPD.dbo.Analit A 
where IDAnalitType=503 and Text01 in (select Text01 from [SPD-NAV].GL_SPD.dbo.Analit where IDAnalitType=503 group by Text01 having COUNT(*)>1)
order by A.Text01, A.NameAnalit
*/

--в 503 спр. СПД 3960 записей

INSERT INTO #Temp
(AnalitId,FansyId)
select 
    A.id  AS AnalitId                                                                                           --id и код счета в СПД
    ,F.ID_F AS FansyId                                                                                          --id счета в ФЭНСИ 
from [SPD-NAV].GL_SPD.dbo.Analit A
left join [SPD-NAV].GL_SPD.dbo.Analit A109 on A109.IDAnalitType=109 and A109.IDAnalit=A.Int01
left join [SPD-NAV].GL_SPD.dbo.Analit A504 on A504.IDAnalitType=504 and A504.IDAnalit=A.Int03
left join [SPD-NAV].GL_SPD.dbo.Analit AR on AR.IDAnalitType=503 and AR.IDAnalit=A.Int04
left join   (
                select T.ID ID_F, T.NUMBER, R.LINK_NUMBER, T.NAME NAMEDEPO, F.SELF_ID, F.NAME NAME_DEPONENT
                from [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS T
                left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS_REC R on R.CLIENT=T.ID and R.E_DATE='01.01.9999' 
                left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F on F.SELF_ID=T.FACE and F.LAST_FLAG=1
                where PLAN_ID=4
            ) F on F.NUMBER=A.Text01 collate Cyrillic_General_CI_AS --and F.LINK_NUMBER=A.Text02 collate Cyrillic_General_CI_AS
			AND A.NameAnalit COLLATE Cyrillic_General_CI_AS=F.NAMEDEPO
where A.IDAnalitType=503 
--  and F.ID_F is null
order by A.NameAnalit

--результаты сопоставления
--select id, IDAnalit, NameAnalit, Text01, Text02
--from #Temp where ID_F is null
        --  всего записей                   - 3960
        --  сопоставляются по № счета       - 3954
        --  не сопоставляются по № счета    - 6

--ПРЕДЛОЖЕНИЕ: в мэпинг НСИ вносить только те записи, у которых совпадает (помимо номера) наименование счета !!!
--(тогда остается 1 дубль: счет HL/31MC0171900000B11)
--select * from #Temp where NameAnalit=NAMEDEPO collate Cyrillic_General_CI_AS

SELECT * FROM #Temp

SELECT t.AnalitId, cdSpdAccount.MasterCode
INTO #AccountSPD
FROM #Temp t
JOIN NaviconMDM.dbo.CodesMappingDetails cdSpdAccount
ON t.FansyId = cdSpdAccount.ClientId AND cdSpdAccount.EntityName = 'AccountDEPO' AND cdSpdAccount.ClientName = 'Fansy'

INSERT INTO NaviconMDM.dbo.CodesMappingDetails 
(ClientId,ClientName,EntityName,MasterCode)
SELECT AnalitId,'SPD','AccountDEPO',MasterCode
FROM #AccountSPD


DROP TABLE #AccountSPD;
DROP TABLE #Temp;

COMMIT TRAN