$userprofile=$Env:USERPROFILE
$date=Get-Date -format "MMddyyyyhmmss"
$savename="blips_118379463"
$localbackupsave="$savename_$date.bak"
$savegameinfosave="SaveGameInfo_$date.bak"
$cloudstorage="$userprofile\seafile\GameSaves\stardiew save"
$gamesaveLocation="$userprofile\AppData\Roaming\StardewValley\Saves"
$BackupSaveLocation="$userprofile\AppData\Roaming\StardewValley\Backupsaves"

remove-item "$cloudstorage\$savename" -Recurse
start-sleep -s 1
Copy-Item   "$gamesaveLocation\$savename" -Recurse "$cloudstorage"
start-sleep -s 1
rename-Item "$gamesaveLocation\$savename\$savename" -Force "$savename_$date.bak"
rename-Item "$gamesaveLocation\$savename\SaveGameInfo" -Force "SaveGameInfo_$date.bak"
move-item   "$gamesaveLocation\$savename\$localbackupsave" "$BackupSaveLocation" -Force
move-item   "$gamesaveLocation\$savename\$savegameinfosave" "$BackupSaveLocation" -Force
