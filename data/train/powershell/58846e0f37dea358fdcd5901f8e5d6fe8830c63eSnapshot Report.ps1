#region Snapins
add-pssnapin VMware.VimAutomation.Core
#endregion

#region Functions
function getSnapshots()
{
	$SnapshotList = @()
	#Get the VMs for this cluster
	$VMs = Get-VM
	#Sort the VMs
	$VMs = $VMs | Sort
	#Loop through the VMs looking for Snapshots
	foreach ($VM in $VMs)
	{	
		#Get the Snapshots for this VM
		$Snapshots = Get-Snapshot -VM $VM
		#Make sure we got something back
		if ($Snapshots)
		{
			#Loop through the Snapshots
			foreach ($Snapshot in $Snapshots) { $SnapshotList += $Snapshot }
		}
		#if ($SnapshotList.Count -ge 2) { break }
	}
	#Return the list
	return $SnapshotList
}

function createMessageBody($SnapshotList)
{
	#Create the email message body
	$MessageBody = "<table border=`"1`">"
	$MessageBody += "<tr><td><b>VM</b></td><td><b>Snapshot</b></td><td><b>Created</b></td><td><b>Size (MB)</b></td><td><b>Description</b></td></tr>"
	foreach ($Snapshot in $SnapshotList)
	{
		$MessageBody += "<tr>"
		$MessageBody += ("<td>" + $Snapshot.VM.Name + "</td>")
		$MessageBody += ("<td>" + $Snapshot.Name + "</td>")
		$MessageBody += ("<td>" + $Snapshot.Created + "</td>")
		$MessageBody += ("<td>" + $Snapshot.SizeMB + "</td>")
		$MessageBody += ("<td>" + $Snapshot.Description + "</td>")
		$MessageBody += "</tr>"
	}
	$MessageBody += "</table>"
	#Return the message
	return $MessageBody
}

function sendSMTPMessage($Site, $MessageBody)
{
	$SMTP = New-Object Net.Mail.SmtpClient("mail2.desire2learn.com")
	$MailMessage = New-Object Net.Mail.MailMessage
	$MailMessage.From = "noreply@desire2learn.com"
	$MailMessage.To.Add("kevin.fox@desire2learn.com")
	$MailMessage.Subject = ("VMware Snapshots - " + $Site)
	$MailMessage.Body = $MessageBody
	$MailMessage.IsBodyHtml = $true
	$SMTP.Send($MailMessage)
}
#endregion

#region User Variables
#User Variables
$SMTPServer = "mail2.desire2learn.com"
#endregion

#region Program Variables
#Program Variales
$SnapshotList = @()
#endregion

#Clear the screen
Clear

#Connect to a VI Cluster
Connect-VIServer -Server "T1VCS01" | Out-Null
#Get the list of Snapshots in Bell
$SnapshotList = getSnapshots
#Create the email message body
$MessageBody = createMessageBody $SnapshotList
#Disconnect from the VI Cluster
Disconnect-VIServer -Server "T1VCS01" -Confirm:$false
#Send the email message
sendSMTPMessage "Bell" $MessageBody

#Connect to a VI Cluster
Connect-VIServer -Server "HFVCS01" | Out-Null
#Get the list of Snapshots in Verizon
$SnapshotList = getSnapshots "HFVCS01"
#Create the email message body
$MessageBody = createMessageBody $SnapshotList
#Disconnect from the VI Cluster
Disconnect-VIServer -Server "HFVCS01" -Confirm:$false
#Send the email message
sendSMTPMessage "Verizon" $MessageBody

Write-Host "Done."