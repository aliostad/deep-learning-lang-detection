## ACCOUNT LOCKED NOTIFICATION
## Written by Fahad Talib 18/7/2014
##
## To be run on Win-DC(n) with administrative privileges in order to access Security Event Log
## To be triggered by a scheduled task triggered by the event 4740

# Enable AD interrogation 
Import-Module ActiveDirectory

# Fetch Last Locked Account Event from DC Security Log
$Event = Get-WinEvent -FilterHashtable @{LogName='Security';Id=4740} -ErrorAction Stop | Sort-Object -Property TimeCreated -Descending | Select -First 1


# Fetch Variables from AD and Event Log 
[string]$User = $Event.Properties[0].Value
$Usern = Get-ADUser -Identity $User
$userName = $Usern.Name

$Computer = $Event.Properties[1].Value
$Domain = $Event.Properties[5].Value

# Build Email Notification
$MailMessage = New-Object system.net.mail.mailmessage

# Email Subject
$MailSubject= "Account Locked Out: " + $Domain + "\" + $User
$MailMessage.Subject = $MailSubject

# Email Message Content
$MailBody = "Account Name: " + $Domain + "\" + $User + "`r`n" + "Locked User: " + $Username + "`r`n" + "Workstation: " + $Computer + "`r`n" + "Time: " + $Event.TimeCreated + "`n`n" + $Event.Message
$MailMessage.Body = $MailBody

# Email From:
$MailMessage.from = "ICT_IS_Windows_Team@ga.gov.au"

# Email To:
If ($User -like "u*") 
	{
	$MailMessage.To.add("itservicedesk@ga.gov.au")
	}
Else
	{
	$MailMessage.To.add("ICT_IS_Windows_Team@ga.gov.au")
	}

# Is Mail HTML?
$MailMessage.IsBodyHtml = 0

# Send Mail Notification
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = "mailhost.ga.gov.au"
$SmtpClient.Send($MailMessage)
