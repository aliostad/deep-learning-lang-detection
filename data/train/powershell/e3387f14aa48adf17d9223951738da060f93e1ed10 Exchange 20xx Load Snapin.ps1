$Title = "Exchange 20xx Load Snapin"
$Header ="Exchange 20xx Load Snapin"
$Comments = "Exchange 20xx Load Snapin"
$Display = "None"
$Author = "Phil Randal"
$PluginVersion = 2.7
$PluginCategory = "Exchange2010"

# Based on ideas in http://www.stevieg.org/2011/06/exchange-environment-report/
#  and http://www.powershellneedfulthings.com/?page_id=281

# Start of Settings
# View Entire Forest
$viewEntireForest=$false
# Exchange Server Name Filter (regular expression, to select all use '.*')
$exServerFilter=".*"
# End of Settings

# Changelog
## 2.0 : Simplify to do nothing more than load Exchange snapin
## 2.1 : Warn when we're reporting on Exchange 2010 servers under Exchange 2007 shell
##     : Add servername filter
## 2.2 : try to load Exchange 2010 snapin first
## 2.4 : Allow selection of Entire Forest view
## 2.6 : Tidy up
## 2.7 : Run RemoteExchange.ps1 script and connect to Exchange server

# Try to load Exchange Management snapins then test if they're loaded OK
# If already loaded, load attempt will silently fail, but will still be OK
# Try Exchange 2010 snapin first
#   if that fails, try Exchange 2007 snapin

$null = Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue
$2010snapin = Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue
If (!$2010snapin) {
  $null = Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin -ErrorAction SilentlyContinue
  $2007snapin = Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin -ErrorAction SilentlyContinue
}
If ($2007snapin) {
  $AdminSessionADSettings.ViewEntireForest = $viewEntireForest
  . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
  Connect-ExchangeServer -auto -AllowClobber
  If (Get-ExchangeServer |
    Where { $_.AdminDisplayVersion -match "^Version 14" -and $_.Server -match $exServerFilter }) {
      Write-CustomOut "...Warning - Exchange2010 detected on server $($_.Server), but we're using the Exchange 2007 Management Shell"
  }
}
If ($2010snapin) {
  Set-ADServerSettings -ViewEntireForest $viewEntireForest
  . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
  Connect-ExchangeServer -auto -AllowClobber
}
