

$hosts = Get-VMHost
$vms = Get-Datacenter | Get-VMhost -Name "145.108.224.15"| Get-Vm |Where {$_.PowerState -eq “PoweredOn“}

$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
Get-Datacenter | Get-VMhost -Name "145.108.224.15" | Get-Stat -Stat power.power.AVERAGE -MaxSamples 45 -realtime | Export-CSV Z:\GreenLab\Team1\Hosttests\OlioDB\Load\HostPower_$CurrentDate.csv
Get-Datacenter | Get-VMhost -Name "145.108.224.15" | Get-Stat -Stat cpu.usage.AVERAGE -MaxSamples 45 -realtime | Export-CSV Z:\GreenLab\Team1\Hosttests\OlioDB\Load\HostCPU_$CurrentDate.csv
Get-Datacenter | Get-VMhost -Name "145.108.224.15" | Get-Stat -Stat mem.usage.AVERAGE -MaxSamples 45 -realtime | Export-CSV Z:\GreenLab\Team1\Hosttests\OlioDB\Load\HostMEM_$CurrentDate.csv
Get-Datacenter | Get-VMhost -Name "145.108.224.15" | Get-Stat -Stat disk.read.AVERAGE -MaxSamples 45 -realtime | Export-CSV Z:\GreenLab\Team1\Hosttests\OlioDB\Load\HostREAD_$CurrentDate.csv
Get-Datacenter | Get-VMhost -Name "145.108.224.15" | Get-Stat -Stat disk.write.AVERAGE -MaxSamples 45 -realtime | Export-CSV Z:\GreenLab\Team1\Hosttests\OlioDB\Load\HostWRITE_$CurrentDate.csv



foreach($vm in $vms){
  
	$vmstat = "" | Select VmName
        $vmstat.VmName = $vm.name
	md -Path Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName
  	Get-Stat -Entity ($vm) -MaxSamples 45 -realtime -Stat cpu.usage.average | Export-CSV Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName\CPU$CurrentDate.csv
   	Get-Stat -Entity ($vm) -MaxSamples 45 -realtime -Stat mem.usage.average | Export-CSV Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName\MEM$CurrentDate.csv
	Get-Stat -Entity ($vm) -MaxSamples 45 -realtime -Stat power.power.average | Export-CSV Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName\POWER$CurrentDate.csv
	Get-Stat -Entity ($vm) -MaxSamples 45 -realtime -Stat disk.read.average | Export-CSV Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName\ReadsVM$CurrentDate.csv
  	Get-Stat -Entity ($vm) -MaxSamples 45 -realtime -Stat disk.write.average | Export-CSV Z:\GreenLab\Team1\VMtests\OlioDB\Load\$CurrentDate\$vmstat.VmName\Writes$CurrentDate.csv
  
}

