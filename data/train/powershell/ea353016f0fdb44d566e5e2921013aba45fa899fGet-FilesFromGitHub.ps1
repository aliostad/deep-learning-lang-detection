function Get-FilesFromGitHub()
{
  Param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Owner,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Repo,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Path
  )
  
  $apiUrl = [String]::Format("https://api.github.com/repos/{0}/{1}/contents/{2}", $Owner, $Repo, $Path)
  $response = Invoke-WebRequest -Uri $apiUrl
  $files = $response.Content | ConvertFrom-Json
  return $files
}