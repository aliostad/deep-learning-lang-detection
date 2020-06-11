Configuration FirewallScriptResource            
{            
    Import-DscResource -ModuleName PSDesiredStateConfiguration            
    Node localhost            
    {            
        Script EnableFirewall            
        {            
            # Must return a hashtable with at least one key            
            # named 'Result' of type String            
            GetScript = {            
                Return @{            
                    Result = [string]$(netsh advfirewall show allprofiles)            
                }            
            }            
            
            # Must return a boolean: $true or $false            
            TestScript = {            
                If ((netsh advfirewall show allprofiles) -like "State*off*") {            
                    Write-Verbose "One or more firewall profiles are off"            
                    Return $false            
                } Else {            
                    Write-Verbose "All firewall profiles are on"            
                    Return $true            
                }            
            }            
            
            # Returns nothing            
            SetScript = {            
                Write-Verbose "Setting all firewall profiles to on"            
                netsh advfirewall set allprofiles state on            
            }            
        }            
    }            
}            
            
#FirewallScriptResource            
#Start-DscConfiguration -Path .\FirewallScriptResource -Wait -Verbose            
#Get-DscConfiguration         