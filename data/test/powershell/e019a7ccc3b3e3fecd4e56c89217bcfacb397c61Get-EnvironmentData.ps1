function Get-EnvironmentData {

  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false)]
    [string]
    $Uri = "https://git.crayon.com/api/v3/projects/3/repository/raw_blobs/$FileID?private_token=M79KcuudA58L1q-pmttC"
  )

try {

$tree = Invoke-RestMethod -Uri "https://git.crayon.com/api/v3/projects/52/repository/tree/?private_token=M79KcuudA58L1q-pmttC&path=Environments" -ErrorAction Stop

$FileID = $tree.Where({$PSItem.Name -eq 'Environment-data.json'}).Id

$Uri = "https://git.crayon.com/api/v3/projects/52/repository/raw_blobs/$($FileID)?private_token=M79KcuudA58L1q-pmttC"

$EnvData = Invoke-RestMethod -Uri $Uri -ErrorAction Stop

}

catch {

Write-Warning -Message 'Unable to get file contents for environment-data from GitLab'
$_.Exception

}

if ($env:USERDNSDOMAIN) {

if ($EnvData.Environments.Where({$_.DomainFQDN -eq $env:USERDNSDOMAIN})) {

return $EnvData.Environments.Where({$_.DomainFQDN -eq $env:USERDNSDOMAIN})

} else {

Write-Warning -Message "Environment data for the current user`s DNS Domain $($env:USERDNSDOMAIN) is not available in the environment-file"

}


}



}