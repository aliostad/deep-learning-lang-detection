configuration ConfigurationAPP1
{
    param 
    ( 
        [Parameter(Mandatory = $true)]
        [string] $DomainName,

        [Parameter(Mandatory = $true)]
        [pscredential] $Credential,

        [Parameter(Mandatory = $true)]
        [string] $NetworkPrefix
    );

    Import-DscResource -ModuleName PSDesiredStateConfiguration, 
        @{ModuleName="xNetworking";ModuleVersion="2.11.0.0"},
        @{ModuleName="xComputerManagement";ModuleVersion="1.8.0.0"},
        @{ModuleName="PackageManagementProviderResource";ModuleVersion="1.0.3"}

    $domainPrefix = $DomainName.Split(".")[0];

    $features = @(
        "Containers"
    );

    $domainCredential = New-Object System.Management.Automation.PSCredential ("$domainName\Administrator", $Credential.Password);

    Node APP1
    {
        foreach($feature in $features)
        {
            WindowsFeature "WF-$feature" 
            { 
                Name = $feature
                Ensure = "Present"
            }
        }

        xFirewall "F-FPS-NB_Datagram-In-UDP"
        {
            Name = "FPS-NB_Datagram-In-UDP"
            Ensure = "Present"
            Enabled = "True"
        }

        xFirewall "F-FPS-NB_Name-In-UDP"
        {
            Name = "FPS-NB_Name-In-UDP"
            Ensure = "Present"
            Enabled = "True"
        }

        xFirewall "F-FPS-NB_Session-In-TCP"
        {
            Name = "FPS-NB_Session-In-TCP"
            Ensure = "Present"
            Enabled = "True"
        }

        xFirewall "F-Docker"
        {
            Name = "Docker"
            DisplayName = "Docker (tcp/2375)"
            Ensure = "Present"
            Enabled = "True"
            Profile = ("Domain", "Private", "Public")
            Direction = "Inbound"
            LocalPort = 2375
            Protocol = "tcp"
        }

        xFirewall "F-DockerSwarmMaster"
        {
            Name = "DockerSwarmMaster"
            DisplayName = "Docker Swarm Master (tcp/3375)"
            Ensure = "Present"
            Enabled = "True"
            Profile = ("Domain", "Private", "Public")
            Direction = "Inbound"
            LocalPort = 3375
            Protocol = "tcp"
        }

        xIPAddress "IA-Ip"
        {
            IPAddress = "$NetworkPrefix.70"
            SubnetMask = 24
            InterfaceAlias = "Ethernet"
            AddressFamily = "IPv4"
        }

        xDnsServerAddress "DSA-DnsConfiguration"
        { 
            Address = "$NetworkPrefix.10"
            InterfaceAlias = "Ethernet"
            AddressFamily = "IPv4"
            DependsOn = "[xIPAddress]IA-Ip"
        }

        xDefaultGatewayAddress "DGA-GatewayConfiguration"
        {
            Address = "$NetworkPrefix.10"
            InterfaceAlias = "Ethernet"
            AddressFamily = "IPv4"
        }

        xComputer "C-JoinDomain"
        {
            Name = $Node.NodeName
            DomainName = $DomainName
            Credential = $domainCredential
            DependsOn = "[xDnsServerAddress]DSA-DnsConfiguration"
        }

        Group "G-Administrators"
        {
            GroupName = "Administrators"
            Credential = $domainCredential
            MembersToInclude = "$DomainName\g-LocalAdmins"
            DependsOn = "[xComputer]C-JoinDomain"
        }

        Group "G-RemoteDesktopUsers"
        {
            GroupName = "Remote Desktop Users"
            Credential = $domainCredential
            MembersToInclude = "$DomainName\g-RemoteDesktopUsers"
            DependsOn = "[xComputer]C-JoinDomain"
        }

        Group "G-RemoteManagementUsers"
        {
            GroupName = "Remote Management Users"
            Credential = $domainCredential
            MembersToInclude = "$DomainName\g-RemoteManagementUsers"
            DependsOn = "[xComputer]C-JoinDomain"
        }

        PSModule "PM-DockerProvider"
        {
            Ensure = "Present"
            Name = "DockerMsftProvider"
            InstallationPolicy = "trusted"
            Repository = "PSGallery"
        }

        PackageManagement "PM-Docker"
        {
            Ensure = "Present"
            Name = "docker"
            ProviderName = "DockerMsftProvider"
            DependsOn = "[PSModule]PM-DockerProvider"
        }

        Registry "R-DockerServiceConfiguration"
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Docker"
            ValueName = "ImagePath"
            ValueData = "C:\Program Files\Docker\dockerd.exe --run-service -H tcp://0.0.0.0:2375 -H npipe://"
            DependsOn = "[PackageManagement]PM-Docker"
        }
        
        Script "S-RebootDocker"
        {
            GetScript = { @{ Result = "" } }
            SetScript = {
                New-Item -Path "C:\LabBits\reboot-docker.txt" -Type File -Force;
                $global:DSCMachineStatus = 1;
            }
            TestScript = {
                return (Test-Path C:\LabBits\reboot-docker.txt)
            }
            DependsOn = "[Registry]R-DockerServiceConfiguration"
        }

        File "F-SwarmToken"
        {
            Ensure = "Present"
            DestinationPath = "C:\LabBits\swarm-token.txt"
            Contents = "3908e2225b30437f9a87d6e356297272"
        }

        Script "S-RunSwarmAgent"
        {
            GetScript = { @{ Result = "" } }
            SetScript = {
                $ErrorActionPreference = "SilentlyContinue";
                $token = Get-Content C:\LabBits\swarm-token.txt;

                $ip = (Get-NetIPAddress -AddressFamily IPv4 `
                    | Where-Object -FilterScript { $_.InterfaceAlias -eq "vEthernet (HNS Internal NIC)" }
                ).IPAddress;

                docker pull stefanscherer/swarm-windows:latest-nano
                docker run -d --name=swarm-agent --restart=always stefanscherer/swarm-windows:latest-nano join "--addr=$($ip):2375" "token://$($token)";
            }
            TestScript = {
                $agentContainer = docker ps -aq --filter "name=swarm-agent";
                return -not [string]::IsNullOrEmpty($agentContainer);
            }
            Credential = $domainCredential
            DependsOn = "[Script]S-RebootDocker", "[File]F-SwarmToken"
        }

        Script "S-RunSwarmMaster"
        {
            GetScript = { @{ Result = "" } }
            SetScript = {
                $ErrorActionPreference = "SilentlyContinue";
                $token = Get-Content C:\LabBits\swarm-token.txt;

                docker pull stefanscherer/swarm-windows:latest-nano
                docker run -d --name=swarm-master --restart=always -p 3375:2375 stefanscherer/swarm-windows:latest-nano manage "token://$($token)";
            }
            TestScript = {
                $agentContainer = docker ps -aq --filter "name=swarm-master";
                return -not [string]::IsNullOrEmpty($agentContainer);
            }
            Credential = $domainCredential
            DependsOn = "[Script]S-RebootDocker", "[File]F-SwarmToken"
        }

        Script "S-RunPortainer"
        {
            GetScript = { @{ Result = "" } }
            SetScript = {
                $ErrorActionPreference = "SilentlyContinue";
                $ip = $(docker inspect --format '{{ json .NetworkSettings.Networks.nat.IPAddress }}' swarm-master);
                docker pull portainer/portainer:windows
                docker run -d --name=portainer --restart=always -p 80:9000 portainer/portainer:windows -H tcp://$($ip):2375 --swarm
            }
            TestScript = {
                $agentContainer = docker ps -aq --filter "name=portainer";
                return -not [string]::IsNullOrEmpty($agentContainer);
            }
            Credential = $domainCredential
            DependsOn = "[Script]S-RunSwarmMaster"
        }
    }
}