# Cross cutting items
$balSite = "MyDashAPI"
$dalSite = "MyDashDataAPI"
$rg = "MyDashRG"

# Populate empty ezAuthSettings
$ezAuthSettings = Get-Content .\settings.ezauth.json | ConvertFrom-Json

# MyDashAPI
$appSettings = Get-Content (".\" + $balSite + "\secrets.json") | ConvertFrom-Json
$appSettings | Add-Member -type NoteProperty -name DataAPIUrl -value ("https://" + $dalSite + ".azurewebsites.net") -force
## Call Set, converting appSettings from PSCustomObject to Hashtable
Set-AzureRmWebApp -ResourceGroupName $rg -Name $balSite -AppSettings ($appSettings.psobject.properties | foreach -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h})
$ezAuthSettings | Add-Member -type NoteProperty -name clientId -value $appSettings."ida:ClientId" -force
$ezAuthSettings | Add-Member -type NoteProperty -name issuer -value $appSettings."ida:Authority" -force
## Ideally would be Set, but there is a bug as of 11/11/2015 where -UsePatchSemantics still submits a GET. This is not allowed for /authsettings.
New-AzureRmResource -PropertyObject $ezAuthSettings -ResourceGroupName $rg -ResourceType Microsoft.Web/sites/config -ResourceName ($balSite + "/authsettings") -ApiVersion 2015-08-01 -Force

# MyDashDataAPI
$ezAuthSettings | Add-Member -type NoteProperty -name clientId -value $appSettings."ida:Resource" -force
## Ideally would be Set, but there is a bug as of 11/11/2015 where -UsePatchSemantics still submits a GET. This is not allowed for /authsettings.
New-AzureRmResource -PropertyObject $ezAuthSettings -ResourceGroupName $rg -ResourceType Microsoft.Web/sites/config -ResourceName ($dalSite + "/authsettings") -ApiVersion 2015-08-01 -Force