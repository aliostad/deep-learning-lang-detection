
# https://gist.github.com/kfrancis/3164709
# https://rpm.newrelic.com/accounts/289658/applications/1610344/deployments/instructions
function SetNewRelicDeployment {
	param
	(
		[string] $AppId,
		[string] $ApiKey,
		[string] $Username = "OctopusDeploy",
		[string] $Revision,
		[switch] $Verbose
	)
    if ($Verbose) {
        $VerbosePreference = 'Continue'
    }
	Write-Verbose "SetNewRelicDeployment: Setting revision $Revision for new deployment for $AppId"
	$URL = "http://api.newrelic.com/deployments.xml"
	$post = "deployment[user]=$Username&deployment[app_id]=$AppId&deployment[revision]=($Revision)"
	$URI = New-Object System.Uri($URL,$true)
 
	#Create a request object using the URI
	$request = [System.Net.HttpWebRequest]::Create($URI)
 
	#Build up a nice User Agent
	$request.UserAgent = $(
		"{0} (PowerShell {1}; .NET CLR {2}; {3})" -f $UserAgent, 
		$(if($Host.Version){$Host.Version}else{"1.0"}),
		[Environment]::Version,
		[Environment]::OSVersion.ToString().Replace("Microsoft Windows ", "Win")
		)
  
	# $creds = New-Object System.Net.NetworkCredential($Username,$Password)
	# $request.Credentials = $creds
 
	#Since this is a POST we need to set the method type
	$request.Method = "POST"
	$request.Headers.Add("x-api-key", $ApiKey);
 
	#Set the Content Type as text/xml since the content will be a block of xml.
	$request.ContentType = "application/x-www-form-urlencoded"
	$request.Accept = "text/xml"
 
	try {
		#Create a new stream writer to write the xml to the request stream.
		$stream = New-Object IO.StreamWriter $request.GetRequestStream()
		$stream.AutoFlush = $True
		$PostStr = [System.Text.Encoding]::UTF8.GetBytes($Post)
		$stream.Write($PostStr, 0,$PostStr.length)
		$stream.Close()
     
		#Make the request and get the response
		$response = $request.GetResponse()    
		$response.Close()
   
		if ([int]$response.StatusCode -eq 201) {
			Write-Verbose "SetNewRelicDeployment: NewRelic deploy API called succeeded."
		} else {
			throw "SetNewRelicDeployment: NewRelic deploy API called failed."
		}
	} catch [System.Net.WebException] {
		$res = $_.Exception.Response
		throw "SetNewRelicDeployment: NewRelic Deploy API called failed." 
	}
}

Export-ModuleMember -function * -alias *

Write-Host 'Imported CsPsLib.NewRelic.psm1'
