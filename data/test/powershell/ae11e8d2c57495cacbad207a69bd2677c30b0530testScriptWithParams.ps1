Configuration TestScript
{
    param (
        $ScriptMessage
    )

    Import-DscResource -Name cScriptWithParams

    Node $AllNodes.NodeName
    {
        cScriptWithParams Testing
        {
            GetScript =
            {
                @{ Name = "Testing script" }
            }
            SetScript =
            {
                Write-Verbose "Running set script"
                Write-Verbose "ScriptMessage = [$ScriptMessage]"
                Write-Verbose "globalVar = [$globalVar]"
                Write-Verbose "CommonConfigMessage = [$CommonConfigMessage]"
                Write-Verbose "NodeConfigMessage = [$NodeConfigMessage]"
            }
            TestScript =
            {
                Write-Verbose "Running test script"
                $false
            }
            cParams =
            @{ 
                globalVar = $globalVar;
                ScriptMessage = $ScriptMessage;
                CommonConfigMessage = $Node.CommonConfigMessage;
                NodeConfigMessage = $Node.NodeConfigMessage;
            }
        }
    }
}

# uncomment below to debug
#$DebugPreference = "Continue"

$globalVar = "I'm a little global var"

# test from command line
TestScript -ConfigurationData configData.psd1 -ScriptMessage "This is a script message!"
Start-DscConfiguration -Path .\TestScript -Verbose -Wait