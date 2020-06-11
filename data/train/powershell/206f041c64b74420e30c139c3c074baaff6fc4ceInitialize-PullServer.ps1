######################################################################################
# This section will manage the TargetNode list.
# Static variable is for system roles and services, then thumprint info is merged
# using DSC-Management Module
######################################################################################



#This imports the DSC Management functions.  This helps manage Certificate and GUID mappings
if(!(Get-Module DSC-Management)) {
    Try {
        Import-Module ('.\DSC-Management.ps1')
        }
    Catch {
        Throw "Cannot load the DSC GUID and Certificate Management Tools.  Please make sure the module is present and try again"
        }
    }

#Need to know where the Certificates are Stored
$CertStore = "$env:PROGRAMFILES\WindowsPowershell\DscService\NodeCertificates"

#Use functions to add missing GUID and thumprint information to the host list
$ProximusHosts.AllNodes | ForEach-Object -Process {
    $CurrNode = $_.NodeName
    Update-DSCMGUIDMapping -NodeName $CurrNode
    if (Update-DSCMCertMapping -NodeName $CurrNode) {
        $_.Thumbprint = (Update-DSCMCertMapping -NodeName $CurrNode)
        $_.CertificateFile = $CertStore+'\'+$CurrNode+'.cer'
        }
    }


######################################################################################
# This section will run the hashtable against the configuration and then copy
# the resulting files to the Pull server
#
######################################################################################

#Below we combine the DSC Configuration with the Host settings
$SCCMAdminCred = Get-Credential
MasterConfiguration -ConfigurationData $ProximusHosts -SCCMAdministratorCredential $SCCMAdminCred

#This reads the resulting mof files and renames them to the GUID defined by DSC-Management
foreach ($Node in $ProximusHosts.AllNodes) {
    $NewGUID = Update-DSCMGUIDMapping -NodeName $Node.NodeName
    $OldName = Join-Path '.\MasterConfiguration\' $Node.NodeName
    If(Test-Path -Path $OldName'.mof') {Rename-Item -Path $OldName'.mof' -NewName $NewGUID'.mof'}
    }
New-DSCCheckSum -ConfigurationPath .\MasterConfiguration -OutPath .\MasterConfiguration -Verbose -Force

#All Generation is complete, now we copy it all to the Pull Server
$SourceFiles = (Get-Location -PSProvider FileSystem).Path + "\MasterConfiguration\*.mof*"
$TargetFiles = "$env:SystemDrive\Program Files\WindowsPowershell\DscService\Configuration"
Move-Item $SourceFiles $TargetFiles -Force

#This section scans the local Modules Directory then zips them into the DSCPull server
$resources = (Get-ChildItem -Directory $env:PROGRAMFILES\WindowsPowerShell\Modules\)
foreach ($Name in $resources){
    $ShortName = $Name
    $resourceZipPath = New-DSCMResourceZip -modulePath $env:PROGRAMFILES\WindowsPowershell\Modules\$ShortName
    }

