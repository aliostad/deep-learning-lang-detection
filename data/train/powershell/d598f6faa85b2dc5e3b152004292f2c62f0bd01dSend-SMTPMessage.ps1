<#
.SYNOPSIS
   Creates and sends an SMTP message  
.DESCRIPTION
    This script uses the system.net.mail class to create and send
	an email message using SMTP.
.NOTES
    File Name  : Send-SMTPMessage.ps1
	Author     : Thomas Lee - tfl@psp.co.uk
	Requires   : PowerShell V2 CTP3
.LINK
    http://www.pshscripts.blogspot.com
.EXAMPLE
    PSH [C:\foo]: .\Send-SMTPMessage.ps1'
    Sending an e-mail message to doctordns@gmail.com by using SMTP host localhost port 25.
    Message to: powershell@psp.co.uk, from: doctordns@gmail.com has beens successfully sent
#>

##
# Start of Script
##

# Create from/to addresses
$from = New-Object System.Net.Mail.MailAddress "powershell@psp.co.uk"
$to =   New-Object System.Net.Mail.MailAddress "doctordns@gmail.com"
 
# Create Message
$message = new-object  System.Net.Mail.MailMessage $from, $to
$message.Subject = "Using the SmtpClient class and PowerShell"
$message.Body = @"
Using this feature, you can send an e-mail message from an application very easily.
"@

# Set SMTP Server and create SMTP Client
$server = "localhost"
$client = new-object system.net.mail.smtpclient $server

# Send the message
"Sending an e-mail message to {0} by using SMTP host {1} port {2}." -f $to.ToString(), $client.Host, $client.Port
try {
   $client.Send($message)
   "Message to: {0}, from: {1} has beens successfully sent" -f $from, $to
}
catch {
  "Exception caught in CreateTestMessage: {0}" -f $Error[0]
}
