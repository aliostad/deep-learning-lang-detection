<# 
.SYNOPSIS  
	Sends email via Azure Automation
 
.DESCRIPTION 
    This runbook sends an email via Azure Automation
	
.EXAMPLE
    Send-Email
 
.NOTES 
    AUTHOR:  Christopher Mank
    LASTEDIT: July 15, 2015
#>
workflow Send-Email
{	
	# Inputs
    param (
		 #[Object] $WebhookData
    )
	
	# Manually configured variables
	$StrCredentialName = "CpmAzureO365Cred"
	$StrMessageTo = @("cmank@concurrency.com")
	$StrSmtpServer = 'smtp.office365.com'
	
	# Build email variables
	$StrMessageSubject = 'Runbook Scheduled with Azure Scheduler'
	$StrMessageBody = "<font face=`"Calibri`">Hello There!<br><br>
    
        This runbook was scheduled with Azure scheduler.<br><br>
        	
		Now that's good stuff!</font>"
 
    # Retrieve Office365 credentials
    $ObjAzureCred = Get-AutomationPSCredential -Name $StrCredentialName
	
 	# Send Email
    if ($ObjAzureCred) 
    {
        Send-MailMessage -To $StrMessageTo -Subject $StrMessageSubject -Body $StrMessageBody -UseSsl -Port 587 -SmtpServer $StrSmtpServer -From $ObjAzureCred.UserName -BodyAsHtml -Credential $ObjAzureCred
	}
}