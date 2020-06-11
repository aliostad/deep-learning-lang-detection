<#
.SYNOPSIS
    This script shows the build number of file version object.
.DESCRIPTION
    This script is a re-implementation of an MSDN Sample script
    that uses System.Diagnostics.FileVersionInfo to get
    the build identification of the file.
.NOTES
    File Name  : Show-FileBuildPart.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://http://pshscripts.blogspot.com/2011/11/show-filebuildpartps1.html
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.filebuildpart.aspx 
.EXAMPLE
    Psh> .\Show-FileBuildPart.ps1
    File build number for C:\Windows\system32\Notepad.exe is: 6001
#>
# Set filename
$File = [System.Environment]::SystemDirectory + "\Notepad.exe"

#Get Version information for this file
$myFileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File)

# Print the Build details name
"File Build Part for {0} is: {1}"  -f $file,$myFileVersionInfo.FileBuildPart