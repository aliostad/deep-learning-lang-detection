$Title = 'Thomas Lee CBHelp Template'
$Description = 'Help template for Reskit/PshScriptsBlog scripts'
$Text = @"
<#
.SYNOPSIS
    This script,
.DESCRIPTION
    This script 
.NOTES
    File Name  : Show-.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Tested on  : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
.EXAMPLE
    c:\foo> xxx.ps1

#>
"@

$Author       = 'Thomas Lee (2014)'
$CarretOffset = 28

New-IseSnippet -Title $Title -Description $Description -Author $Author -Text $Text -CaretOffset $CarretOffset -Verbose -Force

