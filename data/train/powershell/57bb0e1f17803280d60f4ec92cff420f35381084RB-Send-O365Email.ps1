Workflow Send-O365EMail {
  param(
    [string]$To ,
    [string]$Subject,
    [string]$Body,
    [string]$From,
    [Bool]$IsBodyHTML = $true,
    [int]$SmtpServerPort = 587,
    [PSCredential]$Credential 
  )
  #Set some variables
  $emailSmtpServer = 'smtp.office365.com'
  inlinescript {
    $emailMessage = New-Object System.Net.Mail.MailMessage( $using:From , $using:To )
    $emailMessage.Subject = $using:Subject
    $emailMessage.IsBodyHtml = $IsBodyHTML
    $emailMessage.Body = $using:Body
    $SMTPClient = New-Object System.Net.Mail.SmtpClient( $using:emailSmtpServer , $using:SmtpServerPort )
    $SMTPClient.EnableSsl = $true
    $SMTPClient.Credentials = ($using:Credential).GetNetworkCredential()
    $SMTPClient.Send($emailMessage)
  }# inlinescript
}#workflow
#$cred = get-credential
Send-O365MailMessage -To 'stijnc@fooji.net' -Subject 'TestEmail' -body 'powershell workflows rock!' -from 'stijn.callebaut@inovativ.be' -Credential $cred 
