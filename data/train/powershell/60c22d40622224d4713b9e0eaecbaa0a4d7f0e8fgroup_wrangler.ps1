Import-Module -Force 'C:\cron\creds.psm1';
$ErrorActionPreference = "Stop";

Function Log {
   Param ([string]$logstring)
   $output = $("{0} ({1} - {2}): {3}" -f $(Get-Date), $(GCI $MyInvocation.PSCommandPath | Select -Expand Name), $pid, $logstring);
   Write-Host $output;
   Add-content "C:\cron\group_wrangler.log" -value $output;
}

# download distribution group list from Exchange Online
$ugrps = Invoke-command -session $session -Command { Get-UnifiedGroup -ResultSize unlimited };

Log $("Processing {0} unified groups" -f $ugrps.Length);

try {    
    # fetch all the shadow groups from the local AD
    $localgroups = Get-ADGroup -Filter * -SearchBase $unified_group_ou;

    # Remove groups missing online
    #if ($ugrps.Length -gt 100) {
    #    $dead_groups = compare-object -Property Name $localgroups $ugrps | where sideindicator -like '<=' | foreach { Get-ADGroup -Filter "Name -like `"$($_.Name)`"" -SearchBase $unified_group_ou };
    #    Log $("Removing missing unified groups: {0}" -f $($dead_groups -join ' | '));
    #    $dead_groups | Remove-ADGroup -Confirm:$false;
    #}
    
    # create/update the rest of the shadow groups to match Exchange Online
    ForEach ($ugrp in $ugrps) {
        $group = $localgroups | where Name -like $ugrp.Name;
        if (-not $group) { 
            Log $("Creating new unified group: {0}" -f $ugrp.Name);
            $group = New-ADGroup -GroupScope Universal -Path $unified_group_ou -Name $ugrp.Name -DisplayName $ugrp.DisplayName;
            Continue; # skip trying to populate freshly created group, give it some time to replicate
        }
        $lmembers = Get-ADGroupMember $group;
        if (-not $lmembers) { $lmembers = @() };
        $members = $ugrp | Invoke-command -session $session -Command { get-unifiedgrouplinks -linktype Members} | foreach { if($_.PrimarySMTPAddress){ Get-ADUser -Filter "EmailAddress -like `"$($_.PrimarySMTPAddress)`"" }}
        if (-not $members) { $members = @() };
        # Update memberships
        $diff = Compare-Object $lmembers $members;
        $toadd = $diff | where sideindicator -like '=>' | select -ExpandProperty inputobject;
        if ($toadd) { 
            Log $("Adding members to group {0}: {1}" -f $group.name, $($toadd -join ' | '));
            Add-ADGroupMember $group -Members $toadd -Confirm:$false; 
        }
        $todel = $diff | where sideindicator -like '<=' | select -ExpandProperty inputobject;
        if ($todel) { 
            Log $("Removing members from group {0}: {1}" -f $group.name, $($todel -join ' | '));
            Remove-ADGroupMember $group -Members $todel -Confirm:$false; 
        }
    }
     
} catch [System.Exception] {
    Log "ERROR: Exception caught, skipping rest of UnifiedGroup";
    Log $($_ | convertto-json);
}




try {
    # filter the Exchange Online groups list for groups that are "In cloud", and
    # don't include the above org-derived groups (i.e. Alias doesn't have db- prefix)
    $msolgroups = Invoke-command -session $session -Command { Get-DistributionGroup -ResultSize unlimited } | where isdirsynced -eq $false | where Alias -notlike db-*;
    Log $("Syncing {0} MailSecurity groups" -f $msolgroups.length);
    
    # fetch all the shadow groups from the local AD
    $localgroups = Get-DistributionGroup -OrganizationalUnit $mail_security_ou -ResultSize Unlimited;
    
    # Define user object attributes that we care about.
    #$adprops = @("DisplayName", "EmailAddress", "UserPrincipalName", "Modified");
    
    # Read the user list from AD.
    #$adusers = Get-ADUser -server $adserver -Filter * -Properties $adprops;

    # delete any shadow groups where the original is no longer online
    # WARNING: uncomment below line for occasional purges only! sometimes Office 365 will 
    # screw up and return only a fraction of the full DistributionGroup list without warning, 
    # meaning that hundreds of groups will be clobbered then get recreated 10 minutes later. 
    # which would be fine, except that all your object ACLs point to the SID of the dead group.
    #$localgroups | select @{name='exists';expression={$msolgroups | where ExternalDirectoryObjectId -like $_.CustomAttribute1}}, Identity | where exists -eq $null | Remove-DistributionGroup -BypassSecurityGroupManagerCheck -Confirm:$false;
    
    # create/update the rest of the shadow groups to match Exchange Online
    ForEach ($msolgroup in $msolgroups) {
        $group = $localgroups | where CustomAttribute1 -like $msolgroup.ExternalDirectoryObjectId;
        $name = $msolgroup.Alias.replace("`r", "").replace("`n", " ").TrimEnd();
        if (-not $group) { 
            try {
                Log $("Creating new MailSecurity group: {0}" -f $name);
                $group = New-DistributionGroup -OrganizationalUnit $mail_security_ou -PrimarySmtpAddress $msolgroup.PrimarySmtpAddress -Name $name -Type Security;
                sleep 10;
            } catch [System.Exception] {
                Log $("Failed! Possibly the group has a duplicate?")
                Log $($_ | convertto-json);
                continue;
            }
        }
        Write-Host $group;
        Set-DistributionGroup $group -Name $msolgroup.Alias -CustomAttribute1 $msolgroup.ExternalDirectoryObjectId -Alias $msolgroup.Alias -DisplayName $msolgroup.DisplayName -PrimarySmtpAddress $msolgroup.PrimarySmtpAddress;
        

        $lmembers = Get-ADGroupMember $group.DistinguishedName;
        if (-not $lmembers) { $lmembers = @() };
        $members = Get-MsolGroupMember -All -GroupObjectId $msolgroup.ExternalDirectoryObjectId | foreach { if($_.EmailAddress){ Get-ADUser -Filter "EmailAddress -like `"$($_.EmailAddress)`"" }}
        if (-not $members) { $members = @() };
        # Update memberships
        $diff = Compare-Object $lmembers $members;
        $toadd = $diff | where sideindicator -like '=>' | select -ExpandProperty inputobject;
        if ($toadd) { 
            Log $("Adding members to group {0}: {1}" -f $group.name, $($toadd -join ' | '));
            Add-ADGroupMember $group.DistinguishedName -Members $toadd -Confirm:$false; 
        }
        $todel = $diff | where sideindicator -like '<=' | select -ExpandProperty inputobject;
        if ($todel) { 
            Log $("Removing members from group {0}: {1}" -f $group.name, $($todel -join ' | '));
            #Remove-ADGroupMember $group.DistinguishedName -Members $todel -Confirm:$false; 
        }
        
        
        # we need to ensure an admin group is added as an owner the O365 group object. 
        # why? because without this, even God Mode Exchange admins can't use ECP to manage the group owners! 
        # instead they have to open PowerShell and do the exact same thing... which will fail until 
        # you add -BypassSecurityGroupManagerCheck, which all of a sudden makes it totally okay! 
        #$gsmtp = $msolgroup.PrimarySmtpAddress;
        #Invoke-command -session $session -ScriptBlock $([ScriptBlock]::Create("Set-DistributionGroup -Identity $gsmtp -ManagedBy @{Add=`"$admin_msolgroup`"} -BypassSecurityGroupManagerCheck"));
        
    }



} catch [System.Exception] {
    Log "ERROR: Exception caught, skipping rest of MailSecurity";
    Log $($_ | convertto-json);
}

Log "Finished";

# cleanup
Get-PSSession | Remove-PSSession;
