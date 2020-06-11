$userprofile=$Env:USERPROFILE
$savename="blips_118379463"
$date=Get-Date -format "MMddyyyyhmmss"
$localbackupsave="$savename_$date.bak"
$savegameinfosave="SaveGameInfo_$date.bak"
$cloudstorage="$userprofile\seafile\GameSaves\stardiew save"
$gamesaveLocation="$userprofile\AppData\Roaming\StardewValley\Saves"
$BackupSaveLocation="$userprofile\AppData\Roaming\StardewValley\Backupsaves"


remove-item "$gamesaveLocation\$savename" -Recurse -Force
start-sleep -s 1
Copy-Item   "$cloudstorage\$savename" -Recurse "$gamesaveLocation\" -Force
rename-Item "$cloudstorage\$savename" "$savename_$date.bak" -Force
start-sleep -s 1
move-item   "$cloudstorage\$localbackupsave" "$cloudstorage\Backupsaves\" 

