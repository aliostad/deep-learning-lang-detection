#########################################################
#		Monthly mailbox email report		#
#		Version: 1.2				#
#		Created: 28/10/2014			#
#		Creator: Nostalgiac			#
#							#
#		Required config:			#
#		$smtpServer				#
#		$smtpFrom				#
#		$smtpTo					#
#		$smtpServer				#
#########################################################

#Import Exchange 2010 Module
Add-PSSnapIn Microsoft.Exchange.Management.PowerShell.E2010

#Get the month
$CurrentDate = Get-Date

#Convert date to a string
$CurrentDate = $CurrentDate.ToString('MMMM')

$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"

#Get list of mailbox databases
$mbxDB = Get-MailboxDatabase

#Get mailbox statistics for each database
foreach ($database in $mbxDB) {
        $body += Get-MailboxStatistics -Database $database | Select DisplayName, ItemCount, TotalItemSize | Sort-Object TotalItemSize -Descending | ConvertTo-Html -Head $style | Out-String
        }

#Email results to IT
$smtpServer = "mail.domain.com.au"
$smtpFrom = "exchangeserver@domain.com.au"
[string[]]$smtpTo = "user1@domain.com.au,user2@domain.com.au"
$messageSubject = $CurrentDate + " Email Report"

$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true
$message.Body = $body

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)