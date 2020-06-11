SET XACT_ABORT ON
BEGIN TRAN

--*************************************************************************************************
-- сопоставление записей 109 спр СКАУТ-бух со счетами депо ФЭНСИ
--*************************************************************************************************
--select * from [SC1C-NAV].GL_INF.dbo.AnalitColumns where IDAnalitType=109 --ищем id-шники исторических полей
select 
 A.id, A.IDAnalit --id
 ,A.NameAnalit --наименование
 ,FullName = isnull(AH1.Value, A.Text02) --полное наименование
 ,FullNameAcc = isnull(AH2.Value, A.Text10) --полное наименование для счетов и актов
 ,INN1 = ltrim(rtrim(A.NumAnalit)) --ИНН
 ,KPP1 = ltrim(rtrim(isnull(AH3.Value, A.Text05))) --КПП
 ,OGRN1 = ltrim(rtrim(A.Text01)) --ОГРН
 ,OKPO1 = ltrim(rtrim(A.Text07)) --ОКПО
 ,DepoCode = ltrim(rtrim(A.Text20)) --код ДЕПО (последние 5 цифр счет ДЕПО) 
into #TempSCOUT
from [SC1C-NAV].GL_INF.[dbo].[Analit] A
left join [SC1C-NAV].GL_INF.dbo.AnalitHistory AH1 
	on AH1.IDAnalitType=109 and AH1.IDAnalit=A.IDAnalit and AH1.IDAnalitColumns=188 and AH1.DateTo is null --полное наименование
left join [SC1C-NAV].GL_INF.dbo.AnalitHistory AH2 
	on AH2.IDAnalitType=109 and AH2.IDAnalit=A.IDAnalit and AH2.IDAnalitColumns=291 and AH2.DateTo is null --полное наименование для счетов и актов 
left join [SC1C-NAV].GL_INF.dbo.AnalitHistory AH3 
	on AH3.IDAnalitType=109 and AH3.IDAnalit=A.IDAnalit and AH3.IDAnalitColumns=191 and AH3.DateTo is null --КПП
where A.IDAnalitType = 109


select 
 ID_F = T.ID 
 ,T.NUMBER
 ,NAME_DEPOACC = T.NAME 
 ,F.SELF_ID
 ,NAME_DEPONENT = F.NAME 
 ,INN = ltrim(rtrim(F.INN))
 ,KPP = ltrim(rtrim(F.KPP))
 ,OKPO = ltrim(rtrim(U.OKPO))
 ,OGRN = ltrim(rtrim(U.OGRN))
into #TempFANSY
from [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS T
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_CLIENTS_REC R on R.CLIENT=T.ID and R.E_DATE='01.01.9999' 
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F on F.SELF_ID=T.FACE and F.LAST_FLAG=1
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_U_FACES U on U.FACE=F.SELF_ID
where PLAN_ID=4

select 
 A.id AS ScoutCOde
 ,F.ID_F AS FansyCode
into #Temp
from #TempSCOUT A
left join #TempFANSY F on 
 len(isnull(A.DepoCode,''))=5 --в СКАУТ длина кода = 5
 and A.DepoCode like '[0-9][0-9][0-9][0-9][0-9]' --в СКАУТ код цифровой
 and F.NUMBER like '%'+A.DepoCode collate Cyrillic_General_CI_AS --последние 5 цифр счета в ФЭНСИ совпадают с кодом депо в СКАУТ
 and (F.NUMBER like 'KIK/000/%' or F.NUMBER like 'SDP/000/%') --номер счета депо в ФЭНСИ начинается с KIK или SDP
 --не делаем привязку к счетам вида: '%/NCC/%', '%/SPC/%', ... 
 --(иначе получим ситуацию, когда два счета в НСИ смотрят на 1 запись в 109 спр СКАУТ)
 and F.NUMBER like '%/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' --последние 8 символов номера счета в ФЭНСИ д.б. цифрами (этим отсекаем мэпинг на счета вида SDP/000/1-УК00250)
where 1=1
-- and ID_F is not null --записи id 109 спр СКАУТ сопоставилась запись ID_F счета ДЕПО ФЭНСИ
 and len(isnull(A.DepoCode,''))=5 --в СКАУТ длина кода = 5
 and A.DepoCode like '[0-9][0-9][0-9][0-9][0-9]' --в СКАУТ код цифровой
order by 
 A.DepoCode --, A.FullName, A.FullNameAcc, F.NUMBER


SELECT * FROM #Temp

SELECT t.ScoutCOde, cdFansyAccount.MasterCode
INTO #AccountScout
FROM #Temp t
JOIN NaviconMDM.dbo.CodesMappingDetails cdFansyAccount
ON t.FansyCode = cdFansyAccount.ClientId AND cdFansyAccount.EntityName = 'AccountDEPO' AND cdFansyAccount.ClientName = 'Fansy'

PRINT'INSERTING MAPPING TO SCOUTBUH'

INSERT INTO NaviconMDM.dbo.CodesMappingDetails 
(ClientId,ClientName,EntityName,MasterCode)
SELECT ScoutCOde,'SCOUT_BUH','AccountDEPO',MasterCode
FROM #AccountScout

drop table #TempSCOUT;
drop table #TempFANSY;
DROP TABLE #Temp;

COMMIT TRAN