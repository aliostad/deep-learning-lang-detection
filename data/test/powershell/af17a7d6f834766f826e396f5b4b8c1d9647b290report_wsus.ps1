trap [Exception] {
	$t = $error[0].ToString().Trim() + "`n" + $error[0].InvocationInfo.PositionMessage.Trim()
	[Diagnostics.EventLog]::WriteEntry("report_wsus", $t, "Error", 1)
}

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$update_server = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
$update_server.PreferredCulture ="ja"

$email_conf = $update_server.GetEmailNotificationConfiguration()

$update_scope = new-object Microsoft.UpdateServices.Administration.UpdateScope
$allComputersGroup = $update_server.GetComputerTargetGroup([Microsoft.UpdateServices.Administration.ComputerTargetGroupId]::AllComputers)

$classifications_text = ""
foreach($guid in @(
	# Service Packs
	"68c5b0a3-d1a6-4553-ae49-01d3a7827828",
	# セキュリティ問題の修正プログラム
	"0fa1201d-4330-4fa8-8ae9-b877473b6441",
	# 修正プログラム集
	"28bc880e-0592-4cbf-8f95-c79b17911d5f",
	# 重要な更新
	"e6cf1350-c01b-414d-a61f-263d14d133b4"
))
{
	$classification = $update_server.GetUpdateClassification((New-Object System.Guid($guid)))
	$classifications_text += [string]::Format("`t{0}`n", $classification.Title)
	$ret = $update_scope.Classifications.Add($classification)
}



# IComputerTarget.Id => IComputerTarget
$bad_computers = @{}

$body = ""

$dt_start = [System.DateTime]::Now

# 更新に対する条件
$update_scope.ApprovedStates = [Microsoft.UpdateServices.Administration.ApprovedStates]::LatestRevisionApproved -bor [Microsoft.UpdateServices.Administration.ApprovedStates]::HasStaleUpdateApprovals
$update_scope.IncludedInstallationStates = 
	[Microsoft.UpdateServices.Administration.UpdateInstallationStates]::Unknown -bor
	[Microsoft.UpdateServices.Administration.UpdateInstallationStates]::NotInstalled -bor
	[Microsoft.UpdateServices.Administration.UpdateInstallationStates]::InstalledPendingReboot -bor
	[Microsoft.UpdateServices.Administration.UpdateInstallationStates]::Failed -bor
	[Microsoft.UpdateServices.Administration.UpdateInstallationStates]::Downloaded

# コンピュータに対する条件
$computer_scope = new-object Microsoft.UpdateServices.Administration.ComputerTargetScope
$computer_scope.IncludedInstallationStates = $update_scope.IncludedInstallationStates

foreach($summary in $update_server.GetSummariesPerComputerTarget($update_scope, $computer_scope))
{
	$computer = $update_server.GetComputerTarget($summary.ComputerTargetId)
	$id = $computer.Id.ToString()
	$bad_computers[$id] = $computer
}


$body += [string]::Format("検索時間：{0}`n", [System.DateTime]::Now.Subtract($dt_start).ToString())

if($bad_computers.Count -eq 0)
{
	exit
}

$body += @"
対象更新クラス：
$classifications_text
コンピュータ：

"@

$searcher = New-Object DirectoryServices.DirectorySearcher
foreach($computer in $bad_computers.values | sort FullDomainName)
{
	$manage_cn = ""

	$computer_account = $computer.FullDomainName.Split(".")[0] + '$'
	$searcher.Filter = "(sAMAccountName=$computer_account)"
	$result = $searcher.FindOne()
	if($result -ne $null)
	{
		$managed_by = $result.Properties["managedby"]

		if($managed_by -match "CN=(?<cn>[^,]+)")
		{
			$manage_cn = $matches.cn
		}
	}

	$v = $computer.OSInfo.Version
	$a = @(
		$computer.FullDomainName,
		$computer.IPAddress.ToString(),
		$computer.LastReportedStatusTime.ToLocalTime().ToString(),
		$manage_cn,
		$computer.Make.Trim(),
		$computer.Model.Trim(),
		$computer.OSArchitecture.Trim(),
		$computer.OSDescription.Trim(),
		[string]::Join(".", @($v.Major, $v.Minor, $v.Build)),
		[string]::Join(".", @($v.ServicePackMajor, $v.ServicePackMinor))
	)
	$body +=[string]::Join("`t", $a) + "`n"
}

$mail = New-Object System.Net.Mail.SmtpClient($email_conf.SmtpHostName)
$mail.Timeout = 30 * 1000

$msg = New-Object System.Net.Mail.MailMessage
$msg.Subject = "[WSUS]更新未適用コンピュータ"
$msg.From = New-Object System.Net.Mail.MailAddress($email_conf.SenderEmailAddress, $email_conf.SenderDisplayName)
foreach($rcpt in $email_conf.StatusNotificationRecipients)
{
	$msg.To.Add($rcpt)
}
$msg.Body = $body

$mail.Send($msg)



