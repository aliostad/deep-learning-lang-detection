Function Set-AppVeyorApiToken {
    
    [CmdletBinding(
        ConfirmImpact = 'High',
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    Param (
        [Parameter(
            HelpMessage = 'The value of a token from https://ci.appveyor.com/api-token.',
            Mandatory = $true
        )]
        [String]
        $Token
    )

    Begin {
        try {
            [Void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
            
            $vault = New-Object -TypeName Windows.Security.Credentials.PasswordVault -ErrorAction Stop
        } catch {
            $_
            return
        }

        try {
            if ($vault.FindAllByUserName('PSAppVeyor').Count -ne 0) {
                if ($PSCmdlet.ShouldProcess($vault, 'Setting PSAppVeyor Api Token.  There is already an Api Token present, do you wish to update the value?')) {
                    $vault.Add((New-Object -TypeName Windows.Security.Credentials.PasswordCredential -ArgumentList 'https://appveyor.com', 'PSAppVeyor', $Token))
                }
            }
        } catch {
            try {
                $vault.Add((New-Object -TypeName Windows.Security.Credentials.PasswordCredential -ArgumentList 'https://appveyor.com', 'PSAppVeyor', $Token))
            } catch {
                $_
                return
            }
        }
    }

    End {
        Remove-Variable -Name Token -Force
        
        [GC]::Collect()
    }
}
