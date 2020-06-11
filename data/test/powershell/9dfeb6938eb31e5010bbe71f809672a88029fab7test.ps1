function checkVagrantVersion {

    function getVagrantVersion($installPath) {

        # @todo
        #$vagrantManagePath = Join-Path $installPath "VBoxManage.exe"
        #$vagrantInstalledVersion = Start-Process $vboxManagePath -ArgumentList "-v" # 4.3.14r95030
        $vagrantInstalledVersion = "Vagrant 1.6.3" # temp
        $vagrantInstalledVersion = $vagrantInstalledVersion.Split(" ")
        $version = $vagrantInstalledVersion[1]

        return $version
    }
    
    if ( ( $env:VBOX_INSTALL_PATH ) ) {
        $version = getVagrantVersion($env:VBOX_INSTALL_PATH)
    }
    else {
        $version = "false"
    }

    return $version
}

$out = checkVagrantVersion
Write-Host $out