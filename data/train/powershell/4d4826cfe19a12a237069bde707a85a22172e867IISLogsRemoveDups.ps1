function crawlFolder($rootFolder, $isRoot, $deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles)
{
	#Check if this folder exists first
	if (Test-Path -Path $rootFolder)
	{
		#Get the subfolders in this folder
		$folders = Get-ChildItem -Path ($rootFolder) | where {$_.PSIsContainer}
		#Make sure we have at least one subfolder
		if ($folders)
		{	
			#Loop through the subfolders
			foreach ($folder in $folders) 
			{
				#Crawl this subfolder and add it to the total size
				$deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles = crawlFolder $folder.FullName $false $deletedSize $deletedCount $skipSize $skipCount $errorFiles
			}
		}
		#Get the list of files in this folder
		$files = Get-ChildItem $rootFolder | Where-Object { !$_.PSIsContainer }
		#Make sure we have at least one file
		if ($files)
		{	
			#Loop through the files
			foreach ($file in $files)
			{
				#Check to see if the file is older than our threshold
				if ($file.lastWriteTime -lt (Get-Date).AddHours(-$dateModifiedThreshold))
				{
					#check if it's a gz file
					if ($file.Extension -eq ".gz")
					{
						#set the source file
						$sourceFile = $rootFolder.Replace($locationDestination, $locationSource) + "\" + $file.Name
						#check for the source file
						if (Test-Path $sourceFile)
						{
							#delete the file at the source
							if (!$testMode) { Remove-Item -Path $sourceFile 2> $null }
							Write-Host $sourceFile
							#if the file was deleted, add it to the total size
							if ($?) { $deletedSize += $file.Length; $deletedCount++ }
							else { $errorFiles += ($file.FullName + ",") }
						}
					}
				}
				#File is under our threshold
				else 
				{
					#Add this file to the list of skipped files
					$skipSize += $file.Length
					$skipCount++;
				}
			}
		}
	}
	#Return the total size of the files deleted so far
	return $deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles
}

function sendSMTPMessage($messageBody)
{
	$SMTP = New-Object Net.Mail.SmtpClient("mail2.desire2learn.com")
	$mailMessage = New-Object Net.Mail.MailMessage
	$mailMessage.From = "noreply@desire2learn.com"
	$mailMessage.To.Add("kevin.fox@desire2learn.com")
	#$mailMessage.To.Add("mike.cote@desire2learn.com")
	$mailMessage.Subject = ("File Server - IIS Migration")
	$mailMessage.Body = $messageBody
	$mailMessage.IsBodyHtml = $true
	$SMTP.Send($mailMessage)
}

$dateModifiedThreshold 	= 8760		#Hours
$testMode				= $false
$locationDestination 	= "\\hfis01\IIS_Logs\"
$locationSource			= "\\archive\iis_logs\"

Clear

$mailMessage = ""
$errorFiles = ""

#hop into the root folder
$deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles = crawlFolder $locationDestination $true 0 0 0 0 $errorFiles

#Add to the mail message
$mailMessage += "<tr>"
$mailMessage += ("<td>" + $location + "</td>")
$mailMessage += ("<td>" + $deletedCount + "</td>")
$mailMessage += ("<td>" + ([Math]::Round($deletedSize / 1024 / 1024, 2)) + "</td>")
$mailMessage += ("<td>" + $skipCount + "</td>")
$mailMessage += ("<td>" + ([Math]::Round($skipSize / 1024 / 1024, 2)) + "</td>")
$mailMessage += "</tr>"
#Finalize the mail message
$mailMessage = ("<table border=`"1`"><tr><td><b>Location</b></td><td><b>Deleted Files</b></td><td><b>Deleted Size (MB)</b></td><td><b>Files Ignored</b></td><td><b>Ignored Size (MB)</b></td></tr>" + $mailMessage + "</table><br>")
#Check for any files we had errors on
if ($errorFiles) 
{ 
	$errorFiles = $errorFiles.Substring(0, $errorFiles.Length - 1)
	$mailMessage += "<br><b>Files Could Not Be Deleted:</b><br>"
	foreach ($file in $errorFiles.Split(",")) { $mailMessage += ($file + "<br>") }
}
#Send the email
sendSMTPMessage $mailMessage
