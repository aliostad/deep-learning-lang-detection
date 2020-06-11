function Get-TargetResource
{
	[OutputType([System.Collections.Hashtable])]
    param(	
        [parameter(Mandatory)]
        [ValidateSet("On", "Off")]
        [string] $State
    )

    $CurrentState = "OFF" 
    if( netsh advfirewall show allprofiles | Select-String state | Select-String ON)
    {
        $CurrentState = "ON" 
    }
    else
    {
        $CurrentState = "OFF" 
    }

    Write-Output @{State = $CurrentState}
}

function Set-TargetResource
{
    param(	
        [parameter(Mandatory)]
        [ValidateSet("On", "Off")]
        [string] $State
    )

    netsh advfirewall set allprofiles state $State
   
}

function Test-TargetResource
{
    [OutputType([Boolean])]
    param(	
        [parameter(Mandatory)]
        [ValidateSet("On", "Off")]
        [string] $State
    )

    $CurrentState = "OFF" 
    if( netsh advfirewall show allprofiles | Select-String state | Select-String ON)
    {
        $CurrentState = "ON" 
    }
    else
    {
        $CurrentState = "OFF" 
    }   

    Write-Output ($State -eq $CurrentState)
}

Export-ModuleMember -Function *-TargetResource

