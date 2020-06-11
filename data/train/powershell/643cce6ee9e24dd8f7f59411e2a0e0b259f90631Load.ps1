$PreLoad = {
    if (-not (Test-OMPProfileSetting -Name 'QuoteDirectory')) {
        $QuoteDir = Join-Path $PluginPath "$Name\src\quotes.txt"
        Write-Output "Setting Quote Directory to $QuoteDir"
        Add-OMPProfileSetting -Name 'QuoteDirectory' -Value $QuoteDir
        Export-OMPProfile
    }
    $QuoteDir = Get-OMPProfileSetting -Name 'QuoteDirectory'
}
$Config = {}
$PostLoad = {
    Write-Host ''
    Write-Host (Get-Quote -Path $QuoteDir)
}
$Shutdown = {}
$Unload = {
    Remove-OMPProfileSetting -Name 'QuoteDirectory'
}