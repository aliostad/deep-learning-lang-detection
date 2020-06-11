function prompt { 
<#
.SYNOPSIS
Sets the prompt

.DESCRIPTION
Sets the prompt either:
- the GitShell prompt, but with only the last element of the folder name or
- the get-date
...depending on whether I'm in the Git Shell or not

Todo: show the time
Todo: show the time of the last command

This function is autoloaded by .matt.ps1

.PARAMETER Folder
Not yet implemented. Show the folder name in the prompt

.INPUTS
None. You cannot pipe objects to this function

.EXAMPLE

.EXAMPLE
 

.LINK
https://github.com/mattypenny/posh_functions/blob/master/function-prompt.ps1


#>
  [CmdletBinding()]	
	Param( [String] $Folder)

  $realLASTEXITCODE = $LASTEXITCODE

  # Reset color, which can be messed up by Enable-GitColors
  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

  $FolderName = [System.IO.Path]::GetFileName($pwd.ProviderPath)

  Write-Host($FolderName) -nonewline


  try
  {
    Write-VcsStatus
  }
  catch
  {
    $PromptDate=get-date
    write-host " $PromptDate" -nonewline
  }
  $global:LASTEXITCODE = $realLASTEXITCODE
  return " $ "

}


<#
vim: tabstop=2 softtabstop=2 shiftwidth=2 expandtab
#>


