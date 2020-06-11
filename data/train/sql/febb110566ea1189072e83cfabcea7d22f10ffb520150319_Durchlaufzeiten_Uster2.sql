Select
	trans_nav.Externe_BelegNr 
	,trans_uster.AuftragsNr
	
	--,DHL_Kunde.Sendungsnummer
	--,tf.[ArtikelNr]
	--,case
	--	when tf.[ArtikelNr]  in (
	--						 Select 
	--							distinct [EAN] collate Latin1_General_CI_AS as ArtikelNr 
	--							 FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie]
	--							 where (([Hoehe]>1200 or ([Laenge]>600 and [Breite]>600)) or [Volumen_L]>128)
	--							) then 1 else 0 end as Big_Item_oder_Sperrgut
	--,tf.[Zahlungsmethode]
	--,tn.[Betrugsfall]
	--,tn.[Warteliste]
	,trans_uster.LänderCode
	--,trans_uster.Name
	,trans_uster.PLZ
	,trans_nav.Webshop_Auftrag
	,trans_nav.Verkaufsbeleg_erstellt
	,trans_uster.Übergabe_Uster
	,max(rückmeldung_uster.Rückmeldung_Uster) as Rückmeldung_Uster
	--,DHL_Kunde.[DHL_Eingang]
	--,DHL_Kunde.[Auftrag_Kunde]
    ,cast(datediff(hour, trans_nav.Webshop_Auftrag,trans_uster.Übergabe_Uster) as Numeric)/24 Bruttozeit_Webshop_Uster_Tag
	--,cast(datediff(hour, tf.[Übergabe_Fiege], DHL_Kunde.[DHL_Eingang]) as Numeric)/24 as Gesamtzeit_Fiege_DHL_Tag
	--,cast(datediff(hour, DHL_Kunde.[DHL_Eingang], DHL_Kunde.[Auftrag_Kunde]) as Numeric)/24 as Gesamtzeit_DHL_Kunde_Tag
	,cast(datediff(hour, trans_nav.Webshop_Auftrag, rückmeldung_uster.Rückmeldung_Uster) as Numeric)/24 Bruttozeit_Webshop_Rückmeldung_Uster
	, cast(datediff(hour, trans_nav.Webshop_Auftrag, trans_nav.Verkaufsbeleg_erstellt)  as Numeric)/24 as Bruttozeiteit_Warteliste
	
	,BI_Data.dbo.networkdays(trans_nav.Webshop_Auftrag,trans_uster.Übergabe_Uster) as Nettozeit_Webshop_Übergabe_Uster
	,BI_Data.dbo.networkdays(trans_nav.Webshop_Auftrag,rückmeldung_uster.Rückmeldung_Uster) as Nettozeit_Webshop_Rückmeldung_Uster
	--,BI_Data.dbo.networkdays(trans_nav.Webshop_Auftrag,trans_nav.Verkaufsbeleg_erstellt) as Nettozeit_Webshop_Warteliste
	--,case when tn.[Warteliste]=1 then cast(datediff(hour, tn.[Webshop_Auftrag], tn.[Verkaufsbeleg_erstellt])  as Numeric)/24  else 0 end as Zeit_Warteliste
	from /*1. Tabelle*/
	(select
 cdh.[Order Created at] as Webshop_Auftrag
 , BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) as Verkaufsbeleg_erstellt
, nvws.[No_] as Verkaufsrechnung
, nvws.[Sales Document No_] as AuftragsNr
, cdh.[ExternalDocumentNo] as Externe_BelegNr
, cdh.[FraudInfo] as Betrugsfall
,cdh.[Wait] as Warteliste
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)                                
	left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvws with (nolock)
	 on cdh.[ExternalDocumentNo]=nvws.[External Document No_] collate Latin1_General_CI_AS
  where  nvws.[Shop Code]='WINDELN_CH'
  and cdh.[Order Created at] between '2015-02-01' and '2015-02-28') as trans_nav 
  left join /*2. Tabelle*/ (
    Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Übergabe_Uster
   ,ffsh.[No_] as AuftragsNr
   ,ffsl.[No_] as ArtikelNr
   ,ffsh.[External Document No_] as Externe_BelegNr 
   ,ffsh.[Payment Method Code] as Zahlungsmethode
   ,ffsh.[Ship-to Country_Region Code] as LänderCode
   ,cr.[Name]as Name
   ,ffsh.[Ship-to Post Code] as PLZ
   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
		join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl  
	    on (ffsh.[No_]=ffsl.[Document No_]
		and ffsh.[Entry No_]=ffsl.[Document Entry No_]) 
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='USTER'
	--and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2015-02-01' and '2015-02-28' 
	and ffsh.[Type]=0
	and ffsh.[Entry No_]=1
	and ffsl.[Type]=2
	) as trans_uster
	on trans_nav.Externe_BelegNr=trans_uster.Externe_BelegNr collate Latin1_General_CI_AS
	join /*3.Tabelle*/
	(
	 Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Rückmeldung_Uster
   , ffsh.[No_] as AuftragsNr
   , ffsh.[External Document No_] as Externe_BelegNr
  
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where ffsh.[Location Code]='USTER'
	--and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2015-02-01' and '2015-02-28' 
	and ffsh.[Type]=1 /*Rückmeldung Uster*/
		--group by BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]),ffsh.[No_],ffsh.[External Document No_],ffsh.[Entry No_]  
	) as rückmeldung_uster
	on trans_uster.AuftragsNr=rückmeldung_uster.AuftragsNr collate Latin1_General_CI_AS
	where trans_nav.Webshop_Auftrag>= '2015-02-01' 
	and trans_nav.Webshop_Auftrag<= '2015-02-28'

	 group by 
 trans_nav.Externe_BelegNr 
,trans_uster.AuftragsNr
,trans_uster.LänderCode
,trans_uster.Name
,trans_uster.PLZ
,trans_nav.Webshop_Auftrag
,trans_nav.Verkaufsbeleg_erstellt
,trans_uster.Übergabe_Uster
,rückmeldung_uster.Rückmeldung_Uster	