$user = 'manuel.henke'
$pass = 'wh00t'
$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($user, $secpasswd)


function New-ApiUser {
  [CmdletBinding()]
  param(
    [pscredential]$Credential
    #$Username,
    #$Password
  )
  try {

    $person = @{
        username=$credential.GetNetworkCredential().username
        password=$credential.GetNetworkCredential().password
      }
      $Headers = @{
              'Accept' = '*/*'
              'content-type' = 'application/json'
      }

      $json = $person | ConvertTo-Json -Compress

      $Respond = Invoke-WebRequest -Method POST -Uri 'http://localhost:8080/api/register' -Header $Headers -Body $json -ErrorAction Stop
      #-Uri 'http://localhost.fiddler:8080/api/register' -Proxy 'http://localhost:8888'
      if (-not $Respond.Statuscode -like '200') {
        Write-Error 'Schief gelaufen'  
      }  
  }
  catch {
    $PSCmdlet.ThrowTerminatingError($_)
  }
}

function Get-ApiToken {
  [CmdletBinding()]
  param(
    [pscredential]$Credential
    #$Username,
    #$Password
  )
  $Header = @{
    'content-type' = 'application/x-www-form-urlencoded'
  }
  $token = @{
    grant_type='password'
    username=$credential.GetNetworkCredential().username
    password=$credential.GetNetworkCredential().password
  }
  $response = Invoke-WebRequest -Method Post -Uri 'http://localhost:8080/token' -Headers $header -Body $token
  $global:access_token = ($response.Content | ConvertFrom-Json).access_token
  Write-Output 'Access Token is stored in variable $access_token'
}

function Get-AuthRequest {
  [CmdletBinding()]
  param(
    $Token
  )
  $HeaderValue = 'Bearer ' + $Token
  Invoke-RestMethod -Uri http://localhost:8080/api/process -Headers @{Authorization = $HeaderValue}
}