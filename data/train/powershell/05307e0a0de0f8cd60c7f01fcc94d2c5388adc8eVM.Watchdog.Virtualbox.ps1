# if you need to find out your uuid, do 'VboxManage list vms'
$VboxAppUuid = 'bfddb2b1-8199-4285-88ef-357abee3fe32'
$pathToVboxApp = 'C:/Users/RDP/VirtualBox VMs/Ubuntu Server Misc'
$defaultThreshold = 2 # number of fails before the script assumes the server is dead
$sleepStartup = 120 # amount of time to wait before watching the VM
$timeBetweenConnChecks = 10 # how frequent should the script check for server's life
$serverIP = '192.168.56.2' # the server's ip. I recommend this to be the host-only IP.
$VboxManage = 'C:/Program Files/Oracle/VirtualBox/VBoxManage.exe' # path to your VBoxManage

$threshold = $defaultThreshold

function fStartVm ([string]$fUuid, $fPathToVboxApp)
{
	& $VBoxManage startvm $fUuid --type headless
	Start-Sleep 5
	$fPathToLog = $fPathToVboxApp + '/Logs/Vbox.log'
	$fPidStore_t01 = Select-String $fPathToLog -pattern "process ID: " | %{$_ -split "Process ID: "}
	$fPidStore = $fPidStore_t01[1]
	return $fPidStore
}

function fRandomDots
{
	$fRandVal = Get-Random -minimum 0 -maximum 100
	if ($fRandVal -ge 51) {$fDots = '.....'}
	else {$fDots = '..'}
	return $fDots
}

Write-Host 'Starting up VboxApp Vm!'
$pidVboxAppVm = fStartVm $VboxAppUuid $pathToVboxApp
Start-Sleep $sleepStartup
Write-Host 'Startup done!'

while($True) {
	if (Test-Connection $serverIP -quiet){
		Start-Sleep $timeBetweenConnChecks
		$threshold = $defaultThreshold
		Write-Host "Connection OK$(fRandomDots)!"
	}
	else {$threshold-- ; Write-Host "Connection NOT OK$(fRandomDots)!"}
	if ($threshold -le 0) {
		Write-Host 'Terminating' + $(fRandomDots)
		& $VboxManage controlvm $VboxAppUuid poweroff
		#Stop-Process -name VboxHeadless -Force
        #Stop-Process -id $pidVboxAppVm -Force
		$threshold = $defaultThreshold
		Start-Sleep 5
		Write-Host 'Starting up VboxApp Vm!'
		$pidVboxAppVm = fStartVm $VboxAppUuid $pathToVboxApp
		Write-Host 'Restarting VM'$(fRandomDots)
		Start-Sleep $sleepStartup
		Write-Host 'Startup done!'
	}
}
