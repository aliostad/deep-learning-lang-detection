<#
.SYNOPSIS
    This script shows the Minor part of the version number
    of file version object.
.DESCRIPTION
    This script is a re-implementation of an MSDN Sample script
    that uses System.Diagnostics.FileVersionInfo to get
    the mainor part of the version number of the file.
.NOTES
    File Name  : Show-MinorPart.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://http://pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.FileMinorpart.aspx 
.EXAMPLE
    Psh> .\Show-MinorPart.ps1
    File Major Part for C:\Windows\system32\Notepad.exe is: 6            
#>
# Set filename
$File = [System.Environment]::SystemDirectory + "\Notepad.exe"

#Get Version information for this file
$myFileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File)

# Print the Build details name
"File Minor Part for {0} is: {1}"  -f $file,$myFileVersionInfo.FileMinorPart