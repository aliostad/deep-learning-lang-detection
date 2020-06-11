
import-module "C:\SATS\modules\nLog\nLog.psm1"
Set-DHCPPrimaryServer x
New-Alias -Name menu -Value "Show-DHCPMenu"
$MandatoryCmds= @("Out-Default","Exit-PSSession","Select-Object","Get-Command","Measure-Object","Get-FormatData", "Get-Help","menu")
$CmdsToInclude = (Get-command -module PoshDHCP).Name + $MandatoryCmds
$CmdsToExclude = @("Add-DhcpScope","Add-DhcpSuperScope","Add-GroupClient","Test-Group","Invoke-DHCPFailoverReplication","Show-Menu","Show-DHCPAddClientMenu","Remove-DhcpScope","Get-DhcpServerv4FilterCache","Set-DHCPPRimaryServer","Set-DhcpScope", "%","?","Join-LogUser","Write-LogDebug","Write-LogError","Write-LogFatal","Write-LogInfo","Write-LogTrace","Write-LogWarn")

$CmdsToInclude =  (compare-object $CmdsToInclude $CmdsToExclude  -IncludeEqual | where {$_.sideindicator -eq "<="}).InputObject



Get-Alias | Where Visibility -eq 'Public' | ForEach-Object {
    if ( $_.Name -notin $CmdsToInclude ) {
        $_.Visibility = 'Private'
    }
    }


Get-Command | Where Visibility -eq 'Public' | ForEach-Object {
    if ( $_.Name -notin $CmdsToInclude ) {
        $_.Visibility = 'Private'
    }
    }
Write-Host Type in "Show-DHCPMenu" to access the SATS menu.
