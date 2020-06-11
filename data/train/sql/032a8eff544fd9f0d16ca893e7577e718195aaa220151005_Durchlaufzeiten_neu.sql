select 
trans_nav.Externe_BelegNr
,trans_fiege.AuftragsNr
,trans_fiege.Zahlungsmethode
,trans_fiege.LänderCode
,trans_fiege.Name
,trans_fiege.PLZ
,trans_nav.Betrugsfall
,trans_nav.Warteliste
,trans_nav.Webshop_Auftrag
,trans_nav.Untergrenze
,trans_nav.Obergrenze
--,cast(trans_nav.Webshop_Auftrag as date) as Datum
--,datename(mm,trans_nav.Webshop_Auftrag) as Monat
,trans_nav.Verkaufsbeleg_erstellt
,trans_fiege.Übergabe_Fiege
,trans_fiege.CutOff_Übertragen_am
,rückmeldung_fiege.Rückmeldung_Fiege as Rückmedung_Fiege
,DHL_Kunde.DHL_Eingang
,DHL_Kunde.Auftrag_Kunde
,DHL_Kunde.Geliefert

,cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60 Laufzeit_WIN_Stunden

,case when cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60<'1' then 'bis_1_Stunde'
      when (cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60>='1' and cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60<'2') then 'bis_2_Stunden'
	  when (cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60>='2' and cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60<'3') then 'bis_3_Stunden'
	  when (cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60>='3' and cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60<'4') then 'bis_4_Stunden'
	  when (cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60>='4' and cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60<'5') then 'bis_5_Stunden'
	  when (cast(datediff(MINUTE,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as decimal(10,2))/60>='5') then 'ueber_5_Stunden'
	  end as Laufzeit_WIN_Stunden2



--,cast(datediff(hour,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as Numeric)/24 Bruttotage_Webshop_Fiege
--,cast(datediff(hour,trans_fiege.Übergabe_Fiege, DHL_Kunde.DHL_Eingang) as Numeric)/24 as Bruttotage_Fiege_DHL
--,cast(datediff(hour,DHL_Kunde.DHL_Eingang, DHL_Kunde.Auftrag_Kunde) as Numeric)/24 as Bruttotage_DHL_Kunde
--,cast(datediff(hour,trans_nav.Webshop_Auftrag, DHL_Kunde.Auftrag_Kunde) as Numeric)/24 Bruttotage_Webshop_Kunde
,case when BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,DHL_Kunde.Auftrag_Kunde)<='0' then cast(datediff(hour,trans_nav.Webshop_Auftrag,DHL_Kunde.Auftrag_Kunde) as Decimal(10,2))/24 else BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,DHL_Kunde.Auftrag_Kunde) end as Laufzeit_Gesamt
,case when BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,trans_fiege.CutOff_Übertragen_am)<='0' then cast(datediff(hour,trans_nav.Webshop_Auftrag,trans_fiege.CutOff_Übertragen_am) as decimal(10,2))/24 else BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,trans_fiege.CutOff_Übertragen_am) end as Laufzeit_WIN
, case when BI_Data.dbo.networkdays_dec(trans_fiege.CutOff_Übertragen_am,DHL_Kunde.DHL_Eingang)<='0' 
			then 
				case 
					when BI_Data.dbo.networkdays_dec(trans_fiege.Übergabe_Fiege,rückmeldung_fiege.Rückmeldung_Fiege) <='0' 
						then cast(datediff(hour,trans_fiege.Übergabe_Fiege,rückmeldung_fiege.Rückmeldung_Fiege) as decimal(10,2))/24 
					else BI_Data.dbo.networkdays_dec(trans_fiege.Übergabe_Fiege,rückmeldung_fiege.Rückmeldung_Fiege) end
			else
					BI_Data.dbo.networkdays_dec(trans_fiege.CutOff_Übertragen_am,DHL_Kunde.DHL_Eingang) end as Laufzeit_Fiege
				      

--,case when BI_Data.dbo.networkdays_dec(trans_fiege.CutOff_Übertragen_am,DHL_Kunde.DHL_Eingang)<='0' then cast(datediff(hour,trans_fiege.CutOff_Übertragen_am,DHL_Kunde.DHL_Eingang) as decimal(10,2))/24 
--      when BI_Data.dbo.networkdays_dec(trans_fiege.Übergabe_Fiege,rückmeldung_fiege.Rückmeldung_Fiege) <='0' then cast(datediff(hour,trans_fiege.Übergabe_Fiege,rückmeldung_fiege.Rückmeldung_Fiege) as decimal(10,2))/24   
--	  else BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,DHL_Kunde.Auftrag_Kunde) end as Laufzeit_Fiege
,case when BI_Data.dbo.networkdays_dec(DHL_Kunde.DHL_Eingang,DHL_Kunde.Auftrag_Kunde)<='0' then cast(datediff(hour,DHL_Kunde.DHL_Eingang,DHL_Kunde.Auftrag_Kunde) as decimal(10,2))/24 else BI_Data.dbo.networkdays_dec(DHL_Kunde.DHL_Eingang,DHL_Kunde.Auftrag_Kunde) end as Laufzeit_DHL

 from  
 /*1.Tabelle*/
 (
 select  
 case when cdh.[Order Created at]>BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) then BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) else cdh.[Order Created at] end as Webshop_Auftrag
 ,CAST(FLOOR(CAST(cdh.[Order Created at] AS FLOAT)) + (FLOOR((CAST(cdh.[Order Created at] AS FLOAT) - FLOOR(CAST(cdh.[Order Created at] AS FLOAT))) * 24.0) + (3.0/86400000.0)) / 24.0 AS DATETIME) as Untergrenze
  ,CAST(ceiling(CAST(cdh.[Order Created at] AS FLOAT)) + (ceiling((CAST(cdh.[Order Created at] AS FLOAT) - ceiling(CAST(cdh.[Order Created at] AS FLOAT))) * 24.0) + (3.0/86400000.0)) / 24.0 AS DATETIME) as Obergrenze
 , BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) as Verkaufsbeleg_erstellt
, nvws.[No_] as Verkaufsrechnung
,nvws.[Status] as Status_NAV
, nvws.[Sales Document No_] as AuftragsNr
, cdh.[ExternalDocumentNo] as Externe_BelegNr
, cdh.[FraudInfo] as Betrugsfall
,cdh.[Wait] as Warteliste
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)                                
	left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvws with (nolock)
	 on cdh.[ExternalDocumentNo]=nvws.[External Document No_] collate Latin1_General_CI_AS
  where  nvws.[Shop Code]='WINDELN_DE'
    --and nvws.[Sales Document rendered at] between '2015-01-01' and getdate()
	) as trans_nav
/*2. Tabelle*/
left join ( Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Übergabe_Fiege
   ,ffsh.[No_] as AuftragsNr
   --,ffsl.[No_] as ArtikelNr
   ,ffsh.[External Document No_] as Externe_BelegNr 
   ,ffsh.[Payment Method Code] as Zahlungsmethode
   ,ffsh.[Ship-to Country_Region Code] as LänderCode
   ,cr.[Name]as Name
   ,ffsh.[Ship-to Post Code] as PLZ
   ,cast (
			case 
				when cast (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as time) > '15:00' 
					then dateadd(dd,1,dateadd(hh, 6,cast(cast(dateadd(dd,0,BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime))) 
					else BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) end as datetime) as CutOff_Übertragen_am

   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
			join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Type]=0
	and ffsh.[Entry No_]=1
		) as trans_fiege
		on trans_nav.Externe_BelegNr=trans_fiege.Externe_BelegNr collate Latin1_General_CI_AS 
/*3.Tabelle*/		
		join (Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Rückmeldung_Fiege
   , ffsh.[No_] as AuftragsNr
   , ffsh.[External Document No_]
   ,ROW_NUMBER() OVER (PARTITION BY ffsh.[External Document No_]  ORDER BY BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])  desc) AS seq
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where ffsh.[Location Code]='BER_FIEGE'
	--and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2015-01-01' and getdate() 
	and ffsh.[Type]=1) rückmeldung_fiege
		on trans_fiege.AuftragsNr=rückmeldung_fiege.AuftragsNr collate Latin1_General_CI_AS

/*4.Tabelle*/
join(select 
		 pst.[OrderID] as AuftragsNr
		, pst.[OrderTimestamp]
		,pst.[isDelivered] as Geliefert
		, case 
			when (pst.[KnownToPostalServiceTimestamp] > pst.[PostalServiceTimestamp] or pst.[KnownToPostalServiceTimestamp] is Null)  then pst.[PostalServiceTimestamp]
			else pst.[KnownToPostalServiceTimestamp] end as DHL_Eingang
 , pst.[DeliveryTimestamp] as Auftrag_Kunde
 FROM [BI_Data].[dbo].[PostalServiceTracking] pst  with (nolock)
 where pst.[isKnownToPostalService]=1
 ) as DHL_Kunde
	on rückmeldung_fiege.AuftragsNr=DHL_Kunde.AuftragsNr collate Latin1_General_CI_AS
where trans_nav.Webshop_Auftrag>= '2015-01-01' 
and rückmeldung_fiege.seq=1 


group by 
trans_nav.Externe_BelegNr
,trans_fiege.AuftragsNr
,trans_fiege.Zahlungsmethode
,trans_fiege.LänderCode
,trans_fiege.Name
,trans_fiege.PLZ
,trans_nav.Betrugsfall
,trans_nav.Warteliste
,trans_nav.Webshop_Auftrag
,trans_nav.Verkaufsbeleg_erstellt
,trans_fiege.Übergabe_Fiege
,DHL_Kunde.DHL_Eingang
,DHL_Kunde.Auftrag_Kunde
,DHL_Kunde.Geliefert
,trans_fiege.CutOff_Übertragen_am
,rückmeldung_fiege.Rückmeldung_Fiege
,trans_nav.Untergrenze
,trans_nav.Obergrenze
