# --------------------------
# The Basics
# --------------------------
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDirectory = Split-Path $scriptPath
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$msBuild = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe"

# --------------------------
# Web Server Configuration
# --------------------------
# The solution to compile, containing the web project
$config_slnFile = Resolve-Path (Join-Path ($scriptDirectory) "..\src\Lacjam.sln")

# The IP address to bind the IIS site to
$config_iisIpAddress = "127.0.0.1"

# The hostname for the IIS site. This will be added to your hosts entry, so DNS setup is not required.
$config_applicationHostName = "www.lacjam.local"
$config_applicationApiName = "api"

# The path of the web project, to host in IIS
$config_webServerPath = Resolve-Path (Join-Path ($scriptDirectory) "..\src\WebClient\")
$config_apiPath = Resolve-Path (Join-Path ($scriptDirectory) "..\src\WebApi")

#root path
$config_rootPath = Resolve-Path (Join-Path ($scriptDirectory) "..\")


# The application pool name in IIS
$config_AppPoolName = $config_applicationHostName
$config_ApiAppPoolName = "api_$config_applicationHostName"

# The path to nuget.exe, which is used for installing the kiandra repository
$config_nugetPath = Resolve-Path (Join-Path ($scriptDirectory) "..\tools\nuget\nuget.exe")


    
