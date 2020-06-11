 Send-SMTPMessage.ps1
 $fecha = Get-Date  -uformat "%d/%m/%Y "
 $file = "C:\tmp\xxxxx.txt"
 $att = new-object Net.Mail.Attachment($file)
 $from = New-Object System.Net.Mail.MailAddress "xxx@xxxxxxxx.es"
 $to =   New-Object System.Net.Mail.MailAddress "xxx@xxxxxxxx.es"
 $copy = New-Object System.Net.Mail.MailAddress "xxx@xxxxxxxx.es";
 $copy1 = New-Object System.Net.Mail.MailAddress "dpto.xxx@xxxxxxxx.es";
 $asunto = 'texsto del asunto con la fecha anidada ' + $fecha
 # Create Message
 $message = new-object  System.Net.Mail.MailMessage $from, $to
 $message.CC.Add($copy);
 $message.CC.Add($copy1);
 $message.Subject = $asunto
 $message.Body = "ese cuerpo serrano "
 $message.Attachments.Add($att)
 
 # Set SMTP Server and create SMTP Client
 $server = "smtp.casadasd.net"
 $client = new-object system.net.mail.smtpclient $server
 
 # Send the message
 "Sending an e-mail message to {0} by using SMTP host {1} port {2}." -f $to.ToString(), $client.Host, $client.Port
 try {
    $client.Send($message)
  $att.Dispose()
    "Message to: {0}, from: {1} has beens successfully sent" -f $from, $to
 }
 catch {
   "Exception caught in CreateTestMessage: {0}" -f $Error.ToString()
 }