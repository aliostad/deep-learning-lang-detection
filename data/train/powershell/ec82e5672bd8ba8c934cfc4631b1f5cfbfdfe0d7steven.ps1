# Input parameters
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[ValidateSet("monthly", "daily")]
	[string]$type,
	
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("2012R2-std", "2012R2-dc")]
	[string]$version 
)

# Functions

function Get-ExtendedDate{
	$a = get-date
	add-member -MemberType scriptmethod -name GetWeekOfYear -value {get-date -uformat %V} -inputobject $a
	$a
	}

# Determine build number base on history

if(!(Test-Path .\build\$version) ){
	# write-host "file does not exists, creating..."
	(New-Item -Path .\build -Name $version -ItemType file) > $null
	}

$build = gc .\build\$version
if($build -eq $null) {
	# write-host "first build"
	# write-host "adding sequence 1 plus time stamp"
	$buildnumber = 1
	$date = get-date
	$build = [string]$buildnumber + ",`t" + [string]$date
	$header = "#, `tTime stamp"
	$header | Out-File .\build\$version
	$build |Out-File -Append .\build\$version
	}
else{
	$latest = ($build[$build.count -1]).split(",")[0]
	$latest = $build[$build.count-1].split(",")[0]
	# write-host "latest buildnumber: " $latest
	$buildnumber = [int]$latest + 1
	$date = get-date
	$build = [string]$buildnumber + ",`t" + [string]$date
	$build |Out-File -Append .\build\$version
	}

# Start build
$date = (get-date).toshortdatestring()
$week = (Get-ExtendedDate).GetWeekOfYear()
$month = (get-date).Month
$year = (get-date).Year
$packerfile = "windows_" + $version +  ".json"
$buildfile = "Win" + $version + "-" + $type.substring(0,1) + $year + "-" + $month + "V1B" + $buildnumber + ".vhd"
$logfile = $date + "-" + $version + "-" + "V1B" + $buildnumber + ".log"

Write-host -foregroundcolor White "Start building Windows image"
Write-host -foregroundcolor Yellow "Time       :" (get-date)
Write-host -foregroundcolor Yellow "Type       :" $type
Write-host -foregroundcolor Yellow "Version    :" $version
Write-host -foregroundcolor Yellow "Build      :" $buildnumber
Write-host -foregroundcolor Yellow "Template   :" $packerfile 
Write-host -foregroundcolor Yellow "Build file :" $buildfile

$validate = packer validate .\$packerfile

if ( $validate -eq "Template validated successfully."){
	Write-host -foregroundcolor Yellow "Validation : OK, ready to start build"
	}
else{
	Write-host -foregroundcolor Red "Validation : NOK, aborting build"
	Write-host -foregroundcolor Red "Error      :" $validate
	break
	}

Write-host -foregroundcolor Yellow "Start build....."
$log = ".\logging\$logfile"
	
packer build .\$packerfile	|out-file $log	
	
# Check outcome initial build, convert and upload image.
$result = gc $log
if($result[$result.count-2] -eq "==> Builds finished. The artifacts of successful builds are:"){
	Write-host -foregroundcolor Yellow "Initial build finished, converting to vhd...."
	$source = gci -Filter *.vmdk .\output-virtualbox-iso	
	$source.DirectoryName
	$source.Name
	$source.FullName	
	$target = ".\upload"
	C:\Apps\VirtualBox\VBoxManage.exe clonehd $source.FullName $target\$buildfile --format VHD
	get-date
	Write-host -foregroundcolor Yellow "VHD created, uploading to artifacts....."
	$source = "$target\$buildfile"
	$target = "dcs-test/win" + $version + "-" +$type + "/" + $buildfile
	$key = "D:\VMs\packer\DSC\sftp.ppk"
	#create upload script
	$dest = ("win$version" + "-$type").tolower()
	$upload = "lcd .\upload`ncd dsc-tst`ncd $dest`nput $buildfile`nclose"
	$script = (pwd).path + "\sftp\upload.scr"
	write-host "script: " $script
	[io.file]::WriteAllText($script,$upload)
	#Testing psftp.exe sftp_artifacts@artifacts.schubergphilis.com -i D:\packer\DSC\sftp\sftp.ppk -P 8822
	C:\Apps\PuTTY\psftp.exe sftp_artifacts@artifacts.schubergphilis.com -i $key -b $script -P 8822
	Write-host -foregroundcolor Yellow "VHD Uploaded, fire off Jenkins....."
	get-date
	}
elseif($result[$result.count-1] -eq "==> Builds finished but no artifacts were created."){
	Write-host -foregroundcolor Red "Initial build failed, no artifacts were created, aborting....."
	break
	}
else{
	Write-host -foregroundcolor Red "Initial build failed check $log why, aborting....."
	break
	}
