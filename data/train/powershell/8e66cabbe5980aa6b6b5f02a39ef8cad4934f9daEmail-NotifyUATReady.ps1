
Param(
    [Parameter(Mandatory=$true)]
    [string]$root,
    [Parameter(Mandatory=$true)]
    [string]$server
)

pushd "$root\PACE\$server"

$EmailFrom = "gboschi@appzero.com"
$EmailTo = "gboschi@appzero.com"
$Subject = "VAA $server ready for testing"
$Body = @"
Server $server is ready for testing.  Please use the attached RDP file to connect and test the application
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

$attachmentPath = Resolve-Path -Path ".\$server.rdp"
$attachment = New-Object System.Net.Mail.Attachment( $attachmentPath )
$emailMessage.Attachments.Add($attachment)

$SMTPClient.send($emailMessage)
$emailMessage.dispose()

popd


