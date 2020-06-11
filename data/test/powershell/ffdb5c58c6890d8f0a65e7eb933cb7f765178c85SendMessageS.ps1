param(
	[parameter(mandatory = $true)]
	[int]$MessageCount
	)

function SendMessage($MailTo, $MailFrom)
{
	$Domain = $env:UserDnsDomain
	$MailToAddress = "$MailTo@$Domain"
    $MailFromAddress = "$MailFrom@$Domain"
    $Subject = "Test Mail"
	$Body = "Test Mail Body"

	$Password = ConvertTo-SecureString "T%nt0wn" -AsPlainText -Force
	$PSCredential = New-Object System.Management.Automation.PSCredential($MailFromAddress, $Password)

	$SmtpServer = (Get-TransportServer).Name

	Send-MailMessage -To $MailToAddress -From $MailFromAddress -Subject $Subject -Body $Body -SmtpServer $SmtpServer -Credential $PSCredential
}

function SendMessages([int]$MessageCount)
{
	Get-ReceiveConnector | Set-ReceiveConnector -PermissionGroups 'AnonymousUsers, ExchangeUsers, ExchangeServers, ExchangeLegacyServers'

	for($i = 0; $i -le $MessageCount; $i++)
	{
		Write-Progress -Activity "Sending Messages..." -PercentComplete ($i / $MessageCount * 100) -CurrentOperation "Sending $i Message" -Status "Please Wait..."
		SendMessage "test" "administrator"
	}
}


SendMessages $MessageCount


