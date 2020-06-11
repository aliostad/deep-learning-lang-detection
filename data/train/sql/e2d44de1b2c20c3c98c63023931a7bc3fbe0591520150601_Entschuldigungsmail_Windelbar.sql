with cte as (

Select
ncsh1.[External Document No_] as Auftragsnummer
,
--'['+
(Select
concat(it2.[Description],' ',it2.[Description],',',cast(ncsl2.[Quantity] as int),',',cast(ncsl2.[Unit Price] as decimal (10,2)),',')

from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh2 with(nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesLine] ncsl2  with(nolock)
on ncsh2.[No_]=ncsl2.[Document No_]
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it2  with(nolock)
on it2.[No_]=ncsl2.[No_]
where ncsh2.[External Document No_]=ncsh1.[External Document No_]
and ncsl2.[Shop Code]='WINDELBAR'
and ncsh2.[Shop Code]='WINDELBAR'
and ncsl2.[Dimension Value 2]='9456'
and ncsl2.[No_] in ('9781625684974','9781625684851','9781625684882','9781614547730','9781614547167','9781614542155','9781614542131')
for XML PATH('') )+']' as Name



,cast(sum(ncsl1.[Unit Price]) as decimal (10,2)) as Betrag
,ncsh1.[Bill-to E-Mail] as Email
,'Liebe'+' '+ncsh1.[Bill-to Name] as Anrede
,'Nach langem Warten müssen wir heute leider den/die von Ihnen bestellten Artikel von Meri Meri stornieren. Dafür bitten wir Sie aufrichtig um Entschuldigung.
Der Hersteller Meri Meri hatte uns bis zuletzt versichert, die Artikel bis spätestens Ende Mai liefern zu können. Umso größer ist auch unsere Enttäuschung, dass dieser Liefertermin nicht eingehalten werden konnte.
Bei einer Bestellung, bei der die Zahlart Lastschriftverfahren gewählt wurde, wird Ihr Konto erst nach Versand der Bestellung um den korrigierten Rechnungsbetrag belastet.
Falls Sie bei Ihrem Einkauf die Zahlungsweise Kreditkarte oder PayPal gewählt haben, wird Ihnen der Betrag in den nächsten Tagen gutgeschrieben.
Als kleine Entschädigung schreiben wir Ihrem Kundenkonto 590 Punkte gut. Für Ihren nächsten Einkauf haben Sie somit die Möglichkeit innerhalb Deutschlands mit Standardversand versandkostenfrei zu bestellen' as Text

from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] ncsh1  with(nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesLine] ncsl1  with(nolock)
on ncsh1.[No_]=ncsl1.[Document No_]
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it1  with(nolock)
on it1.[No_]=ncsl1.[No_]
where ncsl1.[Shop Code]='WINDELBAR'
and ncsh1.[Shop Code]='WINDELBAR'
and ncsl1.[Dimension Value 2]='9456'
and ncsl1.[No_] in ('9781625684974','9781625684851','9781625684882','9781614547730','9781614547167','9781614542155','9781614542131')
group by ncsh1.[External Document No_],ncsh1.[Bill-to E-Mail],ncsh1.[Bill-to Name]
)

select Auftragsnummer,'['+(substring(name,1,len(name)-2))+']' as name  ,Betrag,Email,Anrede,Text from cte 
