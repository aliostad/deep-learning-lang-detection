<# So a stupid program I manage makes copies of it's entire database after every change. Even though backups are disabled. To keep it from filling the drive this is setup as a scheduled task to run a few times a day.
#>
﻿
$Date = Get-Date
$Date = $Date.AddDays(-5)
$Date = Get-Date -Date $Date -Format yyyy-MM-d
$ATXBackups = Get-ChildItem E:\ATX\Backup\Database
IF ($ATXBackups.Count -gt "10") {
	$ATXBackups | ForEach-Object {
		IF ($_.Name -lt $Date) {$_ | Remove-Item -Confirm:$false -Recurse:$true -ErrorAction:SilentlyContinue -Force:$true}
    }
}
