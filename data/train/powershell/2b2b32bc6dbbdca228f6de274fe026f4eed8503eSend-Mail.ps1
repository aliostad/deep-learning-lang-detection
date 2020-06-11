Function Send-Mail {
	Param($From, $To, [Array]$Attachments, $Subject, $Body, $Server,[Switch] $HTML)
	[Void][Reflection.Assembly]::LoadWithPartialName("System.Net") 
	$Message = New-Object System.Net.Mail.MailMessage($From, $To)
	if ($HTML) { $Message.IsBodyHTML = $true }
	$Message.Body = $Body
	$Message.Subject = $Subject
	ForEach($Attachment in $Attachments) {
		$Attachment = New-Object Net.Mail.Attachment($Attachment)
		$Message.Attachments.Add($Attachment)
	}
	###Send the message
	$SMTPClient = New-Object System.Net.Mail.SMTPClient $Server
	$SMTPClient.Send($Message)
}
