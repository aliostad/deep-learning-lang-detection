# See:
# http://www.windowsitpro.com/article/windows-server/windows-firewall-netsh-commands-142324
# http://blogs.technet.com/b/jamesone/archive/2009/02/18/how-to-manage-the-windows-firewall-settings-with-powershell.aspx
# http://blogs.msdn.com/b/tomholl/archive/2010/11/08/adding-a-windows-firewall-rule-using-powershell.aspx

Function Get-FireWallRule
{
    Param ($Name, $Direction, $Enabled, $Protocol, $profile, $action, $grouping)

    $rules=(New-object –comObject HNetCfg.FwPolicy2).rules

    If ($name)      {$rules= $rules | where-object {$_.name     –like $name}}
    If ($direction) {$rules= $rules | where-object {$_.direction  –eq $direction}}
    If ($Enabled)   {$rules= $rules | where-object {$_.Enabled    –eq $Enabled}}
    If ($protocol)  {$rules= $rules | where-object {$_.protocol  -eq $protocol}}
    If ($profile)   {$rules= $rules | where-object {$_.Profiles -bAND $profile}}
    If ($Action)    {$rules= $rules | where-object {$_.Action     -eq $Action}}
    If ($Grouping)  {$rules= $rules | where-object {$_.Grouping -Like $Grouping}}

    $rules

}

Function FirewallRule-Exists
{
	param(
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$name
	)
    
    $rule = (Get-FireWallRule -Name $name)
    if (($rule) -and ($rule.Name -eq $name))
    {
        return $true
    }
    
    return $false
}

Function CreateOrUpdate-FirewallPortRule
{
	param(
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$name,
        
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$direction,
        
        [Parameter(Position=2, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$localPorts,
        
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$protocol,
        
        [Parameter(Position=4, Mandatory=$False, ValueFromPipeline=$True)]
		[string]$action = "allow"
	)
    
    if (((FirewallRule-Exists -Name $name) -eq $true))
    {
        Remove-FirewallPortRule -Name $name -Direction $direction -Protocol $protocol -LocalPorts $localPorts
    }
    
    $command = "netsh advfirewall firewall add rule name=`"$name`" dir=$direction action=$action protocol=$protocol localport=`"$localPorts`""
    Invoke-Expression $Command    
}

Function CreateOrUpdate-FirewallProgramRule
{
	param(
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$name,
        
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$direction,
        
        [Parameter(Position=2, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$program,
        
        [Parameter(Position=3, Mandatory=$False, ValueFromPipeline=$True)]
		[string]$action = "allow"
	)
    
    if (((FirewallRule-Exists -Name $name) -eq $true))
    {
        Remove-FirewallProgramRule -Name $name -Direction $direction -Program $program
    }
    
    $command = "netsh advfirewall firewall add rule name=`"$name`" dir=$direction action=$action program=`"$program`""
    Invoke-Expression $Command
}

Function Remove-FirewallPortRule
{
	param(
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$name,
        
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$direction,        
        
        [Parameter(Position=2, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$protocol,        
        
        [Parameter(Position=3, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$localPorts
	)
    
    if ((FirewallRule-Exists -Name $name) -eq $false)
    {
        return $false
    }
    
    $command = "netsh advfirewall firewall delete rule name=`"$name`" dir=$direction protocol=$protocol localport=`"$localPorts`""
    Invoke-Expression $Command
    
    return $true
}

Function Remove-FirewallProgramRule
{
	param(
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$name,
        
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$direction,
        
        [Parameter(Position=2, Mandatory=$True, ValueFromPipeline=$True)]
		[string]$program
	)
    
    if ((FirewallRule-Exists -Name $name) -eq $false)
    {
        return $false
    }
    
    $command = "netsh advfirewall firewall delete rule name=`"$name`" dir=$direction program=`"$program`""
    Invoke-Expression $Command
    
    return $true
}