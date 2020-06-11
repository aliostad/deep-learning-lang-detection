$vmm_dir="c:\Program Files\Oracle\VirtualBox";
$vmm_abspath = $vmm_dir + "\VBoxManage.exe";

if(Test-Path "$vmm_abspath"){
    & ..\ps_update_path_immediately\env-path-permanently.ps1 "$vmm_dir"
}

if($vmm_abspath)
{
    $dd = [Environment]::GetEnvironmentVariable("DATA_DRIVE","User");
    if($dd)
    {
	Write-Host "$dd";
	$command='& "$vmm_abspath" setproperty machinefolder $dd\vbox';
	& $command
    }

    $dd = [Environment]::GetEnvironmentVariable("DATA_DRIVE","Machine");
    if($dd)
    {
	Write-Host "$dd";
	$command='& "$vmm_abspath" setproperty machinefolder $dd\vbox';
	iex $command;
    }
}