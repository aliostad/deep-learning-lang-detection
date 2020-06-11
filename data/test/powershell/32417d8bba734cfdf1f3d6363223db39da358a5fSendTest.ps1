# coding: Windows-31J
#
#
# PowerShell でメール送信！
#
#
#
#

function _create_message() {
	
	$message = New-Object System.Net.Mail.MailMessage
	$from = New-Object System.Net.Mail.MailAddress("mail.from@example.jp", "差出人 表示部分")
	$message.From = $from
	$to = New-Object System.Net.Mail.MailAddress("rcpt.to@example.jp", "宛先 表示部分")
	$message.To.Add($to)
	$message.SubjectEncoding = [System.Text.Encoding]::UTF8
	$message.Subject = "subject です... "
	$message.BodyEncoding = [System.Text.Encoding]::UTF8
	$message.Body = "body です..."
	# $message.Attachments = ""
	return $message
}

function _send($message) {

	# 接続先
	$client = New-Object System.Net.Mail.SmtpClient
	$client.Host = "example.jp"
	$client.Port = 587

	# SMTP 認証の準備
	$credentials = New-Object Net.NetworkCredential
	$credentials.UserName = "user.name"
	$credentials.password = "jkJhsyTwg;aa@S"
	$client.Credentials = $credentials

	$client.Send($message)
}

function _main() {

	Write-Host "### start ###"

	$message = _create_message

	_send($message)

	Write-Host "--- end ---"
}

_main
