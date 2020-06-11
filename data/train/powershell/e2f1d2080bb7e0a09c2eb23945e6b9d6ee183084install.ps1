param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath NewRelicHelper.psm1)

Write-Host "***Updating project items newrelic.config***" -ForegroundColor DarkGreen
$newrelic = $project.ProjectItems.Item("newrelic")
$config = $newrelic.ProjectItems.Item("newrelic.config")
$configPath = $config.Properties.Item("LocalPath").value

[xml] $configXml = Get-Content $configPath
$ns = @{ e = "urn:newrelic-config" }
$ns = New-Object Xml.XmlNamespaceManager $configXml.NameTable
$ns.AddNamespace( "e", "urn:newrelic-config" )

$projectName = $project.Name.ToString()

$extensionFile = $project.ProjectItems.Item("newrelic").ProjectItems.Item("extensions").ProjectItems.Item("extension.xsd")
if($extensionFile -ne $null){
	$extensionFile.Properties.Item("BuildAction").Value = 2
}

if($configXml -ne $null){

	#Modify NewRelic.config to accept the user's license key input 
	
	$serviceNode = $configXml.configuration.service
	if($serviceNode -ne $null -and $serviceNode.licenseKey -eq "REPLACE_WITH_LICENSE_KEY"){
		
		$licenseKey = create_dialog "License Key" "Please enter your New Relic license key (optional)"
		
		if($licenseKey -ne $null -and $licenseKey.Length -gt 0){
			Write-Host "Updating licensekey in the newrelic.config file..."	 -ForegroundColor DarkGreen
			$serviceNode.SetAttribute("licenseKey", $licenseKey)
		}
		else{
			Write-Host "No Key was provided, please make sure to edit the newrelic.config file & add a valid New Relic license key before deploying your application." -ForegroundColor DarkYellow
		}
	}
	else{
		Write-Host "License Key exists, the package will not prompt the user.  If you would like to change the key please make sure to edit the newrelic.config file & add a valid New Relic license key before deploying your application." -ForegroundColor DarkYellow
	}
	# save the newrelic.config file
   	$configXml.Save($configPath)
}

Write-Host "***Package install is complete***" -ForegroundColor DarkGreen
	
Write-Host "Please make sure to go add the following configurations to your Azure website." -ForegroundColor DarkGreen
Write-Host "Go to manage.windowsazure.com, log in, navigate to your Web Site, choose 'configure' and add the following as 'app settings' " -ForegroundColor DarkGreen

#Write-Host $appSettings | Format-Table @{Expression={$_.Key};Label="Key";width=25},Value
Write-Host "Key					Value"
Write-Host "---------------------------------------"
Write-Host "COR_ENABLE_PROFILING	1"
Write-Host "COR_PROFILER			{71DA0A04-7777-4EC6-9643-7D28B46A8A41}"
Write-Host "COR_PROFILER_PATH		C:\Home\site\wwwroot\newrelic\NewRelic.Profiler.dll"
Write-Host "NEWRELIC_HOME			C:\Home\site\wwwroot\newrelic"

