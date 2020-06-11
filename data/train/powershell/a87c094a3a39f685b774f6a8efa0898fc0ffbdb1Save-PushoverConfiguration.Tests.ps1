$ModuleName = Split-Path (Resolve-Path "$PSScriptRoot\..\" ) -Leaf
$ModuleManifest = Resolve-Path "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"

Import-Module $ModuleManifest

InModuleScope PSPushover {
    $ConfigPath = 'testdrive:\Pushover.xml'
    Describe 'Save-PushoverAPIInformation' {
        
        Context 'Configration Saving' {
            Save-PushoverAPIInformation -UserKey 'ExampleUserKey' -AppToken 'ApplicationToken'
            It 'UserKey' {
                Import-Clixml $ConfigPath | Select-Object -ExpandProperty UserKey | Should be 'ExampleUserKey'
            }
            It 'AppToken' {
                Import-Clixml $ConfigPath | Select-Object -ExpandProperty AppToken | Should be 'ApplicationToken'
            }
        }

        Context 'Argument Validation' { 
            It 'No UserKey' {
                { Save-PushoverAPIInformation -UserKey $null -AppToken 'ApplicationToken' } | Should Throw
            }

            It 'No App Token' {
                { Save-PushoverAPIInformation -UserKey 'ExampleUserKey' -AppToken $null } | Should Throw
            }
        }
        
    }
}

Remove-Module $ModuleName