<#
.SYNOPSIS
    This script demonstrates the use of the NumberDecimalSeparator
.DESCRIPTION
    This script is a re-write of an MSDN sample, using PowerShell
.NOTES
    File Name  : Show-NumberDecimalSeparator.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/b74zyt45%28v=vs.100%29.aspx
.EXAMPLE
    PSH> .\Show-NumberFormat.ps1
    123,456,789.00
    123,456,789 00
#>

# Get Number Format
$nf  = New-Object System.Globalization.CultureInfo  "en-US", $False 
$nfi = $nf.NumberFormat

[Int64] $myInt = 123456789
$myInt.ToString( "N", $nfi )

$nfi.NumberDecimalSeparator = " "
$myInt.ToString( "N", $nfi )