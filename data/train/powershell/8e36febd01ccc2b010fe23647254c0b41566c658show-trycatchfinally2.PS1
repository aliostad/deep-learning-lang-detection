<#
.SYNOPSIS
    MSDN Sample of Try/Catch/Finally in PowerShell
.DESCRIPTION
    This script opens a file gets 1st 10 characters. The idea
	is to show more detail on try/catch/finallyi
.NOTES
    File Name  : show-trycatchfinally2.ps1
	Author     : Thomas Lee - tfl@psp.co.uk
	Requires   : PowerShell V2 CTP3
	             Also needs c:\foo\gd.txt to exist.
.LINK
    http://www.pshscripts.blogspot.com
.EXAMPLE
    PSH [C:\foo]: .Show-TryCatchFinally2.PS1'
    First 10 characters:
    N
    a
    m
    e






    - 
    -
    -
#>

###
# Start of Script
##

# Setup and open a file
$path = "c:\foo\gd.txt"
$file = new-object System.IO.StreamReader $path
$buffer = New-Object char[] 10

# now try and read the file
try {
  [void] $file.ReadBlock($buffer, $index, $buffer.Length)
  "First {0} characters:" -f $buffer.length
  $buffer
}
# catch IO exceptions
catch [System.IO.IOException] {
"Error reading from {0}. Message = {1}" -f $path, $Error[0].Message
}
#cleanup
finally {
 if ($file) {
  $file.Close()
 }
}