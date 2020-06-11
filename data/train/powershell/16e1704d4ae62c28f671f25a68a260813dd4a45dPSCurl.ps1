# WebUtility functions
#http://localhost/Telematics.Server/api/geo C:\Users\si553904.LDSTATDV\Documents\GitHub\Telematics.Server\Telematics.Server\Json\geoTelematics.json out.txt
function PostXmlToUrl($uploadUrl, $xmlDocToPost, $saveFileName)
{
	$client = new-object System.Net.WebClient;
	$client.Headers.Add("Content-Type","application/xml; charset=UTF-8");
	[System.Net.ServicePointManager]::Expect100Continue = $false;
	#$xml = "<?xml version='1.0'?><Car><Make>Toyota</Make><EngineSize>2989</EngineSize></Car>"
	$xml = Get-Content $xmlDocToPost;
	#$xml = "=" + $xml;
	[System.Diagnostics.Stopwatch] $sw = New-Object System.Diagnostics.StopWatch;	
  	$sw.Start();
	#Write-Output 'about to post: ' + $xml;
	$response = $client.UploadString($uploadUrl, "POST", $xml);
	
	$sw.Stop();
	$responseTime = $sw.Elapsed.TotalMilliseconds.ToString();

	$resultFileName = $saveFileName;
	if($saveFileName -eq "")
	{		
		$resultFileName = $xmlDocToPost.Replace(".xml", ".response.xml");
	}
	
	$response | Out-File $resultFileName;
	Write-Output "Request took $responseTime milliseconds, Response in file: $resultFileName";
}

# Script

if($args.Count -eq 2)
{
	PostXmlToUrl -uploadUrl $args[0] -xmlDocToPost $args[1] -saveFileName ""
}
elseif($args.Count -eq 3)
{
	PostXmlToUrl -uploadUrl $args[0] -xmlDocToPost $args[1] -saveFileName $args[2]
}
else
{
	Write-Output "Posts xml file to url, Invalid Usage: Takes two arguments, always posts: [Url] [FileName]";
}

