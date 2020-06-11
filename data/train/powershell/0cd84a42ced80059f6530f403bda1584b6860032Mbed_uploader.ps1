#NAZWA MIKROKONTROLERA
$name = "NUCLEO"                              # NUCLEO
$download = "D:\Biblioteki\Pobrane\Chrome"      # C:\Documents\Downloads


########################################################################################

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$objBalloon = New-Object System.Windows.Forms.NotifyIcon
$objBalloon.Icon = "favicon.ico"
$objBalloon.Visible = $True
$objBalloon.BalloonTipTitle = "Mbed uploader"
$file = "$download\*$name*.bin"


echo "Mbed auto uploader 1.0 by Michal Szymocha"
echo "MCU : $name"
echo "Loc : $download"



while($true)
{

	if (!$drive){
		$drive = Get-WMIObject -Class Win32_Volume | Select DriveLetter ,Label | select-string -pattern "$name" | out-string
		try { $drive = $drive.Substring(16,1) + ":\" }
		catch { 
			if (!$drive){
				$objBalloon.BalloonTipIcon = "Warning"
				$objBalloon.BalloonTipText = "Oczekiwanie na mikrokontroler $name."
				$objBalloon.ShowBalloonTip(0) 
			}
			while(!$drive){
				Start-Sleep -m 250
				$drive = Get-WMIObject -Class Win32_Volume | Select DriveLetter ,Label | select-string -pattern "$name" | out-string
				try { $drive = $drive.Substring(16,1) + ":\" }
				catch { }
		}}
		if ($drive){
			$objBalloon.BalloonTipIcon = "Info"
			$objBalloon.BalloonTipText = "Wykryto mikrokontroler $name - $drive"
			$objBalloon.ShowBalloonTip(1) 
		}
		Start-Sleep -m 1000
	}			
	if (Test-Path $file){
		$error.clear()
		try { move $file $drive }
		catch { "Error"}
		if ($error) {
		$objBalloon.BalloonTipIcon = "Error"
					$objBalloon.BalloonTipText = "Problem z wgrywaniem wsadu do mikrokontrolera !"
					$objBalloon.ShowBalloonTip(5000) 
					Start-Sleep -m 1000
					$drive = ""
		}
		$objBalloon.BalloonTipIcon = "Info"
		$objBalloon.BalloonTipText = "Wsad w mikrokontrolerze $name zaakualizowany !!!"
		$objBalloon.ShowBalloonTip(1) 
	}
	Start-Sleep -m 500
}	 

