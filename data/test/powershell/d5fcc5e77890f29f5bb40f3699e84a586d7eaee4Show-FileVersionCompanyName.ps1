<#
.SYNOPSIS
    This script shows the company name of a file version object
.DESCRIPTION
    This script is a re-implementation of an MSDN Sample script
    that uses System.Diagnostics.FileVersionInfo to get
    the company name (if it exists).
.NOTES
    File Name  : Show-FileVersionCompanyName.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://pshscripts.blogspot.com/2011/11/show-fileversioncompanyname.html
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.companyname.aspx   
.EXAMPLE
    Psh> .\Show-FileVersionCompanyName.ps1
    Company name: Microsoft Corporation
#>
# Set filename
$File = [System.Environment]::SystemDirectory + "\Notepad.exe"

#Get Version information for this file
$myFileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File)

# Print the Company name
"Company name: " + $myFileVersionInfo.CompanyName