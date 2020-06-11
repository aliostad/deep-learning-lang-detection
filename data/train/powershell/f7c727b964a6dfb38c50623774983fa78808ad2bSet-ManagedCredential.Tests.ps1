$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# here : /branch/tests/Poshbox.Test
. "$here\..\TestCommon.ps1"

Describe "Set-ManagedCredential" {
    It "Add credential to Windows Credential Manager if it does not exist" {
        $expectedUserName = "testuser"
        $expectedPassword = "pass123"
        $target = [Guid]::NewGuid().ToString()

        Set-ManagedCredential -Target $target -UserName $expectedUserName -Password $expectedPassword

        $actualCreds = new-object CredentialManagement.Credential($expectedUserName, $expectedPassword, $target)
        Invoke-Using $actualCreds {
            $credManLoad = $actualCreds.Load()

            try {
                $credManLoad | Should Be $true
                $actualCreds.UserName | Should Be $expectedUserName
                $actualCreds.Password | Should Be $expectedPassword
            } finally {
                if($credManLoad){
                    $actualCreds.Delete()
                }
            }
        }
    }

    It "Updates an existing credential" {
        $target = [Guid]::NewGuid().ToString()

        $actualCreds = new-object CredentialManagement.Credential("foo", "bar", $target)
        Invoke-Using $actualCreds {
            $credManLoad = $actualCreds.Save()

            $expectedUserName = [Guid]::NewGuid().ToString()
            $expectedPassword = [Guid]::NewGuid().ToString()

            Set-ManagedCredential -Target $target -UserName $expectedUserName -Password $expectedPassword

            $credManLoad = $actualCreds.Load()

            try {
                $credManLoad | Should Be $true
                $actualCreds.UserName | Should Be $expectedUserName
                $actualCreds.Password | Should Be $expectedPassword
            } finally {
                if($credManLoad){
                    $actualCreds.Delete()
                }
            }
        }
    }
}
