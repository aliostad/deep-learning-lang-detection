
# just wraps Send-MailMessage
Function mySendMail($mailTo,$mailFrom,$mailSubject,$mailBody,$smtpServer,$mailAttachments)
{
  
  if ($mailAttachments) {

    Send-MailMessage -To $mailTo -From $mailFrom -Subject $mailSubject -Body $mailBody `
                     -SmtpServer $smtpServer -UseSsl -Attachments $mailAttachments
   
   }
   else {
    
    Send-MailMessage -To $mailTo -From $mailFrom -Subject $mailSubject -Body $mailBody `
                     -SmtpServer $smtpServer -UseSsl

   }

}

Function mySms() {

  # not implemented yet

}