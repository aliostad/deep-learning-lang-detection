#example 1:

Get-MessageTrackingLog -Server hub1 `
-Start (Get-Date).AddDays(-1) `
-End (Get-Date) `
-EventId Send

#example 2:

Get-TransportServer | 
  Get-MessageTrackingLog -Start (Get-Date).AddDays(-1) `
  -End (Get-Date) `
  -EventId Send `
  -Sender dmsith@contoso.com

#example 3:

Get-MessageTrackingLog -Sender sales@litwareinc.com -EventId Receive

#example 4:

Get-MessageTrackingLog –Recipients dave@contoso.com,john@contoso.com

#example 5:

Get-ExchangeServer | 
  Get-MessageTrackingLog -MessageSubject 'Financial Report for Q4'

#example 6:

Get-TransportServer | Get-MessageTrackingLog -EventId Receive `
-Start (Get-Date).AddDays(-7) `
-End (Get-Date) `
-ResultSize Unlimited | 
  Where-Object {$_.ConnectorId -like '*\Internet'}

#example 7:

$results = Get-TransportServer | 
  Get-MessageTrackingLog -EventId Receive `
  -Start (Get-Date).AddDays(-7) `
  -End (Get-Date) `
  -ResultSize Unlimited | 
    Where-Object {$_.ConnectorId -like '*\Internet'}

$results | 
  Measure-Object -Property TotalBytes -Sum | 
    Select-Object @{n="Total Items";e={$_.Count}},
    @{n="Total Item Size (MB)";e={[math]::Round($_.Sum /1mb,2)}}

#example 8:

$domain = @{}

$report = Get-TransportServer | 
  Get-MessageTrackingLog -EventId Send `
  -ResultSize Unlimited `
  -Start (Get-Date).AddDays(-30) `
  -End (Get-Date) | 
  Where-Object {$_.ConnectorId -eq 'Internet'}

if($report) {
  $domains = $report | %{$_.Recipients | %{$_.Split("@")[1]}}
  $domains | %{$domain[$_] = $domain[$_] + 1}
  Write-Output $domain
}
