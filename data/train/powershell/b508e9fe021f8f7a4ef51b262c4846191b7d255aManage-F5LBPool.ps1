# Exit codes
# 
# 900 - Failed to connect to the LTM Host Virtual IP
# 901 - Failed to find the LB Pool in the LTM Partition
# 902 - Failed to add the LB Pool Member from the LB Pool
# 903 - Failed to remove the LB Pool Member from the LB Pool

$F5_Password	= $ENV:F5_ADMIN_PASSWORD
$F5_User		= $ENV:F5_ADMIN_USERNAME
$F5_Clusters	= $ENV:F5_CLUSTERS
$F5_Pool_Name	= $ENV:F5_POOL_NAME
$F5_Pool_Ports	= $ENV:F5_POOL_PORT
$F5_Partition	= $ENV:F5_PARTITION
$Check_State	= $ENV:SHUTDOWN_STATE

if (!$F5_Partition) { $F5_Partition = "Common" }

Add-PSSnapIn iControlSnapIn

$F5_Secure_Password	= ConvertTo-SecureString $F5_Password -AsPlainText -Force
$F5_Credential		= New-Object System.Management.Automation.PSCredential $F5_User,$F5_Secure_Password

if ($F5_Clusters -match ",") { $F5_Clusters = $F5_Clusters.Split(",") }
else { $F5_Clusters = @($F5_Clusters) }

foreach ($F5_Cluster in $F5_Clusters) { 

	$initF5	= Initialize-F5.iControl -Hostname $F5_Cluster -PSCredential $F5_Credential

	if ($initF5) {
		$LocalIP	= Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/local-ipv4 -UseBasicParsing | Select -Expand Content

		$iControl	= Get-F5.iControl
		$F5_LB_Pool	= "/{0}/{1}" -f $F5_Partition,$F5_Pool_Name

		$iControl.ManagementPartition.set_active_partition($F5_Partition)
		$Pool_List = $iControl.LocalLBPool.get_list()

		if ($F5_Pool_Ports -match ",") { $F5_Ports = @($F5_Pool_Ports.split(",")) }
		else { $F5_Ports = @($F5_Pool_Ports) }
		
		
		if (($Pool_List -contains $F5_LB_Pool) -or ($Pool_List -match $F5_LB_Pool)) {
			$Members = Get-F5.LTMPoolMember -Pool $F5_LB_Pool | Select -Expand Address
			if (!$Check_State) { $State = rs_state --type=run } 
			else { $State = $Check_State }

			if ($State -match "shutting-down:terminate") {
				foreach ($F5_Port in $F5_Ports) { 
					$F5_Pool_Member = "{0}:{1}" -f $LocalIP,$F5_Port
					Remove-F5.LTMPoolMember -Pool $F5_LB_Pool -Member $F5_Pool_Member
					$iControl.LocalLBNodeAddress.delete_node_address("$LocalIP")
					if ($?) {
						Write-Host "MANAGE-F5_POOL:  Removed $F5_Pool_Member from /$F5_Cluster/$F5_Pool_Name."
					}
					else {
						Write-Host "MANAGE-F5_POOL:  Failed to remove $F5_Pool_Member from /$F5_Cluster/$F5_Pool_Name."
						Exit 903
					}
				}
			}
			else {
				if ($Members -contains $LocalIP) {
					Write-Host "MANAGE-F5_POOL:  $F5_Pool_Member is already joined to /$F5_Cluster/$F5_Pool_Name.  No work to do."
					Exit 0
				}
				foreach ($F5_Port in $F5_Ports) { 
					$F5_Pool_Member = "{0}:{1}" -f $LocalIP,$F5_Port
					$AddMember	= Add-F5.LTMPoolMember -Pool $F5_Pool_Name -Member $F5_Pool_Member
					if ($AddMember) { 
						Write-Host "MANAGE-F5_POOL:  $F5_Pool_Member was successfully added to /$F5_Cluster/$F5_Pool_Name."
					}
					else {
						Write-Host "MANAGE-F5_POOL:  $F5_Pool_Member was not added to /$F5_Cluster/$F5_Pool_Name."
						Exit 902
					}
				}
			}
		}
		else {
			Write-Host "MANAGE-F5_POOL:  Pool $F5_LB_Pool was not found in /$F5_Cluster/$F5_Partition"
			Exit 901
		}
	}
	else {
		Write-Host "MANAGE-F5_POOL:  Failed to initialize the connection with $F5_Cluster as $F5_User"
		Exit 900
	}
}