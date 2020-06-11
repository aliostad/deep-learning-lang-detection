#Discover-vCenterResourcePools.ps1
#TODO:
# * vCenterName--check to see if we can resolve?
Param($sourceID,$managedEntityID,$vCenterName,$dcName,$dcUID,$clusterName,$clusterUID)
$fail = $false
$scriptName = "Discover-vCenterResourcePools.ps1 b9 - " + $clusterName
$opsmgrAPI = New-Object -comObject 'MOM.ScriptAPI'

#parse args
$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script Starting.")
If($sourceID -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 0 (sourceID) was null.")
	}
ElseIf($managedEntityID -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 1 (managedEntityID) was null.")
	}
ElseIf($vCenterName -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 2 (vCenterName) was null.")
	}
ElseIf($dcName -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 3 (dcName) was null.")
	}
ElseIf($dcUID -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 4 (dcUID) was null.")
	}
ElseIf($dcUID -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 5 (clusterName) was null.")
	}
ElseIf($dcUID -eq $null)
	{
		$fail = $true
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,"Script didn't complete argument check; argument 6 (clusterUID) was null.")
	}


$msg = "Script passed the following parameters: sourceID|""" + $sourceID + """, managedEntityID|""" + $managedEntityID + """, vCenterName|""" + $vCenterName + """, dcName|""" + $dcName + """, dcUID|""" + $dcUID + """, clusterName|""" + $clustername + """, clusterUID|""" + $clusterUID + """."
$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)

#Load Snap-Ins
#references: http://mcpmag.com/articles/2009/05/19/snapins-on-standby.aspx
If($fail -eq $false)
	{
		$snapin = "VMware.VimAutomation.Core"
		$msg = "Script is attempting to load snap-in: """ + $snapin + """."
		$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)
		$snapinTest = $null
		$snapinTest = Get-PSSnapin $snapin -registered -ea "silentlycontinue"
		If($snapinTest -ne $null)
			{
				$msg = "The required snap-in is installed on this system: """ + $snapin + """. Adding the snap-in."
				$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)
				$snapinTest = $null
				$snapinTest = Get-PSSnapin $snapin -ea silentlycontinue
				If($snapinTest -eq $null)
					{$blnAdded = Add-PSSnapin $snapin}
				Else
					{}
			}
		Else
			{
				$fail = $true
				$msg = "Required Snap-In is not installed on this system: """ + $snapin + """."
				$opsmgrAPI.LogScriptEvent($scriptName,0,2,$msg)
			}
		
		If($fail -eq $false)
			{
				$snapinTest = $null
				$snapinTest = Get-PSSnapin $snapin
				if($snapinTest -eq $null)
					{
						$fail = $true
						$msg = "Script didn't complete loading snap-ins; could not add the snapin: """ + $snapin + """."
						$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)
					}
			}
	}

#connect to vCenter
If($fail -eq $false)
	{
		$wprefTmp = $warningPreference
		$warningPreference = "SilentlyContinue"
		Connect-VIServer -server $vCenterName | out-null
		$warningPreference = $wprefTmp
		$objDC = Get-Datacenter $dcName
		If($objDC -eq $null)
			{
				$fail = $true
				$msg = "Could not connect to the vcenter server: """ + $vCenterName + """."
				$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)
			}
		Else
			{
				$msg = "Connected to the vcenter server: """ + $vCenterName + """."
				$opsmgrAPI.LogScriptEvent($scriptName,0,0,$msg)
				
				#create the discovery data object
				$discoveryData = $null
				$discoveryData = $opsmgrAPI.CreateDiscoveryData(0,$sourceID,$managedEntityID)
				If($discoveryData -eq $null)
					{$opsmgrAPI.LogScriptEvent($scriptName,1,1,"Could not create discoveryData.")}
				Else
					{}
				
				$objRPs = $null
				$objRPs = Get-ResourcePool -location $clusterName
				If($objRPs -eq $null)
					{
						$msg = "No resource pools were found in cluster """ + $clusterName + """ in datacenter """ + $dcName + """."
						$opsmgrAPI.LogScriptEvent($scriptName,1,1,$msg)
						$fail = $true
					}
				ElseIf($objRPs -is [array])
					{$arrRPs = $objRPs}
				Else
					{
						$arrRPs = @()
						$arrRPs += $objRPs
					}
				
				If($fail -eq $false)
					{
#						#Prepare the relationship
#						$objClusterClass = $null
#						$objClusterClass = $discoveryData.CreateClassInstance("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter.ESXCluster']$")
#						If($objClusterClass -eq $null)
#							{$opsmgrAPI.LogScriptEvent($scriptName,1,1,"Could not create a class instance for this relationship discovery.")}
#						Else
#							{
#								$objClusterClass.AddProperty("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter']/Uid$",$dcUID)
#								$objClusterClass.AddProperty("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter.ESXCluster']/Uid$",$clusterUID)
#								$objClusterClass.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $vCenterName)
#							}
						
						
						$arrRPNames = @()
						Foreach($RP in $arrRPs)
							{
								#gather properties
								$arrPropertiesToDiscover = @()
								$arrPropertiesToDiscover += "CpuExpandableReservation"
								$arrPropertiesToDiscover += "CpuLimitMHz"
								$arrPropertiesToDiscover += "CpuReservationMHz"
								$arrPropertiesToDiscover += "CpuSharesLevel"
								$arrPropertiesToDiscover += "Id"
								$arrPropertiesToDiscover += "MemExpandableReservation"
								$arrPropertiesToDiscover += "MemLimitMB"
								$arrPropertiesToDiscover += "MemReservationMB"
								$arrPropertiesToDiscover += "MemSharesLevel"
								$arrPropertiesToDiscover += "Name"
								$arrPropertiesToDiscover += "NumCpuShares"
								$arrPropertiesToDiscover += "NumMemShares"
								$arrPropertiesToDiscover += "Parent"
								$arrPropertiesToDiscover += "ParentId"
								$arrPropertiesToDiscover += "Uid"
								
								#prepare the discovery class instance
								$objClass = $null
								$objClass = $discoveryData.CreateClassInstance("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter.ESXCluster.ResourcePool']$")
								If($objClass -eq $null)
									{$opsmgrAPI.LogScriptEvent($scriptName,1,1,"Could not create a class instance for this discovery.")}
								
								#gather stats
								$RPName = $null
								$RPName = $RP.Name
								If($RPName -ne $null)
									{$arrRPNames += $RPName}
								Else
									{
										#read properties from pshell object and add to discovery data
										Foreach($property in $arrPropertiesToDiscover)
											{
												$propValue = $null
												$propValue = $RP.$property
												If($propValue -ne $null)
													{
														$strAddProp = "$" + "MPElement[Name='" + "JPPacks.VMWare.vCenter.vCenterServer.Datacenter.ESXCluster.ResourcePool" + "']/" + $property + "$"
														$objClass.AddProperty($strAddProp,$propValue)
													}
												Else
													{
														$msg = "Could not read property value of """ + $property + """."
														$opsmgrAPI.LogScriptEvent($scriptName,3,1,$msg)
													}
											}
										
										#Add the parent's data to the class (not sure why this is required, but it is).
										$objClass.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$clusterName)
										$objClass.AddProperty("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter']/Uid$",$dcUID)
										$objClass.AddProperty("$MPElement[Name='JPPacks.VMWare.vCenter.vCenterServer.Datacenter.ESXCluster']/Uid$",$clusterUID)
										$objClass.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $vCenterName)
										$discoveryData.AddInstance($objClass)
										
#										#Add the Relationship
#										$objRelationship = $null
#										$objRelationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='JPPacks.VMWare.vCenter.Relationships.ClusterHostsResourcePool']$")
#										If($objRelationship -eq $null)
#											{$opsmgrAPI.LogScriptEvent($scriptName,1,1,"Could not create the relationship class.")}
#										Else
#											{
#												$objRelationship.Source = $objClusterClass
#												$objRelationship.Target = $objClass
#												$discoveryData.AddInstance($objRelationship)
#											}
									}
							}
						
						$RPsDiscovered = $arrRPs.Count
						[string]$strRPNames = $arrRPNames
						$msg = "Script finished; discovered " + $RPsDiscovered + " resource pools with names: """ + $strRPNames + """ located in the cluster """ + $clusterName + """, located in the datacenter """ + $dcName + """."
						$opsmgrAPI.LogScriptEvent($scriptName,1,0,$msg)
						#$opsmgrAPI.Return($discoveryData)
						$discoveryData
					}
			}
	}
