<#
    Source for Script: http://www.powershellmagazine.com/2013/08/05/pstip-reset-your-ise-runspace/
.Synopsis
   Moves open files to a new PowerShell tab
.Example
   Reset-IseTab –Save { function Prompt {'>'}  }
#>
Function Reset-IseTab {
 
    Param(
        [switch]$SaveFiles,
        [ScriptBlock]$InvokeInNewTab
    )
 
    $Current = $psISE.CurrentPowerShellTab    
    $FileList = @()
            
    $Current.Files | ForEach-Object {        
        if ($SaveFiles -and (-not $_.IsSaved)) {
 
            Write-Verbose "Saving $($_.FullPath)"           
            try {
                $_.Save()             
                $FileList  += $_     
            } catch [System.Management.Automation.MethodInvocationException] {
                # Save will fail saying that you need to SaveAs because the 
                # file doesn't have a path.
                Write-Verbose "Saving $($_.FullPath) Failed"                           
            }            
        } elseif ($_.IsSaved) {            
            $FileList  += $_
        }
    }
                   
    $NewTab = $psISE.PowerShellTabs.Add() 
    $FileList | ForEach-Object { 
        $NewTab.Files.Add($_.FullPath) | Out-Null
        $Current.Files.Remove($_) 
    }
 
    # If a code block was to be sent to the new tab, add it here. 
    #  Think module loading or dot-sourcing something to put your environment
    # correct for the specific debug session.
    if ($InvokeInNewTab) {
         
        Write-Verbose "Will call this after the Tab Loads:`n $InvokeInNewTab"
         
        # Wait for the new tab to be ready to run more commands.
        While (-not $NewTab.CanInvoke) {
            Start-Sleep -Seconds 1
        }
 
        $NewTab.Invoke($InvokeInNewTab)
    }
 
    if ($Current.Files.Count -eq 0) {        
        #Only remove the tab if all of the files closed.
        $psISE.PowerShellTabs.Remove($Current)
    }
}