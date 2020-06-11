#AD Audit and remediation tool
#JP Senior 29.11.2013

#Usage: Just run the script.  It reports only -- it has commands on there to easily manage accounts, and we can add other features (DisableAccount(username)) for example.

#-JP

#Returns a randomized, 32-character password.
Import-Module ActiveDirectory

Function RandPW 
{
  $PWDChars = [Char[]]"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+0-"
  return ($PWDChars | Get-Random -Count 32) -join ""
}

#Randomizes a password securely.
Function ChangePW($username)
{
    Set-ADAccountPassword "$username" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $(RANDPW) -Force)
}

Function DisableUser($username)
{
    Disable-ADAccount -identity $username
}
#Removes all groups from a user.
Function RemoveGroups($username)
{
  $objUser = get-aduser -identity $username
  $groups = get-adgroup -ldapfilter "(member=$objUser)"
  foreach($group in $groups) {
    if ($group.Name -ne 'NONUser_ServiceAccounts') {
      #Write-Host $group
      Remove-ADGroupMember -Identity $group.Name -member $objUser -Confirm:$False
    }
  }
}

#Changes primary group membership to 'NONUSER_ServiceAccounts')
Function ChangePrimaryGroup($username)
{

  $objUser = Get-adUser -identity $username
  $objGroup = Get-ADGroup -identity 'NONUSER_ServiceAccounts'
  Add-ADGroupMember $objGroup -members $objUser
  $sid = $objgroup.sid.value.substring($objGroup.sid.Value.LastIndexOf(("-")) + 1)
  $objUser | Set-ADObject -replace @{primaryGroupID="$sid"}
}

Function Set-UserAccountControlValueTable 
{ 
    # see http://support.microsoft.com/kb/305144/en-us 
     
    $userAccountControlHashTable = New-Object HashTable 
    $userAccountControlHashTable.Add("SCRIPT",1) 
    $userAccountControlHashTable.Add("ACCOUNTDISABLE",2) 
    $userAccountControlHashTable.Add("HOMEDIR_REQUIRED",8)  
    $userAccountControlHashTable.Add("LOCKOUT",16) 
    $userAccountControlHashTable.Add("PASSWD_NOTREQD",32) 
    $userAccountControlHashTable.Add("ENCRYPTED_TEXT_PWD_ALLOWED",128) 
    $userAccountControlHashTable.Add("TEMP_DUPLICATE_ACCOUNT",256) 
    $userAccountControlHashTable.Add("NORMAL_ACCOUNT",512) 
    $userAccountControlHashTable.Add("INTERDOMAIN_TRUST_ACCOUNT",2048) 
    $userAccountControlHashTable.Add("WORKSTATION_TRUST_ACCOUNT",4096) 
    $userAccountControlHashTable.Add("SERVER_TRUST_ACCOUNT",8192) 
    $userAccountControlHashTable.Add("DONT_EXPIRE_PASSWORD",65536)  
    $userAccountControlHashTable.Add("MNS_LOGON_ACCOUNT",131072) 
    $userAccountControlHashTable.Add("SMARTCARD_REQUIRED",262144) 
    $userAccountControlHashTable.Add("TRUSTED_FOR_DELEGATION",524288)  
    $userAccountControlHashTable.Add("NOT_DELEGATED",1048576) 
    $userAccountControlHashTable.Add("USE_DES_KEY_ONLY",2097152)  
    $userAccountControlHashTable.Add("DONT_REQ_PREAUTH",4194304)  
    $userAccountControlHashTable.Add("PASSWORD_EXPIRED",8388608)  
    $userAccountControlHashTable.Add("TRUSTED_TO_AUTH_FOR_DELEGATION",16777216)  
    $userAccountControlHashTable.Add("PARTIAL_SECRETS_ACCOUNT",67108864) 
 
    $userAccountControlHashTable = $userAccountControlHashTable.GetEnumerator() | Sort-Object -Property Value  
    return $userAccountControlHashTable 
} 
 
Function Get-UserAccountControlFlags($userInput) 
{     
        Set-UserAccountControlValueTable | foreach { 
        $binaryAnd = $_.value -band $userInput 
        if ($binaryAnd -ne "0") { write $_ } 
    } 
} 

#Converts a Windows timestamp into human-readable DateTime
Function GetTime($time) {
    $dt =[DateTime]::FromFileTime($time)
    return $dt
}

[System.Collections.ArrayList]$userlist = New-Object System.Collections.ArrayList($null)

$userlist = @()

$DCs = Get-ADDomainController -Filter {Name -like "*"}
$progresstotal = $DCs.count
$progresscounter = 0
foreach($dc in $DCs)
{ 
    $progresspercent = ($progresscounter / $progresstotal)*100
        
    $hostname = $dc.HostName
    Write-Progress -activity "Querying domain controllers" -status "$progresspercent% ($progresscounter / $progresstotal) - $hostname" -PercentComplete $progresspercent
    $userResult = Get-ADUser -server $dc.HostName -filter * -properties Name,sAMAccountName,lastLogon,LastLogonTimestamp,whenCreated,passwordNeverExpires,userAccountControl | select Name,sAMAccountName,lastLogon,LastLogonTimestamp,whenCreated,accountExpires,passwordNeverExpires,userAccountControl
    #$userResult = Get-ADUser -server $dc.HostName -Identity 'seniorj' -properties Name,sAMAccountName,lastLogon,LastLogonTimestamp,whenCreated,accountExpires,passwordNeverExpires,userAccountControl | select Name,sAMAccountName,lastLogon,LastLogonTimestamp,whenCreated,accountExpires,passwordNeverExpires,userAccountControl
    $userlist.Add($userResult) > null
    $progresscounter++
}


Write-Host "Churning lots of data, please wait. This can take a while."
#I couldn't find a pretty way of unpacking and repacking the $userResults and $userlist properly, sorry about this.
$all = @()
$progresscounter = 0
$progresstotal = $userlist.Count
foreach ($row in $userlist) {
    
    $progresspercent = ($progresscounter / $progresstotal)*100
    Write-Progress -activity "Sorting query results" -status "$progresspercent% ($progresscounter / $progresstotal)" -PercentComplete $progresspercent
    foreach ($user in $row) 
    {
        $newUser = "" | select Name,SAMAccountName,lastLogon,lastLogonTimestamp,whenCreated,RecentTime,passwordNeverExpires,userAccountControl
        $newuser.SAMAccountName = $user.sAMAccountName
        $newuser.Name = $user.Name
        $newuser.lastLogon = $user.lastLogon
        $newuser.lastLogonTimestamp = $user.LastLogonTimestamp
        $newUser.whenCreated = $user.whenCreated
        $newUser.passwordNeverExpires = $user.passwordNeverExpires
        $newuser.userAccountControl = $user.userAccountControl
        $newuser.RecentTime = 3
        $all += , $newUser
  } 
  $progresscounter++
}

Write-Progress -activity "Aggregating Users" -PercentComplete 0
$objUsers = @()
$grouplist = $all | group-object -property SAMAccountName
$progresscounter = 0
$progresstotal = $all.Count
foreach ($group in $grouplist) {
    $newUser = "" | select SAMAccountName,Name,lastLogon,lastLogonTimestamp,whenCreated,RecentTime,passwordNeverExpires,userAccountControl
    $newUser.RecentTime = 0
    $newUser.lastLogonTimestamp = 0
    $newUser.lastLogon = 0

    foreach ($user in $group.Group) {
        $progressUser=$user.SAMAccountName
         $progresspercent = "{0:N2}" -f (($progresscounter / $progresstotal)*100)
        Write-Progress -activity "Aggregating Users" -status "$progresspercent% ($progresscounter / $progresstotal) $progressuser" -PercentComplete $progresspercent
        $newuser.SAMAccountName = $user.sAMAccountName
        $newuser.Name = $user.Name
        if ($user.lastLogon -ge $newUser.RecentTime) 
        {
          $newUser.RecentTime = $user.LastLogon
        }
        if ($user.lastLogonTimestamp -ge $newUser.RecentTime) 
        {
          $newUser.RecentTime = $user.LastLogonTimeStamp
        }
        if ($user.lastLogonTimestamp -ge $newuser.LastLogonTimestamp)
        {
          $newUser.lastLogonTimestamp = $user.lastLogonTimestamp
        }
        if ($user.lastLogon -ge $newuser.lastLogon) {
          $newUser.lastLogon = $user.lastLogon
        }
        $newUser.whenCreated = $user.whenCreated
        $newUser.passwordNeverExpires = $user.passwordNeverExpires
        $progresscounter++
        
    }
    $newUser.RecentTime = GetTime($newUser.RecentTime)
    $newUser.lastLogonTimestamp = GetTime($newUser.lastLogonTimestamp)
    $newUser.lastLogon = GetTime($newUser.lastLogon)
    $newUser.userAccountControl = (Get-UserAccountControlFlags($user.userAccountControl) | select -expand Name) -join ","
    $objUsers += , $newUser

    
}

$now = get-date

Write-Host "Displaying unused accounts over 180 days old"
#Prints a pretty table of account names that can be disabled.  
$objUsers | Where-Object {$_.RecentTime -le $now.AddDays(-180)} | sort -Descending RecentTime | format-table
$objUsers | Where-Object {$_.RecentTime -le $now.AddDays(-180)} | sort -Descending RecentTime | Out-GridView


 
foreach($account in $objUsers| Where-Object {$_.RecentTime -le $now.AddDays(-180)} ) {
  $myaccount = $account.SAMAccountName
  #Write-host "ChangePW('$myAccount')"
  #Write-host "ChangePrimaryGroup('$myAccount')"
  #Write-Host "RemoveGroups('$myAccount')"
  #Write-Host "DisableUser('$myAccount')"
  ChangePW($myaccount)
  DisableUser($myaccount)
}


