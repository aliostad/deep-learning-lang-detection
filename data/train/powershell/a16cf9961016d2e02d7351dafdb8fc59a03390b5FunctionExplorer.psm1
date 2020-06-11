if ($host.Name -ne "Windows PowerShell ISE Host")
{
    Write-Warning "This module does only run inside PowerShell ISE"
    return
}

function Save-AllIseFiles
{
    <#
    .SYNOPSIS 
        Saves all ISE Files except for untitled files. If You have multiple PowerShellTabs, saves files in all tabs.
    #>
    foreach($tab in $psISE.PowerShellTabs)
    {
        foreach($file in $tab.Files)
        {
            if(!$file.IsUntitled)
            {
                $file.Save()
            }
        }
    }
}

function Close-AllIseFiles
{
    $psise.CurrentPowerShellTab.Files.Clear()
}

function Close-AllButThisIseFiles
{
    $filesToRemove = $psISE.CurrentPowerShellTab.Files | Where-Object { $_ -ne $psISE.CurrentFile }
    $filesToRemove | ForEach-Object { $psISE.CurrentPowerShellTab.Files.Remove($_, $true) }
}
 
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add(
    "Go To Definition",
    { ($psISE.CurrentPowerShellTab.VerticalAddOnTools | Where-Object { $_.Name -eq 'FunctionExplorer' }).Control.GoToDefinition() },
    "F12")

$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Save All",{Save-AllISEFiles},"Ctrl+Shift+S")
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Close All",{ Close-AllIseFiles }, $null)
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Close All but this",{ Close-AllButThisIseFiles }, $null)

Add-Type -Path $PSScriptRoot\FunctionExplorer.dll -PassThru
$typeFunctionExplorer = [IseAddons.FunctionExplorer]
$psISE.CurrentPowerShellTab.VerticalAddOnTools.Add("FunctionExplorer", $typeFunctionExplorer, $true)