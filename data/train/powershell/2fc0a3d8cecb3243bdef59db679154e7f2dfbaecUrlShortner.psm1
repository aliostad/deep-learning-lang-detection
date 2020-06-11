function IsValidUri($url)
{
	$uri = $url -as [System.Uri]
	if($uri -eq $null)
	{
		return $false
	}

	$uri.AbsoluteUri -ne $null -and $uri.Scheme -match '[http|https]'
}

function New-ShortUrl
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[ValidateNotNullOrEmpty()]
		[string] $Url
	)
	
	if(-not (IsValidUri($Url)))
	{
		throw "$($Url) is not a valid Uri" 
	}

	$tinyUrlApi = 'http://tinyurl.com/api-create.php'
	$response = Invoke-WebRequest ("{0}?url={1}" -f $tinyUrlApi, $Url)
	$response.Content
}

Export-ModuleMember -Function New*
