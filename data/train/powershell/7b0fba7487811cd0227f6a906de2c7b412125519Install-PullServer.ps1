param (
    [Parameter(Mandatory=$true)][String]$Thumbprint,
    [Parameter(Mandatory=$false)][String]$NodeName = "localhost",
    [Parameter(Mandatory=$false)][String]$DSCManagerPath = "$env:HOMEDRIVE\DSC-Manager",
    [Parameter(Mandatory=$false)][String]$PowerShellGetInstaller
    )

#Configuration Data For PullServer Install$configData = @{    AllNodes = @(        @{            NodeName = "*"            PSDscAllowPlainTextPassword = $true         },         @{            NodeName = $NodeName            CertificateThumbPrint = $Thumbprint         }    );}

#Ensure Module path exists in current session
If (!($env:PSModulePath -like "*$DSCManagerPath\Modules*")) {
    $env:PSModulePath = $env:PSModulePath+";$DSCManagerPath\Modules"
    }

#amends module path
$DSCManagerURL = "$DSCManagerPath\Modules"
$originalpaths = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PSModulePath).PSModulePath
If (!($originalpaths -like "*$DSCManagerURL*") -and (Test-Path $DSCManagerURL)) {
    write-verbose "updating PSModulePath to include new modules"
    $newPath=$originalpaths+";$DSCManagerURL"
    Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PSModulePath –Value $newPath
    }
ElseIF (!(Test-Path $DSCManagerURL)) { 
    Throw "The Path $DSCManagerURL cannot be found. Exiting"
    }

#This imports the DSC Management functions.  This helps manage Certificate and GUID mappings
if(!(Get-Module xDSCManager)) {
    Try {
        Import-Module xDSCManager
        }
    Catch {
        Throw "Trying to load Management tools but failing.  Check for presense of module xDSCManager"
        }
    }

#Use PowerShellGet to to download xPSDersiredState if it's missing
If (!(get-module xPSDesiredStateConfiguration -ListAvailable)) {
    If (get-module PowerShellGet -ListAvailable) {
        write-verbose "Required modules missing, but PowerShellGet is installed, grabbing modules"
        import-module PowerShellGet
        install-module xPSDesiredStateConfiguration
        }
    ElseIf (($PSVersionTable.PSVersion.Major -lt 5) -and (Test-Path $PowerShellGetInstaller)) {
        write-verbose "Attempting to install PowerShellGet via "
        $cmd = "msiexec /i $PowerShellGetInstaller /quiet"
        Invoke-Expression $cmd | Write-Verbose
        import-module PowerShellGet
        Get-PackageProvider -Name NuGet -ForceBootstrap
        install-module xPSDesiredStateConfiguration
        }
    Else {
        Throw "The required modules are not available nor is PowerShellGet available to aquire them."
        }
    } #End missing xPSDesiredStateConfiguration

try {
    Import-Module xPSDesiredStateConfiguration
    }
Catch {
    Throw "Can't import xPSDesiredStateConfiguration ... exiting"
    }

#DSC Configuration
write-verbose "Loading configuration for Pull Server"
configuration DSC_PullServer {

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"            
        }

        WindowsFeature WindowsAuth
        {
            Ensure = "Present"
            Name   = "web-windows-auth"            
        }

        WindowsFeature IISTools
        {
            Ensure = "Present"
            Name   = "Web-Mgmt-Console"            
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint   = $Node.CertificateThumbPrint         
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"            
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"                        
        }

        xDscWebService PSDSCComplianceServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCComplianceServer"
            Port                    = 9080
            PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCComplianceServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            State                   = "Started"
            IsComplianceServer      = $true
            DependsOn               = @("[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer")
        }
    }
 } #End DSC_PullServer

#Actually Install Pull Server
write-verbose "Installing Pull Server"
DSC_PullServer -ConfigurationData $ConfigData
Start-DscConfiguration -wait -verbose .\DSC_PullServer -force

#Finally install folders and shares needed by the DSCManagerTools
write-verbose "Installing shares and folders needed for automatic agent enrollment"
Install-DSCMCertStores
