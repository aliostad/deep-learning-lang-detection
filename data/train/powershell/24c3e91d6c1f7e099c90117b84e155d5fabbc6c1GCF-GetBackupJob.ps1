#######################################################################################
# Copyright 2013 VCE All Rights Reserved
#
# You may freely use and redistribute this script as long as this 
# copyright notice remains intact 
#
#
# DISCLAIMER. THIS SCRIPT IS PROVIDED TO YOU "AS IS" WITHOUT WARRANTIES OR CONDITIONS 
# OF ANY KIND, WHETHER ORAL OR WRITTEN, EXPRESS OR IMPLIED. THE AUTHOR SPECIFICALLY 
# DISCLAIMS ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY 
# QUALITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE. 
#
#######################################################################################

. .\config\environment.ps1

function CreateRow ($vm,$gname) {
	$row = New-Object PsObject -Property @{
		'VM' = $vm;
		'GNAME' = $gname;
	}
	return $row
}

function StripDomain($s) {
	return ($s -replace "$($acct.domain)/", '')
}

# Load backup configuration
[xml]$cfg = Get-Content $BACKUP_CFG
$acct = $cfg.'backup-config'.account.avamar

$cred = New-Object System.Management.Automation.PSCredential($acct.user, (Get-Content $AVM_PASS | ConvertTo-SecureString))
$p = $cred.GetNetworkCredential().Password

# Subset of groups for testing

$vmlist = @()
$groups = $cfg.'backup-config'.groups.group | %{ $_.Name}
# $groups = @('IAAS01','IAAS07')
foreach ($gname in $groups) {
	$group_show_clients = "mccli group show-client-members --domain=$($acct.domain) --name=$($gname) --xml"
	INFO ("Fetching Avamar goup '$gname'")

	.\plink.exe "$($acct.user)@$($acct.hostname)" -ssh -pw $p $group_show_clients > $TMP_MCCLI
	[xml]$gjob = Get-Content $TMP_MCCLI
	
	if(0 -eq  [int]$gjob.CLIOutput.Results.ReturnCode) {
		$rows = $gjob.CLIOutput.Data.Row
		foreach ($r in $rows) {
			if($r.Client -eq $null) {continue}
			$vmlist += (CreateRow (StripDomain $r.Client) (StripDomain $r.Group))
		}
	} else {
		ERROR("Failed to query VM list for group '{0}'" -f $gname)
	}
}

$vmlist | Export-Csv -NoTypeInformation $BACKUP_JOB


