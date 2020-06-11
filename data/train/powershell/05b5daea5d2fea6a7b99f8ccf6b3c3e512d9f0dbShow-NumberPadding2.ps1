<#
.SYNOPSIS
    Shows formatting of leading Zeros for integers.
.DESCRIPTION
    This script, a re-implementation of an MSDN Sample, 
    creates a value then diplays it using Decimal and Hex
    format strings.
.NOTES
    File Name  : Show-NumberPadding2.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://pshscripts.blogspot.com/
    MSDN sample posted to:
        http://msdn.microsoft.com/en-us/library/dd260048.aspx 
.EXAMPLE
    Psh> Show-NumberPadding2.ps1
    00000160934
    00000274A6

#>
#    Create values
[int]  $value = 160934
[int]  $decimalLength = $value.ToString("D").Length + 5
[int]  $hexLength = $value.ToString("X").Length + 5

#    Display using ToString()
$value.ToString("D" + $decimalLength.ToString())
$value.ToString("X" + $hexLength.ToString())