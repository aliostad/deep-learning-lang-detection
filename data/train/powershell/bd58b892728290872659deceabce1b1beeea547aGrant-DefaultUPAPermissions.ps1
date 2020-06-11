[CmdletBinding()]Param();

if ((Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin "Microsoft.SharePoint.PowerShell";
}

function GrantToClaim {
    param($claim);
    $proxy = Get-SPServiceApplicationProxy | ? { $_.DisplayName -eq "User Profile Service Application" }
    $upaSec = Get-SPProfileServiceApplicationSecurity -ProfileServiceApplicationProxy $proxy;
    Grant-SPObjectSecurity -Identity $upaSec -Principal $claim -Rights "Use Personal Features";
    Grant-SPObjectSecurity -Identity $upaSec -Principal $claim -Rights "Create Personal Site";
    Grant-SPObjectSecurity -Identity $upaSec -Principal $claim -Rights "Use Social Features";
    Set-SPProfileServiceApplicationSecurity -Identity $upaSec -ProfileServiceApplicationProxy $proxy -Confirm:$false;
}

try {
    # All Authenticated Users
    Write-Host -ForegroundColor Green "Granting rights to All Authenticated Users";
    $allUsers = New-SPClaimsPrincipal -Identity "c:0(.s|true" -IdentityType EncodedClaim;
    GrantToClaim -claim $allUsers;    
    #NT Authority\authenticated users
    Write-Host -ForegroundColor Green "Granting rights to NT Authority\authenticated users";
    $ntAuthUsers = New-SPClaimsPrincipal -Identity "c:0!.s|windows" -IdentityType EncodedClaim;
    GrantToClaim -claim $ntAuthUsers;

} catch {
    Write-Host -ForegroundColor Red $_.Exception;
    Write-Host -ForegroundColor Red "Make sure you have permissions to the UPA Manage Service Application Proxy";
}
