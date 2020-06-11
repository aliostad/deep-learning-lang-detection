#Powershell implementation of DomJoinPermissions.CMD, Original CMD by Paul Williams, msresource.net
#https://web.archive.org/web/20081006114434/http://www.msresource.net/articles/how_to_delegate_the_ability_to_add_a_domain_controller_to_the_domain_%28using_minimum_permissions%29.html
#written 11/9/2016 by Philip Bove
param(
    [Parameter(Mandatory = $true)]
    [string]$groupname,
    [Parameter(Mandatory = $true)]
    [string]$dn
    )
#permissions for all the naming contexts
$namingcontextsperms = @(':CA;"Add/Remove Replica In Domain";',':CA;"Replicating Directory Changes";',
    ':CA;"Manage Replication Topology";',':CA;"Replicating Directory Changes All";',
    ':CA;"Monitor Active Directory Replication";')
#permissions for CN=Sites,CN=Configuration
$sitesperms = @(':CC;"server; /I:S"',':CC;"nTDSDSA; /I:S"',':WD;;"nTDSDSA /I:S"',':CC;"nTDSConnection; /I:S"')
#Permissions for CN=Computers
$compcontperms = @(':WP;"cn;computer /I:S"',':WP;"name;computer /I:S"',':WP;"distinguishedName;computer /I:S"',':WP;"servicePrincipalName;computer /I:S"',
    ':WP;"serverReference;computer /I:S"',':WP;"userAccountControl;computer /I:S"',':DC;"computer;"')
#get all namingcontexts
$namingcontexts = Get-ADRootDSE 
$namingcontexts = $namingcontexts.namingContexts 
#fucntion to run commands and check for dsacls failures
function Run-Command{
    param([string]$cmd)
     $out = Invoke-Expression $cmd
    if($out -like "*The command failed to complete successfully*"){
        Write-Host $out
        exit
    }
    Write-Host $cmd
    Write-Host "Success!"
}
#give writes for all naming contexts
Write-Host "Configuring replication extended rights..."
#give permissions to all naming contexts
foreach($context in $namingcontexts){
    foreach($perm in $namingcontextsperms){
        $cmd  = -join('dsacls ',$context,' /G ',$groupname,$perm)
        Run-Command -cmd $cmd
   
    }

}
#configure rights on sites container
Write-Host "Configuring permissions on the sites container..."
$cmd = -join('dsacls ','"CN=Sites, CN=Configuration, ',$dn,'" /G ', $groupname)
foreach($perm in $sitesperms){
    $newcmd = -join($cmd,$perm)
    Run-Command -cmd $newcmd
}
#give rights on computer container (Change if you have another default container for computers joining domain)
Write-Host "Configuring permissions on the source (computers or staging, etc.) container..."
$cmd = -join('dsacls ','"CN=Computers,',$dn,'" /G ', $groupname)
foreach($perm in $compcontperms){
    $newcmd = -join($cmd,$perm)
    Run-Command -cmd $newcmd
}
#give rights to domaincontrollers ou
Write-Host "Configuring permissions on the domain controllers OU..."
$cmd = -join('dsacls ','"OU=Domain Controllers,',$dn,'" /G ',$groupname,':CC;"computer";')
Run-Command -cmd $cmd
#give write privilaged for nc replica locations in CN=Partitions, CN=Configuration
Write-Host "Granting WP for the msDS-NC-Replica-Locations attribute of the discoverer partition..."
$cmd =  -join('dsacls ','"CN=Partitions, CN=Configuration,',$dn,'" /G ',$groupname,':WP;"msDS-NC-Replica-Locations";')
Run-Command -cmd $cmd
Write-Host "Script completed!"