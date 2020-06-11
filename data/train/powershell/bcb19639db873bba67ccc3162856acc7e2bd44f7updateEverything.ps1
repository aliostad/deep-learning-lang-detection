[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Function WSUSUpdate {
	echo "Searching for updates..."
	$Criteria = "IsInstalled=0 and Type='Software' or IsInstalled=0 and Type='Driver'"
	$Searcher = New-Object -ComObject Microsoft.Update.Searcher
	try {
		$SearchResult = $Searcher.Search($Criteria).Updates
		if ($SearchResult.Count -eq 0) {
			[System.Windows.Forms.MessageBox]::Show("System is updated. You can remove this script from the computer.","System is updated!")
		} 
		else {
			$Session = New-Object -ComObject Microsoft.Update.Session
			$Downloader = $Session.CreateUpdateDownloader()
			$Downloader.Updates = $SearchResult
			echo "Downloading ALL updates..."
			$Downloader.Download()
			$Installer = New-Object -ComObject Microsoft.Update.Installer
			$Installer.Updates = $SearchResult
			echo "Installing ALL updates..."
			$Result = $Installer.Install()
			If ($Result.RebootRequired) {
				echo "Reboot is required. Rebooting..."
				Restart-Computer
			}
			else {
				echo "Reboot is not required."
				echo "Rerunning scrpit..."
				WSUSUpdate
			}
		}
	}
	catch {
		[System.Windows.Forms.MessageBox]::Show("System is updated. You can remove this script from the computer.","System is updated!")
	}
}

WSUSUpdate
