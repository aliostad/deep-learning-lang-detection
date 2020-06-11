param(
    [string] $serverName = $(throw 'serverName is required')
)

begin
{
    # load the required dll
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")  
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Common") 
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client") 

    if ((Get-PSSnapIn -Name Microsoft.TeamFoundation.PowerShell -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin Microsoft.TeamFoundation.PowerShell
    }

    $propertiesToAdd = (
        ('VCS', 'Microsoft.TeamFoundation.VersionControl.Client', 'Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer'),
        ('WIT', 'Microsoft.TeamFoundation.WorkItemTracking.Client', 'Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore'),
        ('CSS', 'Microsoft.TeamFoundation', 'Microsoft.TeamFoundation.Server.ICommonStructureService'),
        ('GSS', 'Microsoft.TeamFoundation', 'Microsoft.TeamFoundation.Server.IGroupSecurityService')
    )
}

process
{
    # fetch the TFS instance, but add some useful properties to make life easier
    # Make sure to "promote" it to a psobject now to make later modification easier
    [psobject] $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($serverName)
    foreach ($entry in $propertiesToAdd) {
        $PropertyIsSet = Get-Member -InputObject $tfs -MemberType ScriptProperty | Where-Object {$_.Name -eq $entry[0]}
        if($PropertyIsSet -eq $null) {
            $scriptBlock = '
                    $this.GetService([type]"{0}")
            ' -f $entry[2]
            $tfs | add-member scriptproperty $entry[0] $ExecutionContext.InvokeCommand.NewScriptBlock($scriptBlock)
        }
    }
    return $tfs
}
