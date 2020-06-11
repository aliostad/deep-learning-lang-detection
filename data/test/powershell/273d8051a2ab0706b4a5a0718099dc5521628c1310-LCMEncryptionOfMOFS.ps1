#region configuration
configuration NewUser {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node $Allnodes.NodeName {
        user NewUser {
            UserName = $Node.Credential.UserName
            Password = $Node.Credential
            Ensure = 'Present'
        }
    }
}
#endregion

#region configdata
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            Credential = [pscredential]::new('CDCUser',(ConvertTo-SecureString -String 'Welkom01' -AsPlainText -Force))
            PSDscAllowPlainTextPassword = $true
        }
    )
}
#endregion

#region compile and show MOF
NewUser -ConfigurationData $ConfigData
psEdit .\NewUser\localhost.mof
#endregion

#region assert and show Current.mof
Start-DscConfiguration -Path .\NewUser -Wait -Verbose -Force
psEdit C:\Windows\System32\Configuration\Current.mof
#endregion