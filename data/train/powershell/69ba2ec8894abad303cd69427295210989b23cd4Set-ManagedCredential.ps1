function Set-ManagedCredential {
    [cmdletbinding(DefaultParameterSetName="Manual")]
    param (
        [Parameter(ParameterSetName="Manual")]
        [Parameter(ParameterSetName="PSCredential")]
        [string]$Target = $(throw "missing parameter -Target"),
        [Parameter(ParameterSetName="Manual")]
        [string]$Username,
        [Parameter(ParameterSetName="Manual")]
        [string]$Password,
        [Parameter(ParameterSetName="PSCredential")]
        [PSCredential]$Credential
    )

    if($psCmdlet.ParameterSetName -eq "Manual") {
        $Username = $Username.Trim()

        if([string]::IsNullOrWhitespace($Password)) {
            $Credential = Get-Credential -Message "Enter your credentials" -Username $Username
            $Password = $Credential.Password
        }
    }



    $managedCredential = new-object CredentialManagement.Credential(`
        $Username,`
        $Password,`
        $Target)

    Invoke-Using $managedCredential {
        if(-not $managedCredential.Save()) {
            throw "Unable to save credentials!"
        }
    }
}