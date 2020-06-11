
Param(
    [string]$server
)

$EmailFrom = "gboschi@appzero.com"
$EmailTo = "gboschi@appzero.com"
$Subject = "Discovery Output for Server $server"
$Body = @"
Please review the attached Worksheet.
Thank You.
"@

$SMTPServer = "smtp.gmail.com"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("gboschi@appzero.com","ts0tm!tm")

$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = $EmailFrom
$emailMessage.To.Add($EmailTo)
$emailMessage.Subject = $Subject
$emailMessage.Body = $Body

$attachmentPath = Resolve-Path -Path ".\L-classify.csv"
$attachment = New-Object System.Net.Mail.Attachment( $attachmentPath )
$emailMessage.Attachments.Add($attachment)

$SMTPClient.send($emailMessage)
$emailMessage.dispose()

