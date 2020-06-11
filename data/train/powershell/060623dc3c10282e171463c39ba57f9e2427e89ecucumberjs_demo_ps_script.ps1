set-location C:\Users\Andrej\sebastian\cucumberjs-example
git pull
grunt cucumberjs
if ( "$?" -ne "False" ) {$Subject = "Test Passed - HTML Body Simple Style Email"} 
else {$Subject = "Test Failed - HTML Body Simple Style Email"}
$Body = Get-Content cucumber_test_results_simple.html
$EmailFrom = “andrej@rasevicengineering.com”
$EmailTo = "sebastian.kropp@outlook.com”
$SMTPServer = “smtp.gmail.com”
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$MailMessage = New-Object Net.Mail.MailMessage($EmailFrom, $EmailTo, $Subject, $Body)
$MailMessage.IsBodyHTML = $true
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential(”FromAddress", “Password”);
$SMTPClient.Send($MailMessage)
