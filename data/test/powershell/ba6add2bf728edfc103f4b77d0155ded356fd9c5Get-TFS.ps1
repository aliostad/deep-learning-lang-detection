function Get-Tfs2010 {
Param(
    [string] $TfsCollectionUrl = $(Throw 'serverName is required')
)
    # load the required dll to GetServer functionality from TeamFoundationServerFactory.
    Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.Client.dll"
    
    # I moved all required assemblies to RerenceAssemblies folder to easy access.
    $propertiesToAdd = (
        ('VCS', 'Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer', 'C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.VersionControl.Client.dll'),
        ('BS', 'Microsoft.TeamFoundation.Build.Client.IBuildServer', 'C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.Build.Client.dll'),
        ('GSS', 'Microsoft.TeamFoundation.Server.IGroupSecurityService', 'C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.Client.dll'),
        ('CSS', 'Microsoft.TeamFoundation.Server.ICommonStructureService','C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\ReferenceAssemblies\v2.0\Microsoft.TeamFoundation.dll')
    )
 
    # Fetch the TFS instance, but add some useful properties to make life easier
    # We will create a new object to avoid the ones in the cache.
    # Also I changed the scriptblock to "LoadFrom" rather than the original version of lazy loading "LoadWithPartialName"
    [psobject] $tfsNew=New-Object psobject
    [psobject] $tfsNew = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsCollectionUrl)
    foreach ($entry in $propertiesToAdd) {
        $scriptBlock = '
            [System.Reflection.Assembly]::LoadFrom("{1}") > $null
            $this.GetService([type]"{0}")
        ' -f $entry[1],$entry[2]
        $tfsNew | add-member scriptproperty $entry[0] $ExecutionContext.InvokeCommand.NewScriptBlock($scriptBlock) -Force
    }
    return $tfsNew
}