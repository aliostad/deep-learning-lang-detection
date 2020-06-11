# PowerShell Email Script
# Nicholas Armstrong, Dec 2009
# Available at http://nicholasarmstrong.com

# Mail Message
$from = "user@domain.com"
$to = "user@domain.com"
$subject = "Hello from PowerShell"
$body = "This is a message saying hello from PowerShell."
$hasAttachment = $false
$attachmentPath = "attachmentPath.txt"

# Mail Server Settings
$server = "smtp.gmail.com"
$serverPort = 587
$timeout = 30000          # timeout in milliseconds
$enableSSL = $true
$implicitSSL = $false

# Get user credentials if required
if ($enableSSL)
{
    $credentials = [Net.NetworkCredential](Get-Credential)
}

if (!$enableSSL -or !$implicitSSL)
{
    # Set up server connection
    $smtpClient = New-Object System.Net.Mail.SmtpClient $server, $serverPort
    $smtpClient.EnableSsl = $enableSSL
    $smtpClient.Timeout = $timeout
    
    if ($enableSSL)
    {
        $smtpClient.UseDefaultCredentials = $false;
        $smtpClient.Credentials = $credentials
    }
    
    # Create mail message 
    $message = New-Object System.Net.Mail.MailMessage $from, $to, $subject, $body
    
    if ($hasAttachment)
    {
        $attachment = New-Object System.Net.Mail.Attachment $attachmentPath
        $message.Attachments.Add($attachment)
    }
    
    # Send the message
    Write-Output "Sending email to $to..."
    try
    {
        $smtpClient.Send($message)
        Write-Output "Message sent."
    }
    catch
    {
        Write-Error $_
        Write-Output "Message send failed."
    }
    
}
else
{
    # Load System.Web assembly
    [System.Reflection.Assembly]::LoadWithPartialName("System.Web") > $null
    
    # Create a new mail with the appropriate server settigns
    $mail = New-Object System.Web.Mail.MailMessage
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpserver", $server)
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpserverport", $serverPort)
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpusessl", $true)
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", $credentials.UserName)
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", $credentials.Password)
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout", $timeout / 1000)
    # Use network SMTP server...
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusing", 2)
    # ... and basic authentication
    $mail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", 1)
    
    # Set up the mail message fields
    $mail.From = $from
    $mail.To = $to
    $mail.Subject = $subject
    $mail.Body = $body
    
    if ($hasAttachment)
    {
        # Convert to full path and attach file to message
        $attachmentPath = (get-item $attachmentPath).FullName
        $attachment = New-Object System.Web.Mail.MailAttachment $attachmentPath
        $mail.Attachments.Add($attachment) > $null
    }
    
    # Send the message
    Write-Output "Sending email to $to..."
    try
    {
        [System.Web.Mail.SmtpMail]::Send($mail)
        Write-Output "Message sent."
    }
    catch
    {
        Write-Error $_
        Write-Output "Message send failed."
    }
}