/*
Stornierte Aufträge ohne Grund 
Kein Eintrag in Webshop etc.
*/

select distinct ncsh.[External Document No_]
		, ncsh.[Order Date]
		, ncsh.[Ship-to Name]
		, ncsh.[Ship-to Country Code]
		, ncsh.[Shop Payment Method Code]
		, ncsh.[Sales Document No_]			-- Beleg erstellt
		, ncsh.[Sales Document rendered at]
		, a.[Customer Type Id]
		, ncsh.FraudInfo
		, ncsh.Canceled
		, cast(ncsh.[Sub Total Gross Amount] as decimal(10,2)) as Gross_Amount
		, sh.[Order No_] as Sales_Header
		, sih.No_ as Sales_Invoice_Header
		, ffsh.No_ as FF_Sales_Header
		, ffsh.Type
		, ffsh.[Status Fulfillment]
from Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh with (nolock)
join Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayNavCAccount] a with (nolock)
	on ncsh.[Sell-to Account No_] = a.No_
left outer join Urban_Nav600_SL.dbo.[Urban-Brand GmbH$Sales Header] sh with (nolock)
	on ncsh.[External Document No_] = sh.[External Document No_]
left outer join 
(SELECT dffsh.[External Document No_]
		, dffsh.No_
		, dffsh.[Entry No_]
		, dffsh.Status
		, dffsh.[Status Fulfillment]
		, dffsh.Type
		, RANK() OVER (PARTITION BY dffsh.[No_] ORDER BY dffsh.[Entry No_] DESC) as Rank
From Urban_Nav600_SL.dbo.[Urban-Brand GmbH$eBayFFSalesHeader] dffsh with (nolock)
where dffsh.[Order Date] >= '2015-01-01') as ffsh 										-- Hier nur den letzten Fulfillmentstatus, also where ffsh.Rank = 1
	on ffsh.[External Document No_] = ncsh.[External Document No_]
left outer join Urban_Nav600_SL.dbo.[Urban-Brand GmbH$Sales Invoice Header] sih with (nolock)
	on sih.[External Document No_] = ncsh.[External Document No_]
where ncsh.Canceled = 0 																-- manuell im Webshop storniert
	and ncsh.[Shop Payment Method Code] not in ('prepayhyp', 'checkmo')					-- Vorkasse ohne Zahlungseingang storniert
	and not (ncsh.[Shop Payment Method Code] = 'NAV_LAST' and ncsh.FraudInfo = 'VK') 	-- Lastschrift auf Vorkasse umgestellt und storniert 
	and ncsh.[Order Date] between '2015-01-01' and '2015-04-01'							-- Keine Aufträge momentan in Fulillment															
	and (sh.[Order No_] is null and sih.No_ is null)									-- Kein Sales Invoice oder Auftrag
	and ncsh.[Shop Code] = 'WINDELN_DE'													-- Nur Shop Windeln.de
	and (ffsh.Rank = 1 or ffsh.Rank is null)											-- Letzter Status in Fulfillment oder kein Fulfillmentstatus
	and (ffsh.Type <> 2	or ffsh.Type is null)											-- Nicht in Fulfillment storniert oder kein Fulfillmentauftrag