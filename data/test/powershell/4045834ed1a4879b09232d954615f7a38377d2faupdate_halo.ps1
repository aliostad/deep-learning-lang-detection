##Windows Powershell Script to auto-update Windows
# Author: Sean Nicholson
# Version: 1.0

# Add your API Key information here
$apiKey="your_api_key_id"
$apiSecret="your_api_secret_key"

#Request Bearer token from Halo API
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$encode64='Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($apiKey):$($apiSecret)"))

$params = @{uri = 'https://api.cloudpassage.com/oauth/access_token?grant_type=client_credentials';
            Method = 'Post';
            Headers = @{Authorization = $encode64;}
           }

$auth = Invoke-RestMethod @params
$token = $auth.access_token


$header = @{Authorization = "Bearer $token";
            ContentType = "application/json;charset=UTF=8";
           }

# Request /v2/isntallers/windows Halo endpoint for determining the latest version
# of the Halo Windows agent

$request = @{uri = 'https://api.cloudpassage.com/v2/installers/windows';
             Method = 'Get';
             Headers = $header;
            }
$response = Invoke-RestMethod @request
$windows_agent_version = $response.windows_agent_version
$new_windows_agent = $response.windows_installer
$new_agent_file_name = "cphalo-" + $windows_agent_version + "-win64.exe"
$configure_switch = "/S"
#write-host $windows_agent_version
#write-host $new_agent_file_name
$installed_halo =(Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\cphalo").DisplayVersion

# If check for comparing values of installed agent and the one list in the
# installers API endpoint

if (-NOT ($windows_agent_version -eq $installed_halo)){
    Invoke-WebRequest -Uri $new_windows_agent -OutFile .\$new_agent_file_name
    &.\$new_agent_file_name $configure_switch
}
