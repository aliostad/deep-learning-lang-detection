<#
.SYNOPSIS
    This script shows the build description of file version object.
.DESCRIPTION
    This script is a re-implementation of an MSDN Sample script
    that uses System.Diagnostics.FileVersionInfo to get
    the description of the file.
.NOTES
    File Name  : Show-FileDescription.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://pshscripts.blogspot.com/2011/11/showfiledescriptionps1.html
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.filedescription.aspx
.EXAMPLE
    Psh> .\Show-FileDescription.ps1
    File description for C:\Windows\system32\Notepad.exe is: Notepad
#>
# Set filename
$File = [System.Environment]::SystemDirectory + "\Notepad.exe"

#Get Version information for this file
$myFileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File)

# Print the Build details name
"File description for {0} is: {1}"  -f $file,$myFileVersionInfo.FileDescription