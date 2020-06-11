# Based on the original powershell source by robertvi at microsoft.com
#
# http://blogs.msdn.com/b/robertvi/archive/2010/10/07/a-powershell-script-which-balances-the-load-of-hyper-v-vms-across-all-cluster-nodes.aspx
# 
# v1.0 
#
#
#

Import-Module FailoverClusters  # load cluster cmdlet

$cluster = $args[0]

if ( $cluster -eq $null ) {
	write-host "Usage: balance_vm.ps1 clustername"
	exit 1
}

#ensure we run on one node only
$master = Get-ClusterGroup -cluster $cluster |  ?{ $_.Name -like "Cluster Group" }
$thishost = Get-WmiObject -class win32_computersystem

$master = $master.OwnerNode.Name.ToLower()
$thishost = $thishost.Name.ToLower()

Write-Host "Cluster Group owner:" $master "Script Host:" $thishost "<"

$balanced=0

do {
 
		$averageload=0
		$numberofnodes=0
		$maxload = 0
		$minload = 1000
		$maxloadedhost = 'undefined'
		$minloadedhost = 'undefined'

		# Get all nodes
		$nodes = get-clusternode -cluster $cluster

		foreach ($node in $nodes)
			{

				$Hostinfo = Get-WmiObject -class win32_computersystem -computername $node
				Write-Host "Host " $Hostinfo.Name
				$load = (@(gwmi -ns root\virtualization MSVM_Processor -computername $node).count / (@(gwmi Win32_Processor -computername $node) | measure -p NumberOfLogicalProcessors -sum).Sum)  
				Write-Host "Load " $load

				if ($load -ge $maxload) 
					{
						$maxload = $load
						$maxloadedhost = $node
				}

				if ($load -le $minload) 
					{
						$minload = $load
						$minloadedhost = $node
				}

 				$averageload += $load
				$numberofnodes += 1
 
			}

		$averageload /= $numberofnodes
		Write-Host "Average Load " $averageload
		Write-Host "Max Load " $maxload
		Write-Host "Min Load " $minload

		# 
		# Now if the maximum loaded host - minimum loaded host is still above average, push a VM from maximum to minimum.
		#


		#if (($maxload - $averageload) -gt $minload) #is maxload distance to average greater then minloads distance?
		if ( ( $maxload - $minload ) -ge 1 )
		   	{
				Write-Host "Push a VM from" $maxloadedhost "to " $minloadedhost

				#find a running VM on $maxloadedhost and move to $minloadedhost

				$VMGroups = Get-ClusterNode -cluster $cluster $maxloadedhost.Name | Get-ClusterGroup | ?{ $_ | Get-ClusterResource | ?{ $_.ResourceType -like "Virtual Machine" } }

                $listarandom = $VMGroups | get-random -count 5

                #write-host $listarandom

				$counter=0

				foreach ($vm in $listarandom)
					{

						if ($vm.State -eq 'Online')
							{	 
								Write-Host "VM Group to migrate" $vm.name
           

								# This is our best candidate. May still not possible to move when destination memory not sufficent. 
								# LiveMigration will determine this and abort the migrate.
								# if Quick Migration should be used: Move-ClusterGroup $vm -Node $minloadedhost

								$evtinfo = "Moving " + $vm + " to Node " + $minloadedhost + " Avg load " +$averageload + " maxload " + $maxload + " minload " + $minload
								$evt=new-object System.Diagnostics.EventLog("Application")
								$evt.Source="VM Balancer"
								$infoevent=[System.Diagnostics.EventLogEntryType]::Information
								$evt.WriteEntry($evtinfo,$infoevent,666)

								
										Move-ClusterVirtualMachineRole -cluster $cluster $vm -Node $minloadedhost 
                                        #Move-ClusterGroup $vm -Node $minloadedhost
                                        write-host "Valore di ritorn $ritorno"
										
                                        write-host -NonewLine "Waiting 60 seconds:"

                                           for ( $i=0; $i -lt 60; $i++) {
                                                start-sleep -s 1
                                                write-host -NoNewline "." -foregroundcolor "yellow"
                                           }
										$counter++
									    Write-Host "Counter: $counter"
							
									if ( $counter -eq 1 ) {
										break
									}
		  				} 
				}
			} else {
				Write-Host "No Balancing needed"
				$balanced=1
			} 
			
} until ($balanced -eq 1)
