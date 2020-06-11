#Usage View_PowerOn-Off_Pool.ps1 -Pool <Pool_id>
param(
[string]$Pool,
[string]$SpareCount
)



#Load the View PowerCLI Snapin

Add-PSSnapin vmware.view.broker

#Update the Linked Clone Pool specified with the SpareCount specified 
#Reducing the Pool Spare Count to 1 which powers off all but 1 VMs

Update-AutomaticLinkedClonePool -Pool_id $Pool -HeadroomCount "1"


#Send an email once the script runs
$SmtpClient = New-Object system.net.mail.smtpClient

$SmtpClient.host = "smtp.company.com"   							#Change to a SMTP server in your environment

$MailMessage = New-Object system.net.mail.mailmessage

$MailMessage.from = "COnnectionServer@company.com"   						#Change to email address you want emails to be coming from

$MailMessage.To.add("cloudadmin@company.com")    						#Change to email address you want send to

$MailMessage.IsBodyHtml = 1
$MailMessage.Subject = "OpenAccess Pool Power Down"    		#Change to set your email subject

$MailMessage.Body = "Open Access Pool Powered Down"   		 			#Change to set the body message of the email

$SmtpClient.Send($MailMessage)