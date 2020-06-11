Import-Module -Name $(Join-Path $PSScriptRoot 'ApiManagement-ManagementApi.psm1') -Force -Verbose -PassThru

Set-Variable -Name authorizatoin -Value 'SharedAccessSignature uid=5{id}&ex={date-time}&sn={signature}'
Set-Variable -Name serviceUrl -Value 'https://{service}.management.azure-api.net'

$users = Get-Users 

foreach($u in $users.value){
    $user = Get-User -id $u.id

    $user | Format-List

    $groups = Get-UserGroupList -id $user.id

    $groups.value | Format-Table -AutoSize

    $subscriptions = Get-UserSubscriptionList -id $user.id
    $subscriptions | Format-Table -AutoSize
}

<#
$groups = Get-Groups

foreach($g in $groups.value)
{
  $group = Get-Group -id $g.id
  
  $users = Get-Groupusers -id $group.id

  foreach($u in $users.value)
  {
    $u | Format-List
  }
}

$products = Get-Products

foreach($p in $products.Value)
{
  Get-Product -id $p.id | Format-List
  
  $apiList = Get-ProductApiList -id $p.id
  
  foreach($a in $apiList.Value)
  {
    $api = Get-API -id $a.id 
    
    $api | Format-List    
  }
}#>