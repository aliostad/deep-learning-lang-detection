
trap {
    &$TrapHandler
}


function Show-Environment {
    foreach ($item in (Get-ChildItem Env:)) {
        Write-Log ("'{0}' --> '{1}'" -f $item.Name, $item.Value)
    }
}


function Install-SqlServerForAOAG {
    param (
        # Path to folder where msi files for additional SQL features are located
        [String] $SetupRoot = '',

        # Path to folder where msi files for additional SQLPS module are located
        [String] $SqlpsSetupRoot = '',

        [String] $MuranoFileShare = '',

        # (REQUIRED) Domain name
        [String] $SQLServiceUserDomain = 'fc-acme.local',

        # (REQUIRED) User name for the account which will be used by SQL service
        [String] $SQLServiceUserName = 'Administrator',

        # (REQUIRED) Password for that user
        [String] $SQLServiceUserPassword = 'P@ssw0rd',

        [Switch] $UpdateEnabled
    )
    begin {
        Show-InvocationInfo $MyInvocation
    }
    end {
        Show-InvocationInfo $MyInvocation -End
    }
    process {
        trap {
            &$TrapHandler
        }

        if ($MuranoFileShare -eq '') {
            $MuranoFileShare = [String]([Environment]::GetEnvironmentVariable('MuranoFileShare'))
            if ($MuranoFileShare -eq '') {
                throw "Unable to find MuranoFileShare path."
            }
        }
        Write-LogDebug "MuranoFileShare = '$MuranoFileShare'"

        if ($SetupRoot -eq '') {
            $SetupRoot = [IO.Path]::Combine("$MuranoFileShare", 'Prerequisites\SQL Server\2012')
        }
        Write-LogDebug "SetupRoot = '$SetupRoot'"

        $ExtraOptions = @{}

        if ($UpdateEnabled) {
            $ExtraOptions += @{'UpdateEnabled' = $true}
        }
        else {
            $ExtraOptions += @{'UpdateEnabled' = $false}
        }

        $null = New-SQLServerForAOAG `
            -SetupRoot $SetupRoot `
            -SQLSvcUsrDomain $SQLServiceUserDomain `
            -SQLSvcUsrName $SQLServiceUserName `
            -SQLSvcUsrPassword $SQLServiceUserPassword `
            -ExtraOptions $ExtraOptions
    }
}
