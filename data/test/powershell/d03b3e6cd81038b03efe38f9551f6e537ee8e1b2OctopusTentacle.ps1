Configuration TentacleConfig
{
    param ($ApiKey, $OctopusServerUrl, $Environments, $Roles, $ListenPort, $MachineName, $ApplicationDirectory)

    Import-DscResource -Module OctopusDSC

    Node $MachineName
    {
        cTentacleAgent OctopusTentacle 
        { 
            Ensure = "Present"; 
            State = "Started"; 

            # Tentacle instance name. Leave it as 'Tentacle' unless you have more 
            # than one instance
            Name = "Tentacle";

            # Registration - all parameters required
            ApiKey = $ApiKey;
            OctopusServerUrl = $OctopusServerUrl;
            Environments = $Environments;
            Roles = $Roles;

            # Optional settings
            ListenPort = $ListenPort;
            DefaultApplicationDirectory = $ApplicationDirectory
        }
    }
}
