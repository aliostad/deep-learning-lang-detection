#Usage View_Refresh_Pool.ps1 -Pool <Pool_id>
param(
[string]$Pool
)


#Load the View PowerCLI Snapin
Add-PSSnapin vmware.view.broker


#Sets all the VM in a pool to refresh
Get-Pool -pool_id $Pool | Get-DesktopVM | Send-LinkedCloneRefresh -schedule ((Get-Date).AddMinutes(1)) -ForceLogoff $true


#Send an email once the script runs
$SmtpClient = New-Object system.net.mail.smtpClient

$SmtpClient.host = "smtp.compnay.com"   							#Change to a SMTP server in your environment

$MailMessage = New-Object system.net.mail.mailmessage

$MailMessage.from = "ConnectionServer@company.com"   						#Change to email address you want emails to be coming from

$MailMessage.To.add("cloudadmin@company.com")    						#Change to email address you want send to

$MailMessage.IsBodyHtml = 1
$MailMessage.Subject = "OpenAccess Pool Refreshed"    	#Change to set your email subject

$MailMessage.Body = "Open Access Pool Refreshed"    					#Change to set the body message of the email

$SmtpClient.Send($MailMessage)