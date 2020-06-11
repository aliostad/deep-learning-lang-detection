New-PsDrive -Name Mod -PSProvider FileSystem -Root (($env:PSMODULEPATH -split ";")[0]) 
Import-Module ISEPack
Set-Alias Open PowerShell_ise

<# 
This function is now built-in to the editor so it is no longer needed.  
I'm keeping it here so you can see how it works.
function GoTo-Line
{
    $ed = $psise.CurrentOpenedFile.Editor
    [int]$l = read-host
    if ($l -le $ed.LineCount)
    {
        $ed.SetCaretPosition($l,1) 
    }
    else
    {O
        $ed.SetCaretPosition($ed.LineCount,1)
    }
}
#>
function Edit-Selected
{
    $ed = $psise.CurrentOpenedFile.Editor
    PowerShell_ise $ed.SelectedText
} 

function global:Export-SessionFiles
{
    $psise.CurrentOpenedRunspace.OpenedFiles |%{
       if (!$_.isSaved)
       {
           $title = "Save File?"
           $message = "Do you want to Save `n`t$($_.FullPath)`nbefore exporting?"

           $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
                "Save $($_.FullPath)."

           $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
                "Export but do not save $($_.fullpath)."

           $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

           if (($host.ui.PromptForChoice($title, $message, $options, 0)) -eq 0)
           {
               $_.Save()
           }
       }
       $psise.CurrentOpenedRunspace.Output.InsertText("`nExporting $($_.FullPath)")
        $_.FullPath
    } > ~/ISE-SessionFiles.txt
}

function Import-SessionFiles
{
    cat ~/ISE-SessionFiles.txt | %{ $psise.CurrentOpenedRunspace.OpenedFiles.add($_) }
}

$null = $psISE.CustomMenu.Submenus.Add("Edit Selected", {Edit-Selected}, 'Ctrl+E')
$null = $psISE.CustomMenu.Submenus.Add("Export Session Files", {Export-SessionFiles}, 'Ctrl+SHIFT+E')
$null = $psISE.CustomMenu.Submenus.Add("Import Session Files", {Import-SessionFiles}, 'Ctrl+SHIFT+I')
