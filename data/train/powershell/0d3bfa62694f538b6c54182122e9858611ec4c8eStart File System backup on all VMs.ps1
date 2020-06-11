Import-Module CaaS

$secpasswd = ConvertTo-SecureString "mySecure123Pa$$!" -AsPlainText -Force
$login= New-Object System.Management.Automation.PSCredential ("my-login-user", $secpasswd)

New-CaasConnection -ApiCredentials $login -ApiBaseUri "https://api-au.dimensiondata.com/oec/0.9/"

$serversWithBackup = Get-CaasDeployedServer | Where backup -NotLike $Null
foreach ( $server in $serversWithBackup) { 

    Write-Host $server.name is $server.backup.servicePlan 
    $fileClients = Get-CaasBackupClients -Server $server | Where type -Like "FA.%"

    foreach( $fileClient in $fileClients){
        
        if ($fileClient.runningJob.status -eq "Running") {
            Write-Warning "Another Job is already running for  $($server.name)" 
        } else { 
            Write-Host Starting backup of $server.name 
            New-CaasBackupJob -Server $server -BackupClient $fileClient 
        }
    }
}