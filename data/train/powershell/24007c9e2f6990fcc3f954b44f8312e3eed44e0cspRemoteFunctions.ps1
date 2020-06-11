#############################################################
# SharePoint Remoting Functions
# Rob Garrett

function copyScriptsToServers {
    # Copy all scripts to the correct servers
    copyScriptsToRemote -computerName $caServer;
    foreach ($srv in $wfeServers) { copyScriptsToRemote -computerName $srv }
    foreach ($srv in $appServers) { copyScriptsToRemote -computerName $srv }
    foreach ($srv in $searchServers) { copyScriptsToRemote -computerName $srv }
}

function copyScriptsToRemote($computerName) {
    # Copy scripts to a remote computer
    Write-Host "Copying scripts to server $computerName";
    Invoke-Command -ComputerName $computerName -ScriptBlock { 
        $setupFolder = "c:\Scripts"
            New-Item -Path $setupFolder -type directory -Force 
         }
    $where = Split-Path -parent $PSCommandPath
    Copy-Item -Path "$where\*" -Filter *.ps1 -Destination "\\$computerName\c$\Scripts\"
}

function remoteInstallCA {
    # Install Central Admin on CA server
    if ($forceRemote -eq $false -and $caServer.ToUpper() -eq $env:COMPUTERNAME.ToUpper()) {
        Invoke-Expression (c:\scripts\Install-CAServer.ps1 -localExec 0);
    } else {
        Invoke-Command -ComputerName $caServer -ScriptBlock {
            Invoke-Expression (c:\scripts\Install-CAServer.ps1 -localExec 1);
        }
    }
}