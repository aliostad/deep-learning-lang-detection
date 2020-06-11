#Usage View_PowerOn-Off_Pool.ps1 -Pool <Pool_id>
param(
[string]$Pool
)



#Load the View PowerCLI Snapin

Add-PSSnapin vmware.view.broker

#Update the Linked Clone Pool specified with the SpareCount specified 
#Increasing the Pool Spare Count to the Max desktops which powers on all VMs

$SpareCount = Get-Pool -Pool_id $Pool
Update-AutomaticLinkedClonePool -Pool_id $Pool -HeadroomCount $SpareCount.MaximumCount


#Send an email once the script runs
$SmtpClient = New-Object system.net.mail.smtpClient

$SmtpClient.host = "smtp.company.com"   							#Change to a SMTP server in your environment

$MailMessage = New-Object system.net.mail.mailmessage

$MailMessage.from = "ConnectionServer@company.com"   						#Change to email address you want emails to be coming from

$MailMessage.To.add("cloudadmin@company.com")    						#Change to email address you want send to

$MailMessage.IsBodyHtml = 1
$MailMessage.Subject = "OpenAccess Pool Power Up"    	#Change to set your email subject

$MailMessage.Body = "Open Access Pool Powered Up"   		 			#Change to set the body message of the email

$SmtpClient.Send($MailMessage)