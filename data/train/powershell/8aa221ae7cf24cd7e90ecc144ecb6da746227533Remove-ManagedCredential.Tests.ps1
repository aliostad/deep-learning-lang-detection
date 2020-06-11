$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# here : /branch/tests/Poshbox.Test
. "$here\..\TestCommon.ps1"

Describe "Remove-ManagedCredential" {
    It "Removes a credential from Windows Credential Manager if it exists" {
        $target = [Guid]::NewGuid().ToString()
        $actualCreds = new-object CredentialManagement.Credential("testuser", "pass123", $target)

        Invoke-Using $actualCreds {
            $credManSave = $actualCreds.Save()

            try {
                $credManSave | Should Be $true

                Remove-ManagedCredential $target

                $actualCreds.Exists() | Should Be $false
            } finally {
                if($actualCreds.Exists()){
                    $actualCreds.Delete()
                }
            }
        }
    }

    It "Throws an exception if credential does not exist" {
        $target = [Guid]::NewGuid().ToString()
        { Remove-ManagedCredential $target } | Should Throw
    }
}
