<#
.SYNOPSIS
    This script shows formatting of enums
.DESCRIPTION
    This script iteraties through two enums and uses
    tostring and enum format strings to display 
    the enum's values.
.NOTES
    File Name  : Show-EnumFormat.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 2.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
        http://msdn.microsoft.com/en-us/library/c3s1ez6e.aspx
.EXAMPLE
     Psh> .\Show-EnumFormat.ps1

            g         f    d          x
       Monday    Monday    0   00000000
      Tuesday   Tuesday    1   00000001
    Wednesday Wednesday    2   00000002
     Thursday  Thursday    3   00000003
       Friday    Friday    4   00000004
     Saturday  Saturday    5   00000005
       Sunday    Sunday    6   00000006
      Default   Default    7   00000007
#>

# Create Enum
$Enum = [system.windows.forms.day]

# Just in case
$t = [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
$t = [System.Reflection.Assembly]::LoadWithPartialName(“System.Drawing”)

# loop through each enum and display the formatting
# Header rows
"Enum : {0}" -f $enum
"{0,9} {1,9} {2,4} {3,10}" -f "g", "f", "d", "x"

# Now display the formatted values
Foreach ($E in [System.enum]::getvalues($enum)) {
  "{0,9} {1,9} {2,4} {3,10}" -f $e.tostring("g"),$e.tostring("f"),$e.tostring("d"), $e.tostring("x")
}

$Enum = [system.drawing.knowncolor]

# Just in case
$t = [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
$t = [System.Reflection.Assembly]::LoadWithPartialName(“System.Drawing”)

# loop through each enum and display the formatting
# Header rows
"Enum : {0}" -f $enum
"{0,23} {1,23} {2,6} {3,10}" -f "g", "f", "d", "x"

# Now display the formatted values
Foreach ($E in [System.enum]::getvalues($enum)) {
  "{0,23} {1,23} {2,6} {3,10}" -f $e.tostring("g"),$e.tostring("f"),$e.tostring("d"), $e.tostring("x")
}
