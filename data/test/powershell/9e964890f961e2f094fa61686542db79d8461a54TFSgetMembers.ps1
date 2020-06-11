Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

Function Write-Idented($identation, [string]$text)
{
    Write-Output $text.PadLeft($text.Length + (6 * $identation)) 
}

Function List-Identities ($idService, $identation, $queryOption, $tfsIdentity, $readIdentityOptions, $ShowEmptyGroups, $ShowEmptyGroupsOnly)
{
    $identities = $idService.ReadIdentities($tfsIdentity, $queryOption, $readIdentityOptions)
    
    $identation++

    foreach($id in $identities)
    {
        if ($id.IsContainer)
        {
            if ($id.Members.Count -gt 0) 
            {
                if ($identation -lt $max_call_depth) #Safe number for max call depth
                { 
                    if (!$id.DisplayName.EndsWith("Team") -and !$ShowEmptyGroupsOnly)
                    {
                        Write-Idented $identation "Group: ", $id.DisplayName
                        List-Identities $idService $identation $queryOption $id.Members $readIdentityOptions $ShowEmptyGroups $ShowEmptyGroupsOnly
                    }
                }
                else 
                {
                    Write-Output "Maximum call depth reached. Moving on to next group or project..."
                }
            }
            else 
            {
                if ($ShowEmptyGroups -or $ShowEmptyGroupsOnly)
                {
                    if (!$id.DisplayName.EndsWith("Team"))
                    {
                        Write-Idented $identation "Group: ", $id.DisplayName
                        $identation++;
                        Write-Idented $identation "-- No users --"
                        $identation--;
                    }
                }
            }
        }
        else
        {
            if ($id.UniqueName)  {
                Write-Idented $identation "Member user: ", ($id.UniqueName + " - " + $id.GetAttribute("Mail", $null))
            }
            else {
                Write-Idented $identation "Member user: ", $id.DisplayName
            }
        }  
    }
 
    $identation--
}

Function Get-TFSGroupMembership([string] $CollectionUrlParam, [string[]] $Projects, [switch] $ShowEmptyGroups, [switch] $ShowEmptyGroupsOnly)
{
    $identation = 0
    $max_call_depth = 30
  
    $tfs
    $projectList = @()
 
    if ($CollectionUrlParam)
    {
        #if collection is passed then use it and select all projects
        $tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrlParam)
 
        $cssService = $tfs.GetService([Microsoft.TeamFoundation.Server.ICommonStructureService])
        if ($Projects)
        {
            #validate project names
            foreach ($p in $Projects)
            {
                try
                {
                    $projectList += $cssService.GetProjectFromName($p)
                }
                catch
                {
                    Write-Error "Invalid project name: $p"
                    #exit
                }
            }        
        }
        else
        {
            $projectList = $cssService.ListAllProjects()
        }
    }
    else
    {
        #if no collection specified, open project picker to select it via gui
        $picker = New-Object Microsoft.TeamFoundation.Client.TeamProjectPicker([Microsoft.TeamFoundation.Client.TeamProjectPickerMode]::MultiProject, $false)
        $dialogResult = $picker.ShowDialog()
        if ($dialogResult -ne "OK")
        {
            #exit
        }
 
        $tfs = $picker.SelectedTeamProjectCollection
        $projectList = $picker.SelectedProjects
    }
 
 
    try 
    {
        $tfs.EnsureAuthenticated()
    }
    catch 
    {
        Write-Error "Error occurred trying to connect to project collection: $_ " 
        #exit 1
    }
 
    $idService = $tfs.GetService("Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService")
 
    Write-Output ""
    Write-Output "Team project collection: " $CollectionUrlParam
    Write-Output ""
    Write-Output "Membership information: "
 
    $identation++
 
    foreach($teamProject in $projectList)
    {        
        Write-Output ""
        Write-Idented $identation "Team project: ",$teamProject.Name 
    
        foreach($group in $idService.ListApplicationGroups($teamProject.Name,
                                                           [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::ExtendedProperties))
        {
            List-Identities $idService $identation ([Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Direct) $group.Descriptor ([Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::ExtendedProperties) $ShowEmptyGroups $ShowEmptyGroupsOnly
        } 
    }
 
    $identation = 1
 
    Write-Output ""
    Write-Output "Users that have access to this collection but do not belong to any group:"
    Write-Output ""
 
    $validUsersGroup =  $idService.ReadIdentities([Microsoft.TeamFoundation.Framework.Common.IdentitySearchFactor]::AccountName,
                                                  "Project Collection Valid Users",
                                                  [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Expanded,
                                                  [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::ExtendedProperties)
 
    foreach($member in $validUsersGroup[0][0].Members)
    {
        $user = $idService.ReadIdentity($member, 
                                        [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Expanded,
                                        [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::ExtendedProperties)
 
        if ($user.MemberOf.Count -eq 1 -and -not $user.IsContainer)
        {
            if ($user.UniqueName) {
                Write-Idented $identation "User: ", $user.UniqueName
            }
            else  {
                Write-Idented $identation "User: ", $user.DisplayName
            }
        }
    }
} 

Clear-Host

$ServerUri = "http://yourserverName here:8080/tfs/"

$tfsServer = [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($ServerUri)
$tfsServer.EnsureAuthenticated()

$collectionNodes = $tfsServer.CatalogNode.QueryChildren([Guid[]] [Microsoft.TeamFoundation.Framework.Common.CatalogResourceTypes]::ProjectCollection, $FALSE, [Microsoft.TeamFoundation.Framework.Common.CatalogQueryOptions]::None)

foreach ($node in $collectionNodes)
{
    Write-Output $("COLLECTION: " + $node.Resource.DisplayName)
    Get-TFSGroupMembership $($ServerUri + $node.Resource.DisplayName) -ShowEmptyGroups
}
