$rtBaseUrl = 'http://api.rottentomatoes.com/api/public/v1.0'
$moviesUrlFmt = $rtBaseUrl + '/lists/movies/in_theaters.json?apikey={0}&page={1}&page_limit={2}'
$fullCastUrlFmt = $rtBaseUrl + '/movies/{0}/cast.json?apikey={1}'

function Get-TheaterMovies {
[CmdletBinding()]
param (
  [Parameter(Position=0, Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [Alias('k','s')]
  [string] $apiKey,

  [Parameter(Mandatory=$false)]
  [ValidateScript({ $_ -ge 1 })]
  [Alias('p')]
  [int] $page = 1,

  [Parameter(Mandatory=$false)]
  [Alias('l','limit')]
  [int] $pageLimit = 16,

  [Alias('f','full')]
  [bool] $fullCast = $false
)

  try {
    if($pageLimit -lt 1) { $pageLimit = 16 }

    $url = $moviesUrlFmt -f $apiKey,$page,$pageLimit
    $response = Invoke-RestMethod $url

    $remainder = $response.total % $pageLimit
    $totalPages = ($response.total - $remainder)/$pageLimit + 1

    Write-Verbose "found $($reponse.total) movies currently in theaters to process"
    $movies = $response.movies | %{
      $movie = $_
      Write-Verbose " .. movie: $($movie.title)"

      if($fullCast) {
        $url = $fullCastUrlFmt -f $movie.id,$apiKey
        $cast = Invoke-RestMethod $url
        $movie | Add-Member -MemberType NoteProperty -Name cast -Value $cast.cast -PassThru
      } else {
        $movie | Add-Member -MemberType AliasProperty -Name cast -Value abridged_cast -PassThru
      }
    }

    $response.movies = $movies
    $response | Add-Member -MemberType NoteProperty -Name pages -Value $totalPages -PassThru
  } catch [System.Net.WebException],[System.IO.IOException] {
    $record = $error[0]
    $err = New-Object PSObject -Property @{
      Message = "Unable to get listing of movies in theaters: $($record.Exception.Message)"
      Exception = $record.Exception
      Detail = $record.ErrorDetails.Message
      Url = $url
    }
    return New-Object PSObject -Property @{Error=$err}
  }
}