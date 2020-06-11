param (
	$Server = $SmtpHostPreference, # SMTP Сервер
	$From = $SmtpFromPreference, # Адрес отправителя
	[string[]]$To, # Получатели
	$Body = "", # Тело сообщения
	$Subject = "", # Тема сообщения
	[System.IO.FileInfo[]]$Attachment=@(), # Вложения
	[switch]$SSL,
	[System.Management.Automation.PSCredential]$Credentials=$null
)

Write-Verbose "Создаем объекты SmtpClient и MailMessage"
$SmtpClient = New-Object System.Net.Mail.SmtpClient
$Message = New-Object System.Net.Mail.MailMessage
Write-Verbose "Устанавливаем свойства этих объектов"
$SmtpClient.EnableSsl = $SSL
if($Credentials){$SmtpClient.Credentials = $Credentials.GetNetworkCredential()}
$SmtpClient.Host = $Server
$Message.Body = $Body
$Message.Subject = $Subject
$Message.From = $From
Write-Verbose "Создаем и добавляем вложения"
$Attachment | ForEach-Object {
	$a = New-Object System.Net.Mail.Attachment($_.fullname)
	$Message.Attachments.Add($a)
}
Write-Verbose "Добавляем получателей"
$To | ForEach-Object {$Message.To.Add($_)}
Write-Verbose "Отправляем сообщение"
$smtpclient.Send($Message)
Write-Verbose "Удаляем объекты"
$Message.Dispose()