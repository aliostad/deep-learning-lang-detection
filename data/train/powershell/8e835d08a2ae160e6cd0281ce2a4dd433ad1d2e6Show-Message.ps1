<#
.SYNOPSIS
    This script creates a function to display a message
    in a message block, then demonstrates its usage
.DESCRIPTION
    This script used Windows Forms to put up a message
    box containing text and a window title passed as 
    parameters
.NOTES
    File Name  : Show-Message.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
.EXAMPLE
    Left as an exercise to the Reader
#>

Function Show-Message {

[CmdletBinding()]
Param ( 
   [Parameter(Mandatory=$True, 
              HelpMessage="Content of Message box")]
   [string]$Message ,

   [Parameter(Mandatory=$False,
             HelpMessage="Title for Message box")]
   [string]$BoxTitle = "Message"
)          

# just in case, load the relevant assembly
$v1 = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# now use the messagebox class to display the message
[Windows.Forms.MessageBox]::Show($Message, $BoxTitle, 
       [Windows.Forms.MessageBoxButtons]::OK , 
       [Windows.Forms.MessageBoxIcon]::Information) 

} # End of function

# Set an alias
Set-Alias sm Show-Message

# call the function
sm 'testing' 'details, details'