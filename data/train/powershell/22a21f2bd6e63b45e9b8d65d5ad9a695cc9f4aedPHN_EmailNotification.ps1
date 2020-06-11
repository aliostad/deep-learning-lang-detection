
#Requires -Version 2.0

<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
  Version:        1.0
  Author:         Tyler Kempt
  Last Updated:   <Date>
  
.EXAMPLE
  Basic plaintext

.EXAMPLE
  Multiple recipients
  -To "tkempt@porthopechc.ca", "tuser222@porthopechc.ca"

.EXAMPLE
  Email with formatting

.EXAMPLE
  Email with external stylesheet

.EXAMPLE
  debug logging turned on

.EXAMPLE
  verbose logging turned on

#>


#---------------------------------------------------------[Initialisations]--------------------------------------------------------


# http://virot.eu/standardize-your-verbosedebug-messages/
$DebugMessage = {Param([string]$Message);"$(get-date) [$((Get-Variable -Scope 1 MyInvocation -ValueOnly).MyCommand.Name)]: $Message"}


#----------------------------------------------------------[Declarations]----------------------------------------------------------


# $HTMLStyle = "<html><head><style>body{font-family: Arial; font-size: 16px; color: #03f;}</style></head><body>"$HTMLStyle = Get-Content "$PSScriptRoot\style.css"

#-----------------------------------------------------------[Functions]------------------------------------------------------------


#########################################################################################
#
# FUNCTION: Send-Email
#
# Send a basic email message using the Send-MailMessage PowerShell cmdlet.
#
# TO DO:
# Include optional rich HTML formatting, file attachment (e.g. log)
# Send to one or multiple users
# https://msdn.microsoft.com/en-us/powershell/reference/5.0/microsoft.powershell.utility/send-mailmessage
#
#########################################################################################

Function Send-Email {

    [CmdletBinding()]

    Param (

        #SmtpServer
        [Parameter(Position=0, Mandatory=$True, HelpMessage="SMTP server address, e.g. s-phchc-mail.phchc.local")]
        [ValidateNotNullOrEmpty()]
        [string] $Server,

        #From
        [Parameter(Position=1, Mandatory=$True, HelpMessage="'From' address displayed in email message header")]
        [ValidateNotNullOrEmpty()]
        [string] $From,

        #To
        [Parameter(Position=2, Mandatory=$True, HelpMessage="Recipient email address(es)")]
        [ValidateNotNullOrEmpty()]
        [string[]] $To,

        #Cc
        [Parameter(Position=3, Mandatory=$False)]
        [string] $CC,

        #Bcc
        [Parameter(Position=4, Mandatory=$False)]
        [string] $BCC,

        #Subject
        [Parameter(Position=5, Mandatory=$False, HelpMessage="Email subject line")]
        [string] $Subject = "Notification from $From",

        #Body
        [Parameter(Position=6, Mandatory=$False, HelpMessage="Email message body")]
        [string] $Body = "",

        #Attachment
        [Parameter(Position=7, Mandatory=$False)]
        [string[]] $Attachment,

        #Priority
        [Parameter(Position=8, Mandatory=$False)]
        [string] $Priority = "High",

        #BodyasHTML
        [Parameter(Position=9, Mandatory=$False)]
        [switch] $RichFormat,

        #HTML
        #https://stackoverflow.com/questions/22925614/inserting-variables-into-html-body-using-send-mailmessage
        [Parameter(Position=10, Mandatory=$False)]
        [string] $HTML = "",

        #CSS
        [Parameter(Position=11, Mandatory=$False)]
        [string] $CSS = ""
    )

    Begin {

        Write-Verbose (&$DebugMessage 'Function has begun, starting process . . .')

        if ($RichFormat) {
            Write-Verbose (&$DebugMessage 'Appending HTML formatting to message . . .')
        } 
    }

    Process {

        Write-Verbose (&$DebugMessage 'Process started . . .')

        if ($RichFormat) {

            foreach ($Address in $To) {

                Write-Verbose (&$DebugMessage 'Sending FORMATTED mail message . . .')

                # Send-MailMessage -SmtpServer $Server -From $From -To $Address -Subject $Subject -Body ($Body) -BodyAsHtml

                Send-MailMessage `
                    -SmtpServer $Server `
                    -From $From `
                    -To $Address `
                    -Subject $Subject `
                    -Body ($Body) `
                    -BodyAsHtml `
                    -DeliveryNotificationOption OnSuccess `
                    -Priority $Priority

                Write-Verbose (&$DebugMessage 'Message sent')
            }
        }
        else {

            foreach ($Address in $To) {

                Write-Verbose (&$DebugMessage 'Sending PLAINTEXT mail message . . .')

                Send-MailMessage `
                    -SmtpServer $Server `
                    -From $From `
                    -To $Address `
                    -Subject $Subject `
                    -Body ($Body) `
                    -Priority Normal

                Write-Verbose (&$DebugMessage 'Message sent')
            }
        }

        Write-Verbose (&$DebugMessage 'Process complete . . .')
    }

    End {
        If($?){
            Write-Verbose (&$DebugMessage 'Function complete.')
            Write-Host "Success!" -ForegroundColor Green -BackgroundColor Black
        }
    }
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------
<#


#$HTMLStyle = Get-Content "$PSScriptRoot\bootstrap.min.css" -Raw
$HTMLStyle = ""
#$HTMLStyle2 = Get-Content "$PSScriptRoot\style.css"
$Style = ("<style>" + $HTMLStyle + "</style>")
$Result = ($Style + $content)

#($Body -f "hello", "world")
#>

<#

$Content = Get-Content "$PSScriptRoot\test.html" -Raw

Send-Email -Verbose `
    -Server "s-phchc-mail.phchc.local" `
    -From "Test Email <test@porthopechc.ca>" `
    -To "Tyler Kempt <tkempt@porthopechc.ca>" `
    -Subject "Test" `
    -Body ($Content -f "hello","world","this","is","a","test")

#>