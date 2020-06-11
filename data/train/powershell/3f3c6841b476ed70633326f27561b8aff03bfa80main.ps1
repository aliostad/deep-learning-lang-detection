$path = Split-Path -parent $PSCommandPath

. "$path\ini.ps1"
. "$path\config.ps1"
. "$path\logging.ps1"
. "$path\snapraid.ps1"
. "$path\shadowcopy.ps1"
. "$path\email.ps1"

# EXE of SnapRaid
$snapRaidExe = $config["SnapRaid"]["path"] + "\snapraid.exe"

# Path to config
$config_base = $config["SnapRaid"]["config"]
# Path to config with ShadowCopy paths
$config_shadow = $config["SnapRaid"]["config_shadow"]

$min_age = $config["ShadowCopy"]["min_age"]
# Lock File
$lock_file = $config["SnapRaid"]["lock_file"]

# Current Time (for consistency)
$now = Get-Date

# Update config
function Update-ShadowConfig()
{
	try
	{
		$file = New-Object System.IO.StreamWriter $config_shadow
		
		foreach ( $l in Get-Content $config_base )
		{
			# Format: disk d1 D:\
			if ( $l.StartsWith("disk") )
			{
				$tmp = $l.Split(" ")

				writeLog("Cheking shadow copy for: " + $tmp[2])

				$sc = Get-LatestShadowCopy($tmp[2])
				
				$updateShadowCopy = 0

				if ($sc)
				{
					$InstallDate = [system.management.managementdatetimeconverter]::todatetime(($sc).InstallDate)

					# Check age of Shadow Copy
					if ($now.Subtract($InstallDate).TotalHours -gt $min_age)
					{
						$updateShadowCopy = 1
					}
				}
				else
				{
					$updateShadowCopy = 1
				}

				# Update Shadow Copy
				if ($updateShadowCopy)
				{
					writeLog("Updating")
					
					$sc = Update-ShadowCopy($tmp[2])
					
					writeLog("Update Done")
				}
				else
				{
					writeLog("Skipping, less than $min_age hours old")
				}

				$file.WriteLine("disk " + $tmp[1] + " " + $sc.DeviceObject + "\")
			}
			else
			{
				$file.WriteLine($l)
			}
		}

		$file.Close()
	}
	catch
	{
		throw "Config update failed"
	}
}

function Get-FileLock($name)
{
    if (-Not(Test-Path $name))
    {
        Set-Content $name ""
    }
	$file = 0
	
	try {
		$file = [System.IO.File]::Open($name, 'Open', 'ReadWrite', 'None')
	}
	catch {
		$file = 0
	}
	
	return $file
}