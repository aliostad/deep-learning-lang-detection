function Show-OMPStatus {
    <#
    .Synopsis
       Shows OhMyPsh basic status information.
    .DESCRIPTION
       Shows OhMyPsh basic status information.

    .EXAMPLE
       Show-OMPStatus

       Shows OhMyPsh status information.
    .LINK
       https://www.github.com/zloeber/OhMyPsh
    #>

    [CmdletBinding()]
    param ()

    $Status = @'
Current OhMyPsh Profile: {{Profile}}
Loaded Plugins: {{Plugins}}
'@ -replace '{{Profile}}', $Script:OMPProfileExportFile -replace '{{Plugins}}', ($Script:OMPState['PluginsLoaded'] -join ', ')

    Write-Output $Status
}