with
maxmengemilch as
(
Select
	cast(cdh.[OrderDate] as date) as AuftragsDatum
	,cdh.[ExternalDocumentNo] as Externe_BelegNr
	,nvsh.[Sell-to Account No_] as KundenNr
	,nva.[Customer No_] as DebitorenNr
	,cdh.[FraudInfo] as FraudInfo
	from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvsh with (nolock)
		on cdh.[ExternalDocumentNo]=nvsh.[External Document No_]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCAccount] nva with (nolock)
		on nva.[No_]=nvsh.[Sell-to Account No_]
	where cdh.[FraudInfo]='MaxMengeMilch'
	and cdh.[OrderDate]>='2014-01-01'
	and cdh.[OrderDate]<='2014-12-31'
	and cdh.[Shop Code]='WINDELN_DE'
	and nvsh.[Status]=3 /*Auftrag wurde storniert*/

),
bestellung as
(Select
	cast(cdh.[OrderDate] as date) as AuftragsDatum
	,cdh.[ExternalDocumentNo] as Externe_BelegNr
	,nvsh.[Sell-to Account No_] as KundenNr
	,nva.[Customer No_] as DebitorenNr
	--,cdh.[FraudInfo] as FraudInfo
	from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvsh with (nolock)
		on cdh.[ExternalDocumentNo]=nvsh.[External Document No_]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCAccount] nva with (nolock)
		on nva.[No_]=nvsh.[Sell-to Account No_]
	--where cdh.[FraudInfo]='MaxMengeMilch'
	where cdh.[OrderDate]>='2014-01-01'
	and cdh.[Shop Code]='WINDELN_DE'
	--and nvsh.[Status]=2 /*wurde geliefert*/

)
Select
maxmengemilch.AuftragsDatum	
,maxmengemilch.Externe_BelegNr
,maxmengemilch.KundenNr
,maxmengemilch.DebitorenNr
,sum(case when (bestellung.AuftragsDatum > dateadd(day,7,maxmengemilch.AuftragsDatum) and bestellung.KundenNr=maxmengemilch.KundenNr) then 1 else 0 end)

from maxmengemilch with(nolock)
left join bestellung with (nolock)
on maxmengemilch.KundenNr=bestellung.KundenNr
group by maxmengemilch.AuftragsDatum	
,maxmengemilch.Externe_BelegNr
,maxmengemilch.KundenNr
,maxmengemilch.DebitorenNr

	