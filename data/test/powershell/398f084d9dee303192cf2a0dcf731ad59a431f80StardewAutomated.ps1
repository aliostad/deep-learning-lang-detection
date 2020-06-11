6#launch the BOI:R with a modified hud. The program checks the status of BOI:R, and closes the hud if BOI:R is not running
#Written by Sam Schoeller
#References:
#http://powershell.com/cs/blogs/tips/archive/2011/08/25/check-whether-a-program-is-running.aspx
#http://blogs.technet.com/b/heyscriptingguy/archive/2014/04/29/powershell-looping-using-the-foreach-object-cmdlet.aspx


$stardew="C:\GOG Games\Stardew Valley\Stardew Valley.exe"
$array=(1..566)
$userprofile=$Env:USERPROFILE
$date=Get-Date -format "MMddyyyyhmmss"
$savename="blips_118379463"
$localbackupsave="$savename_$date.bak"
$savegameinfosave="SaveGameInfo_$date.bak"
$cloudstorage="$userprofile\seafile\GameSaves\stardiew save"
$gamesaveLocation="$userprofile\AppData\Roaming\StardewValley\Saves"
$BackupSaveLocation="$userprofile\AppData\Roaming\StardewValley\Backupsaves"

#copy save from cloud sync to stardew appdata folder

remove-item "$gamesaveLocation\$savename" -Recurse -Force
start-sleep -s 1
Copy-Item   "$cloudstorage\$savename" -Recurse "$gamesaveLocation\" -Force
rename-Item "$cloudstorage\$savename" "$savename_$date.bak" -Force
start-sleep -s 1
move-item   "$cloudstorage\$localbackupsave" "$cloudstorage\Backupsaves\" 


Start $stardew


#Watches the stardew exec. for several hours When closed, backups and moves save to cloud storage location. 
$array | ForEach-Object {
  If (((get-process stardew* -ea 0) -ne $null) -ne $true){
  remove-item "$cloudstorage\$savename" -Recurse;
  start-sleep -s 1;
  Copy-Item   "$gamesaveLocation\$savename" -Recurse "$cloudstorage";
  start-sleep -s 1;
  rename-Item "$gamesaveLocation\$savename\$savename" -Force "$savename_$date.bak";
  rename-Item "$gamesaveLocation\$savename\SaveGameInfo" -Force "SaveGameInfo_$date.bak";
  move-item   "$gamesaveLocation\$savename\$localbackupsave" "$BackupSaveLocation" -Force;
  move-item   "$gamesaveLocation\$savename\$savegameinfosave" "$BackupSaveLocation" -Force;
  Start-Sleep -Seconds 3; exit};
  Start-Sleep -Seconds 75
}
exit
