SELECT  
 cast(encsh.[Order Date] as date) as Datum 
 ,sum(case when enca.[Customer Type Id]=4 then 1 else 0 end) as CHN_Kunden
 ,sum(case when enca.[Customer Type Id]=1 then 1 else 0 end) as DE_Kunden
  
    FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCAccount] enca
  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader]encsh with (nolock)
	on encsh.[Sell-to Account No_]=enca.[No_] collate Latin1_General_CI_AS
 -- join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesLine] encsl with (nolock)
	--on encsh.[No_]=encsl.[Document No_] collate Latin1_General_CI_AS
  
  where encsh.[Order Date]>='2015-01-26'
  and encsh.[Order Date]<=getdate()
  and encsh.[Shop Code]='WINDELN_DE'
  group by cast(encsh.[Order Date] as date) 
  order by cast(encsh.[Order Date] as date) 