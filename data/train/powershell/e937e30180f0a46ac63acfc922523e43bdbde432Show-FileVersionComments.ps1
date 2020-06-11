<#
.SYNOPSIS
    This script shows the comments property of a file version object
.DESCRIPTION
    This script is a re-implementation of an MSDN Sample script
    that uses System.Diagnostics.FileVersionInfo to get
    the company name (if it exists).
.NOTES
    File Name  : Show-FileVersionComments.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.comments.aspx   
.EXAMPLE
    Psh> .\Show-FileVersionComments.ps1
    Comments : Microsoft Corporation
#>
# Set filename
$File = [System.Environment]::SystemDirectory + "\Notepad.exe"

#Get Version information for this file
$myFileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File)

# Print the Comments field
"Commments : " + $myFileVersionInfo.CompanyName