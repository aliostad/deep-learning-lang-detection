function Invoke-Putty {

    $putty = Find-InPath putty.exe

    if(-not $putty) {
        Write-Warning 'Could not find putty.exe'
        return;
    }

    $sshHost = $args[0]
    $parms = $args

    $parms = @(& {
            
        if($emuHk) {
            #nt;
        }

        if($parms) {

            if(Test-Path "HKCU:\Software\SimonTatham\PuTTY\Sessions\$sshHost") {
                '-load';
            }

            $sshHost;

            if($parms.Length -gt 1) {
                $parms[1..($parms.Length - 1)]
            }
        }

    });

    & 'putty' $parms
}

