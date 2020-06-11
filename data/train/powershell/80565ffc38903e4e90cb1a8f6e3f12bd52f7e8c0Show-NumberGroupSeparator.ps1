<#
.SYNOPSIS
    This script demonstrates the use of the NumberGroupSeparator
.DESCRIPTION
    This script is a re-write of an MSDN sample, using PowerShell
.NOTES
    File Name  : Show-NumberGroupSeparator.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.globalization.numberformatinfo.numbergroupsizes%28v=vs.100%29.aspx
.EXAMPLE
    PSH> .\Show-NumberGroupSizes.ps1
    $123,456,789,012,345.00
    $123 456 789 012 345.00
#>

# Get Number Format
$nf  = New-Object System.Globalization.CultureInfo  "en-US", $False 
$nfi = $nf.NumberFormat

# Display a value with the default separator (",").
[Int64] $myInt = 123456789012345
$myInt.ToString( "C", $nfi )

# Displays the same value with a blank as the separator.
$nfi.CurrencyGroupSeparator = " "
$myInt.ToString( "C", $nfi )
