select 
  C.CODER   --  id кодировщика в ФЭНСИ
  ,C.SHARE   --  id актива в ФЭНСИ
  ,C.CODE   --  код Тикера актива в ФЭНСИ
  ,F.NAME CODER_NAME --  наименование кодировщика в ФЭНСИ  
  ,S.MNEM  SHARE_MNEM --  мнемоника актива в ФЭНСИ
  ,CONVERT(int,null) SPD_CODER --  id кодировщика в СПД
  ,CONVERT(int,null) SPD_SHARE  --  id актива в СПД
  ,CONVERT(int,null) SPD_TICKER --  id тикера в СПД
  ,CONVERT(varchar(50),null) SPD_CODE  --  код Тикера актива в СПД
  ,CONVERT(varchar(250),null) SPD_CODER_NAME  --  наименование кодировщика в СПД
  ,CONVERT(varchar(250),null) SPD_SHARE_NAME --  наименование актива в СПД
  ,CONVERT(varchar(250),null) SPD_Text01  --  примечание к активу в СПД
  ,CONVERT(varchar(250),null) SPD_Text02  --  наименование ДЕПО актива в СПД
into #TempFansy
from [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_VALUE_CODERS C
join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F on F.SELF_ID=C.CODER and LAST_FLAG=1
join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_SHARES S on S.ID=C.SHARE


--select distinct CODER_NAME from #TempFansy  --  все кодировщики Тикеров активов в ФЭНСИ

--проставим id аналогичного кодировщика из СПД
--select TF.*, A.NameAnalit 
update TF set 
  SPD_CODER  = M2.ClientId,
  SPD_CODER_NAME = A.NameAnalit
from #TempFansy TF
left join NaviconMDM.dbo.CodesMappingDetails M1 on M1.EntityName='LegalEntity' collate Cyrillic_General_CI_AS 
  and M1.ClientName='FANSY' collate Cyrillic_General_CI_AS 
  and M1.ClientId=TF.CODER 
left join NaviconMDM.dbo.CodesMappingDetails M2 on M2.EntityName='LegalEntity' collate Cyrillic_General_CI_AS 
  and M2.ClientName='SPD' collate Cyrillic_General_CI_AS 
  and M2.MasterCode=M1.MasterCode 
left join [SPD-NAV].GL_SPD.dbo.Analit A on A.id=M2.ClientId
--where A.id is null --не подставились id-шники:
  --ANNA-CFI
  --НП "РТС" (Классический рынок)
  --Санкт-Петербургская валютная биржа

--проставим id аналогичного актива из СПД
--select TF.*, A.NameAnalit
update TF set 
  SPD_SHARE = M2.ClientId,
  SPD_SHARE_NAME = A.NameAnalit,
  SPD_Text01 = A.Text01,
  SPD_Text02 = A.Text02
from #TempFansy TF
left join NaviconMDM.dbo.CodesMappingDetails M1 on M1.EntityName='Asset' collate Cyrillic_General_CI_AS 
  and M1.ClientName='FANSY' collate Cyrillic_General_CI_AS 
  and M1.ClientId=TF.SHARE
left join NaviconMDM.dbo.CodesMappingDetails M2 on M2.EntityName='Asset' collate Cyrillic_General_CI_AS 
  and M2.ClientName='SPD' collate Cyrillic_General_CI_AS 
  and M2.MasterCode=M1.MasterCode 
left join [SPD-NAV].GL_SPD.dbo.Analit A on A.id=M2.ClientId

--проставим код Тикера актива из СПД + id Тикера актива из СПД
--select TF.*,
update TF set
  SPD_CODE =  case  --  код Тикера актива из СПД
  when SPD_CODER_NAME='ЗАО "ФБ ММВБ"' then A.Text04
  when SPD_CODER_NAME='НКО ЗАО НРД' then A.Text09
  when SPD_CODER_NAME='ЗАО "ДКК"' then A.Text07
  when SPD_CODER_NAME='ФСФР России' then A.Text12
  when SPD_CODER_NAME='ОАО "Фондовая биржа РТС"' then A.Text05
  when CODER_NAME='НП "РТС" (Классический рынок)' then A.Text02  --с этим кодировщиком надо уточнить
  when CODER_NAME='Санкт-Петербургская валютная биржа' then A.Text03 --с этим кодировщиком надо уточнить
 end,
  SPD_TICKER = case  --  id Тикера актива из СПД
  when SPD_CODER_NAME='ОАО "Специализированный депозитарий "ИНФИНИТУМ"' then null  --этот Тикер находится в СПД в спр.110 Активы (Код СПЕКТР)
 else 
  A.id 
  end 
--  ,A.IDAnalit,A.Text01,A.Text02,A.Text03,A.Text04,A.Text05,A.Text06,A.Text07,A.Text08,A.Text09,A.Text10,A.Text11,A.Text12,A.Text13  
from #TempFansy TF
join [SPD-NAV].GL_SPD.dbo.Analit A1 on A1.id=TF.SPD_SHARE
join [SPD-NAV].GL_SPD.dbo.Analit A on A.IDAnalitType=130 and A.Int01=A1.IDAnalit


--!!!ПРОБЛЕМНЫЕ ТИКЕРЫ: замэпленные тикеры ФЭНСИ и СПД, у которых не совпадают коды тикеров (поля CODE и SPD_CODE)
--  основные причины несовпадения: пробелы в начале/конце кода, а также символы кода на русском/английском регистрах
select TF.*
from #TempFansy TF
where SPD_CODE is not null
  and CODE<>SPD_CODE collate Cyrillic_General_CI_AS
  
--все тикеры ФЭНСИ: если SPD_CODE is not null, то тикер замэплен на СПД 
select * from #TempFansy TF
--where SPD_CODE is not null  --отбор только замэпленных
order by SHARE, CODER

drop table #TempFansy
