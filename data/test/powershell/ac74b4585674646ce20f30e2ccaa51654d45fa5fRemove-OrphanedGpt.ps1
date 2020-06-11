<#
    .SYNOPSIS
        Use the FindOrphanedGPT XML file from the output of ADRAP tool to remove directories
    .DESCRIPTION
        This script will parse the output file from the Orphaned GPT scan on an ADRAP. The XML
        will contain the GUID of the orphaned templates which equate to a folder in SYSVOL. For
        each GPT in the list it will search SYSVOL for the associated folder and remove it from 
        the server.
        
        Each time a folder is removed it is logged in the PowerShell log on the server.
    .PARAMETER XmlFile
        The full path and filename to the output file from the ADRAP
    .EXAMPLE
        .\Remove-OrphanedGpt.ps1 -XmlFile C:\adrap\output\findorphanedgpts.xml -SysvolPath \\dc.company.com\SYSVOL\company.com
        
        Description
        -----------
        This is the default syntax for the command.
    .NOTES
        ScriptName : Remove-OrphanedGpt
        Created By : jspatton
        Date Coded : 06/20/2012 12:07:54
        ScriptName is used to register events for this script
 
        ErrorCodes
            100 = Success
            101 = Error
            102 = Warning
            104 = Information
    .LINK
        https://code.google.com/p/mod-posh/wiki/Production/Remove-OrphanedGpt
 #>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='High')]
Param
    (
    [string]$XmlFile,
    [string]$SysvolPath
    )
Begin
    {
        $ScriptName = $MyInvocation.MyCommand.ToString()
        $ScriptPath = $MyInvocation.MyCommand.Path
        $Username = $env:USERDOMAIN + "\" + $env:USERNAME
 
        New-EventLog -Source $ScriptName -LogName 'Windows Powershell' -ErrorAction SilentlyContinue
 
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
 
        #	Dotsource in the functions you need.
        }
Process
    {
        [xml]$OrphanedGptFile = Get-Content $XmlFile
        $Orphans = $OrphanedGptFile.WorkItem.Data.OrphanedGPT.Domain |Where-Object {$_.name -eq 'home.ku.edu'} |Select-Object -Property GPT

        foreach ($Guid in $Orphans.GPT)
        {
            try
            {
                $Message = "Remove-Item $($SysvolPath)\Policies\$($Guid.GUID.Trim().tostring())"
                Write-Verbose $Message
                Remove-Item -Path "$($SysvolPath)\Policies\$($Guid.GUID.Trim().tostring())" -Recurse -ErrorAction Stop -Confirm
                Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
                }
            catch
            {
                $Message = $Error[0].Exception
                Write-Verbose $Message
                Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "101" -EntryType "Error" -Message $Message
                }
            }
       }
End
    {
        $Message = "Script: " + $ScriptPath + "`nScript User: " + $Username + "`nFinished: " + (Get-Date).toString()
        Write-EventLog -LogName 'Windows Powershell' -Source $ScriptName -EventID "104" -EntryType "Information" -Message $Message
        }