<#
.SYNOPSIS
    Shows formatting of double values.
.DESCRIPTION
    This script, a re-implementation of an MSDN Sample, 
    creates a double value then formats it with 5 leading
    zeros.
.NOTES
    File Name  : Show-NumberPadding3.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://pshscripts.blogspot.com/
    MSDN sample posted to:
        http://msdn.microsoft.com/en-us/library/dd260048.aspx 
.EXAMPLE
    Psh> Show-NumberPadding3.ps1
    01053240
    00103932.52
    01549230

            01053240
         00103932.52
            01549230
       9034521202.93

#>  

$fmt                 = "00000000.##"
[int]     $intValue  = 1053240
[decimal] $decValue  = 103932.52
[float]   $sngValue  = 1549230.10873992
[double]  $dblValue  = 9034521202.93217412

# Display the numbers using the ToString method
$intValue.ToString($fmt)
$decValue.ToString($fmt)
$sngValue.ToString($fmt)           
""

# Display the numbers using composite formatting
$formatString = " {0,15:" + $fmt + "}"  # right justified
$formatString -f $intValue 
$formatString -f $decValue 
$formatString -f $sngValue      
$formatString -f $dblValue