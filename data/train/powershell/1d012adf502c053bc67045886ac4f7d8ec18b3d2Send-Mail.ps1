param(
	[string]
	$to,
	[string]
	$subject
)

$script:message = ''

function populate-message {
	param($toName, $subject)

	$script:message = [System.IO.Path]::GetTempFileName()

	"`n`n### Lines delimited with '###' will not be sent.`n### TO: $toName`n### SUBJECT: $subject`n" | 
		Out-File $script:message

	vim $script:message
}

function send {
	$app = New-Object -Com Outlook.Application
	$mailItem = $app.CreateItem('olMailItem')

	$recip = $mailItem.Recipients.Add($to)

	if ($recip.Resolve()) {
		populate-message $recip.Name $subject

		$mailItem.Subject = $subject

		$body = Get-Content $script:message | where { $_ -notmatch '###' }

		$mailItem.Body = $body
		$mailItem.Send()
	}
	else {
		Write-Error "$to could not be found."
	}

	Remove-Item $script:message
	Remove-Item variable:mailItem
	Remove-Item variable:app
}

Send
