<#
The purpose of this script is to allow the automation or ease of implementation for deploying
New Relic to Windows Azure Web Sites

Requirements:
1. Install the powershell SDK: http://go.microsoft.com/?linkid=9811175&clcid=0x409
2. Add your Publish Profile:
https://manage.windowsazure.com >> Web Sites >> [Web Site Name] >> Download the publish profile

PS> azure account download [Subscription Name]
PS> azure account import [PathToPublishSettingsFile]

3. Run the script:
PS> .\NewRelicAzureAppSettings.ps1 [MyWebSiteName]

Note: 
#1 and #2 will only need to be done once for a given Publish Settings file until the file expires.
#3 only needs to be done once per new Web Site


#>

Param(
  [string]$appName
)

azure site config add "COR_ENABLE_PROFILING=1" $appName
azure site config add "COR_PROFILER={71DA0A04-7777-4EC6-9643-7D28B46A8A41}" $appName
azure site config add "COR_PROFILER_PATH=C:\Home\site\wwwroot\newrelic\NewRelic.Profiler.dll" $appName
azure site config add "NEWRELIC_HOME=C:\Home\site\wwwroot\newrelic" $appName
