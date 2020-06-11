[Reflection.Assembly]::LoadWithPartialName('System.Web') | Out-Null

$tmdBaseUrl = 'https://api.themoviedb.org/3'
$tmdbSearchUrlFmt = $tmdBaseUrl + '/search/person?api_key={0}&query={1}'
$tmdbPersonUrlFmt = $tmdBaseUrl + '/person/{0}?api_key={1}'

function Get-CastMemberInfo {
[CmdletBinding()]
param (
  [Parameter(Position=0, Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [Alias('k','s')]
  [string] $apiKey,

  [Parameter(Position=1, Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [Alias('n')]
  [string] $name
)

  try {
    $url = $tmdbSearchUrlFmt -f $apiKey,[System.Web.HttpUtility]::UrlEncode($name)
    $response = Invoke-RestMethod $url

    if($response.total_results -lt 1) {
      return (New-Object PSObject -Property @{Message="No results found for name: $name"})
    } else {
      $person = $response.results[0]
      if($response.total_results -gt 1) {
        #too many results found!
        Write-Verbose "Found $($response.total_results) matches for name: $name`n$($response.results | Out-String)"
      }

      $url = $tmdbPersonUrlFmt -f $person.id,$apiKey
      $info = Invoke-RestMethod $url
      #todo add better logic for getting more accurate cast member details
      if([string]::IsNullOrEmpty($info.birthday) -and ($response.total_results -gt 1)) {
        $url = $tmdbPersonUrlFmt -f $response.results[1].id,$apiKey
        $info = Invoke-RestMethod $url
      }

      if([string]::IsNullOrEmpty($info.birthday)) {
        Write-Verbose "no age found for $name"
      } else {
        $span = [DateTime]::Now - (Get-Date $info.birthday)
        $age = (New-Object DateTime -ArgumentList $Span.Ticks).Year - 1
        $info | Add-Member -MemberType NoteProperty -Name ageDays -Value $span.Days
        $info | Add-Member -MemberType NoteProperty -Name age -Value $age
      }
      $info
    }
  } catch [System.Net.WebException],[System.IO.IOException] {
    $record = $error[0]
    $err = New-Object PSObject -Property @{
      Message = "Unable to get cast member's info: $($record.Exception.Message)"
      Exception = $record.Exception
      Detail = $record.ErrorDetails.Message
      Url = $url
    }
    return New-Object PSObject -Property @{Error=$err}
  }
}