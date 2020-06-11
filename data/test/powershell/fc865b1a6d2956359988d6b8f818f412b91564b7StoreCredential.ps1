param (
    $CredentialKey,
    [Switch] $AddToTrustedHosts,
    $UserName,
    $CredentialKeyFile
)

function SaveCredential{
    param(
        $CredentialKey,
        $UserName,
        [Switch] $AddToTrustedHosts
    )
    Save-CredentialToDisk -CredentialKey $CredentialKey -UserName $UserName
    if ($AddToTrustedHosts){
        Add-ComputerToTrustedHosts $HostName
    }
}


if ($CredentialKeyFile -ne $null){
    if (!(Test-Path $CredentialKeyFile)){
        throw "Path to the CredentialKeyFile is not found"
    }
    $credKeys = Import-Clixml $CredentialKeyFile

    foreach ($key in $credKeys){
        $result = Read-Host 'Do you want to save Credential Key for' + $key.Key '? y/N (Press Enter if No)'
        if ($result -eq 'y'){
            SaveCredential -CredentialKey $key.Key -UserName $key.UserName -AddToTrustedHosts:$key.AddToTrustedHosts
        }
    }
    return
}

Write-Host Format for database credential is HostName_InstanceName__DBType -foregroundcolor Green
Write-Host MS SQL instances: 1.2.3.4_MyInstance__MsSql -foregroundcolor Green
Write-host Or for one instance in the machine: 1.2.3.4__MsSql -foregroundcolor Green
Write-Host 'Default Credential Directory (env:PSCredentialPath) is:' $env:PSCredentialPath


if ($CredentialKey -eq $null){

    $CredentialKey = Read-Host 'What is the Credential Key for? (Press blank enter to exit)'
    if ($CredentialKey -eq ''){
        return;
    }
    $addingToTrustedHosts = Read-Host 'Do you want to add it to the Trusted Host? y/N (Press Enter if No)'
    if ($addingToTrustedHosts -eq 'y'){
        $AddToTrustedHosts = $true
    }

    SaveCredential -CredentialKey $CredentialKey -AddToTrustedHosts:$AddToTrustedHosts -UserName $UserName
}
