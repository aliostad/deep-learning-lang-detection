Param(
    [string]$vmName,
    [int]$startPort,
    [int]$endPort
)

$vboxManageLocation = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

$hasValidParams = $startPort -And $endPort -And $vmName

If (-Not $hasValidParams) {
    "Missing Params!"
    "Usage: ./Expose-Guest-Ports.ps1 -startPort <start port> -endPort <end port> -vmName <target guest machine name>"
    exit 1
}

$startPort..$endPort |
    ForEach {
        "Exposing port $_..."
        & $vboxManageLocation modifyvm $vmName --natpf1 `"tcp-port-$_`,tcp`,`,$_`,`,$_`"
        & $vboxManageLocation modifyvm $vmName --natpf1 `"udp-port-$_`,udp`,`,$_`,`,$_`"
        
    }

"Done!"
