<#
.SYNOPSIS
    This script demonstrates the use of the NumberGroupSizes
.DESCRIPTION
    This script is a re-write of an MSDN sample, using PowerShell
.NOTES
    File Name  : Show-NumberGroupSizes.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.globalization.numberformatinfo.numbergroupsizes%28v=vs.100%29.aspx
.EXAMPLE
    PSH> .\Show-NumberGroupSizes.ps1
    123,456,789,012,345.00
    12,3456,7890,123,45.00
    1234567890,123,45.00
#>

# Get Number Format
$nf  = New-Object System.Globalization.CultureInfo  "en-US", $False 
$nfi = $nf.NumberFormat

[Int64] $myInt = 123456789012345
$myInt.ToString( "N", $nfi )

# Display the same value with different groupings
[int[]] $MySizes1 = 2,3,4
[int[]] $MySizes2 = 2,3,0

$nfi.NumberGroupSizes = $mySizes1
$myInt.ToString( "N",$nfi )
$nfi.NumberGroupSizes = $mySizes2
$myInt.ToString( "N", $nfi ) 