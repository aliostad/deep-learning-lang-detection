function GitHubOAuthToken($UserName,$Password)
{
 
  
  $NoEnvironmentVariable = $false;
  $Note = 'Command line API token';
 

  try
  {
    $postData = @{
      scopes = @('repo');
      note = $Note
    }

    $params = @{
      Uri = 'https://api.github.com/authorizations';
      Method = 'POST';
      Headers = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String(
          [Text.Encoding]::ASCII.GetBytes("$($userName):$($password)"));
      }
      ContentType = 'application/json';
      Body = (ConvertTo-Json $postData -Compress)
    }
    $global:GITHUB_API_OUTPUT = Invoke-RestMethod @params
    Write-Verbose $global:GITHUB_API_OUTPUT

    $token = $GITHUB_API_OUTPUT | Select -ExpandProperty Token
    Write-Host "New OAuth token is $token"

    if (!$NoEnvironmentVariable)
    {
      $Env:GITHUB_OAUTH_TOKEN = $token
      [Environment]::SetEnvironmentVariable('GITHUB_OAUTH_TOKEN', $token, 'User')
    }
  }
  catch
  {
    Write-Error "An unexpected error occurred (bad user/password?) $($Error[0])"
  }
}

function GetGitHubRepos($SearchType, $Name, $Type, $Sort, $Direction)
{
  switch ($SearchType)
  {
    'org' { $uri = "https://api.github.com/orgs/$Name/repos" }
    'user' { $uri = "https://api.github.com/users/$Name/repos" }
  }

  $uri += ("?type=$Type&sort=$Sort" +
    "&direction=$Direction&access_token=${Env:\GITHUB_OAUTH_TOKEN}")

  $global:GITHUB_API_OUTPUT = @()

    $response = Invoke-WebRequest -Uri $uri
	##Write-Host $uri
	$x = ($response.Content | ConvertFrom-Json)
	##Write-Host $x.Count
    $global:GITHUB_API_OUTPUT += ($response.Content | ConvertFrom-Json)
	##Write-Host $global:GITHUB_API_OUTPUT.Count
   

 
	Write-Host "Found $($global:GITHUB_API_OUTPUT.Count) repos for $Name"
}

function GetGitHubRepositories
{
  
    $ForOrganization = $true;
    $Organization = 'RSUIDevelopment';
    $Type = 'all';
    $Sort = 'name';
    $Direction = 'asc';
  

  try
  {
	
	##Write-Host 'Organization:' $Organization
    GetGitHubRepos 'org' $Organization $Type $Sort $Direction
	
	##Write-Host $global:GITHUB_API_OUTPUT

    $global:GITHUB_API_OUTPUT |
      % {
        $size = if ($_.size -lt 1024) { "$($_.size) KB" }
          else { "$([Math]::Round($_.size, 2)) MB"}
        $pushed = [DateTime]::Parse($_.pushed_at).ToString('g')
        $created = [DateTime]::Parse($_.created_at).ToString('g')

        #$private = if ($_.private) { ' ** Private **' } else { '' }
        $fork = if ($_.fork) { ' [F!]' } else { '' }
		$cloneurl = $_.clone_url

        Write-Host ("`n$($_.name)$private$fork : Updated $pushed" +
          " - [$($_.open_issues)] Issues - $size -$cloneurl")

        if (![string]::IsNullOrEmpty($_.description))
        {
          Write-Host "`t$($_.description)"
        }
      }
  }
  catch
  {
    Write-Error "An unexpected error occurred $($Error[0])"
  }
}

if ([string]::IsNullOrEmpty($Env:GITHUB_OAUTH_TOKEN))
{
  GitHubOAuthToken 'USERNAME' 'PASSWORD';
}

GetGitHubRepositories

