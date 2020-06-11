
# Script to send a message via SMTP

$SmtpServer = "<ServerName>"
$PortNumber = 25
$FromAddress = "from@domain.com"
$FromName = "From Name"
$ToAddress = "to@domain.com"
$ToName = "To Name"
$Subject = "Test Email"
$MessageText = "This is a test message."

$From = new-object System.Net.Mail.MailAddress($FromAddress, $FromName)
$To = new-object System.Net.Mail.MailAddress($ToAddress, $ToName)

$Smtp = New-Object Net.Mail.SmtpClient($SmtpServer, $PortNumber)
$Message = new-object Net.Mail.MailMessage

# Prompt for credentials
# $CredentialPrompt = get-credential 
# $Credentials = new-object System.Net.networkCredential
# $Credentials.Domain = $CredentialPrompt.GetNetworkCredential().Domain
# $Credentials.UserName = $CredentialPrompt.GetNetworkCredential().UserName
# $Credentials.Password = $CredentialPrompt.GetNetworkCredential().password
# $Smtp.Credentials = $Credentials

# To include attachment
#$Attachment = new-object System.Net.Mail.Attachment("")
#$MailMessage.Attachements.Add($Attachment)

# Set Message Properties
$Message.From = $From
$Message.ReplyTo = $From
$Message.To.Add($To)
$Message.Subject = $Subject
$Message.Body = $MessageText

$Smtp.Send($Message)




