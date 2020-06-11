[cmdletbinding()]
Param (
    $vmhost,
    [switch]$whatif = $true,
    $vmotionlimit = 5,
    $vcenter = "vcenter"
)

function WriteHost($target="Startup",$message,$color="White") { 
    Write-Host "$($target): $($message)" -ForegroundColor $color; if($color -eq "Red") { Exit } 
}

function vMotionVM($vms,$targethost) {
    $targetvm = $vms | Get-Random
    WriteHost -target $vmhost -message "Migrating $($targetvm.name) to $($targethost.name)"
    if($whatif -eq $false) { $targetvm | Move-VM -Destination $targethost -RunAsync | Out-Null }
    return $vms | ?{$_ -ne $targetvm}
}

$vms = @()
$othervmhosts = @()

try { Connect-VIServer $vcenter -ErrorAction Stop | Out-Null }
catch { WriteHost -message "Failed to connect to $vcenter" -color Red }

try { WriteHost -message "Getting VMHost data"; $targetvmhost = Get-VMHost $vmhost -ErrorAction Stop }
catch { WriteHost -message "Failed to get VMHost data" -color Red }

try { WriteHost -message "Getting VMs on $($targetvmhost.Name)"; $vms = $targetvmhost | Get-VM -ErrorAction Stop | sort Name  }
catch { WriteHost -message "Failed to get VMs on $($targetvmhost.Name)" -color Red }

try { WriteHost -message "Getting VM hosts in $($targetvmhost.Parent)"; $othervmhosts = Get-Cluster $targetvmhost.Parent -ErrorAction Stop | Get-VMHost -ErrorAction Stop | ?{$_ -ne $targetvmhost -and $_.ConnectionState -ne "Maintenance"} }
catch { WriteHost -message "Failed to get other VM hosts in $($targetvmhost.Parent)" -color Red }

$i = 0
while($vms.count -gt 0) {
    $tasks = Get-Task -Status Running | ?{$_.name -like "*RelocateVM_Task*"}
    if($tasks.count -lt $vmotionlimit) {
        if($othervmhosts[$i]) {
            $vms = vMotionVM $vms $othervmhosts[$i]
            $i++
        } else {
            $i = 0
        }
    } else {
        Write-Verbose "vMotions are limited to $vmotionlimit"
        Start-Sleep -Seconds 15
    }
}

Set-VMHost -State Maintenance -VMHost $targetvmhost