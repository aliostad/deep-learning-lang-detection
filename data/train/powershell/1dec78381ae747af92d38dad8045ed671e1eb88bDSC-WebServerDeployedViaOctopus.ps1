param
(
    [string]$ApiKey,
    [string]$OctopusServerUrl,
    [string]$Environments,
    [string]$Roles,
    [string]$ListenPort,
    [string]$ProxyUrlAndPort
)

Configuration LCMConfig {
    LocalConfigurationManager {
        RebootNodeIfNeeded = $true
        CertificateID = (Get-ChildItem Cert:\LocalMachine\My)[0].Thumbprint
    }
}

LCMConfig
Set-DscLocalConfigurationManager -Path .\LCMConfig

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            CertificateFile = 'C:\dsc.cer'
        }
    )
}

Configuration WebConfig {

    Import-DscResource -Module OctopusDSC

    Node "localhost" {

        Script SetTimezone
        {
           GetScript = { return @{ Timezone = ("{0}" -f (tzutil.exe /g)) } }
           TestScript = { return (tzutil.exe /g) -ieq "AUS Eastern Standard Time" }
           SetScript = { tzutil.exe /s "AUS Eastern Standard Time" }
        }

        cTentacleAgent OctopusTentacle 
        { 
            Ensure = "Present"; 
            State = "Started"; 

            Name = "Tentacle";

            ProxyAddress = $ProxyUrlAndPort

            ApiKey = $ApiKey;
            OctopusServerUrl = $OctopusServerUrl;
            Environments = $Environments;
            Roles = $Roles;

            ListenPort = $ListenPort;
            DefaultApplicationDirectory = "C:\Applications"
        }
    }
}

WebConfig -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\WebConfig -Wait -Verbose