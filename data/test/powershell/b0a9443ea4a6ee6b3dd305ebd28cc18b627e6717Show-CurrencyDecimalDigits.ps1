<#
.SYNOPSIS
    This script demonstrates the use of the CurrencyDecimalDigits
.DESCRIPTION
    This script is a re-write of an MSDN sample, using PowerShell
.NOTES
    File Name  : Show-CurrencyDecimalDigits.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://msdn.microsoft.com/en-us/library/system.globalization.numberformatinfo.currencydecimaldigits%28v=vs.100%29.aspx
.EXAMPLE
    PSH> .\Show-CurrencyDecimalDigits.ps1
    ($1,234.00)
    ($1,234.0000)
#>

# Get Number Format
$nf  = New-Object System.Globalization.CultureInfo  "en-US", $False 
$nfi = $nf.NumberFormat

# Display a negative value with the default number of decimal digits (2).
[Int64] $myInt = -1234
$myInt.ToString( "C", $nfi )

# Displays the same value with four decimal digits.
$nfi.CurrencyDecimalDigits = 4
$myInt.ToString( "C", $nfi )