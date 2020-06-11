$smtpServer = "bws1i.berbee.isi.lan"
$smtpFrom = "CDR_Counts@isi-info.com"
$smtpTo = "jmulhern@isi-info.com"
$messageSubject = "CDR Counts for CDRPOLLING"

$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true

$directory = "\\BWS1i\cdr\CDRPOLLING\";

$style = "<style> BODY{font-family: Arial; font-size: 10pt;}"
$style += "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style += "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style += "TD{border: 1px solid black; padding: 5px; }"
$style += "</style>"


$message.Body += Get-ChildItem -Path $directory -Recurse -Force -filter "*.r0*"|
Where-Object { !$_.PSIsContainer } |
Group-Object Extension |
Select-Object @{n="Extension";e={$_.Name -replace '^\.'}}, Count , @{n="Size (MB)";e={[math]::Round((($_.Group | Measure-Object Length -Sum).Sum / 1MB), 2)}} | sort Extension | ConvertTo-Html -Head $style;


$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)