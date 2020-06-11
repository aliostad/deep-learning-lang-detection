
$from = "CAEN Windows Remote Desktop Help <CLSE-Deployment-NoReply@umich.edu>"
$smtpServer = "mx1.a.mail.umich.edu"
$to = @(get-content -path "\\caen-mainline.m.storage.umich.edu\caen-mainline\scripts\usersToEmailNow.txt")
		
foreach ($user in $to){
	$user
}
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$message = new-object System.Net.Mail.MailMessage
$message.From = $from
$message.To.Add($to)
$message.Subject = "CAEN Remote Access Assistance"
$message.body = "Our records indicate you have attempted to access the CAEN Windows Remote Desktop service multiple times without using the required Duo two-factor authentication. Please see the following FAQ page with information regarding Duo enrollment and instructions on how to connect:`n`nhttp://caenfaq.engin.umich.edu/duo/off-campus-remote-access-duo`n`nSincerely,`n`nCAEN Service & Support"

#$smtp.Send($message)
remove-item "\\caen-mainline.m.storage.umich.edu\caen-mainline\scripts\usersToEmailNow.txt"