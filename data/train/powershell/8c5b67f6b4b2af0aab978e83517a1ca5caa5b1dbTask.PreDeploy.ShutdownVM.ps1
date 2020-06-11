$toolPath = [System.Environment]::GetEnvironmentVariable("VM_TOOLPATH", "Machine")
Write-Host $toolPath

function PerformTask()
{
    Write-Host "Checking Pre Deploy"

    #type - gui|headless
    $secureToolCmd = "& '$($toolPath)VBoxManage.exe'"
    $secureToolArgs = "list vms"
	
    Write-Host "$secureToolCmd $secureToolArgs"
	
    Invoke-Expression "$secureToolCmd $secureToolArgs" | Write-Host
	
	$secureToolCmd = "& '$($toolPath)VBoxManage.exe'"
    $secureToolArgs = "controlvm $VMNAME acpipowerbutton"
	
	Write-Host "$secureToolCmd $secureToolArgs"
	
    Invoke-Expression "$secureToolCmd $secureToolArgs" | Write-Host
}
