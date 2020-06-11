function Get-CurrentTfsCollectionUri {
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualStudio.TeamFoundation") | Out-Null
	
    if ($dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $tfs.ActiveProjectContext.DomainUri 
    }
}

function Get-CurrentTfsProjectName {
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualStudio.TeamFoundation") | Out-Null
	
    if ($dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $tfs.ActiveProjectContext.ProjectName
    }
}

function Get-TfsProjectNames {
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualStudio.TeamFoundation") | Out-Null
	
    if ($dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
		$TfsCollectionUri = $tfs.ActiveProjectContext.DomainUri
		
		[psobject]$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsCollectionUri)
		$wit = $tfs.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])

		return $wit.Projects
    }
}

function Get-WorkItemTypes {
    param(
        [parameter(Mandatory = $false)]
        [string]$TfsCollectionUri,
        [parameter(Mandatory = $false)]
        [string]$Project
    )

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualStudio.TeamFoundation") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore") | Out-Null
    
    if ($TfsCollectionUri -ne $null -and $dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $TfsCollectionUri = $tfs.ActiveProjectContext.DomainUri
    }

    if ($Project -eq $null -ne $null -and $dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $Project = $tfs.ActiveProjectContext.ProjectName
    }

    [psobject]$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsCollectionUri)
    $wit = $tfs.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])

    return $wit.Projects[$Project].WorkItemTypes
}

function Add-WorkItem {
    param(
        [parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Title,
        [parameter(Mandatory = $false)]
        [string]$Description,
        [parameter(Mandatory = $false)]
        [string]$WorkItemType = "Task",
        [parameter(Mandatory = $false)]
        [string]$TfsCollectionUri,
        [parameter(Mandatory = $false)]
        [string]$Project
    )

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualStudio.TeamFoundation") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore") | Out-Null
    
    if ($TfsCollectionUri -ne $null -and $dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $TfsCollectionUri = $tfs.ActiveProjectContext.DomainUri
    }

    if ($Project -eq $null -ne $null -and $dte -ne $null) {
        $tfs = $dte.GetObject("Microsoft.VisualStudio.TeamFoundation.TeamFoundationServerExt")
        $Project = $tfs.ActiveProjectContext.ProjectName
    }

    [psobject]$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsCollectionUri)
    $wit = $tfs.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])

    $workItem = new-object Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItem($wit.Projects[$Project].WorkItemTypes[$WorkItemType])
    $workItem.Title = $Title
    if ($Description -ne $null) {
        $workItem.Item("System.Description") = $Description
    }
    $workItem.Save()
}

Register-TabExpansion 'Add-WorkItem' @{
    'Title' = { 
        "Implement feature X",
        "Verify bug Y"
    }
	'Description' = { 
		 "Please implement feature X",
        "Bug Y has not been verified yet. Please take care of it."
    }
	'WorkItemType' = { Get-WorkItemTypes | Select -ExpandProperty Name }
	'TfsCollectionUri' = { Get-CurrentTfsCollectionUri }
	'Project' = { Get-TfsProjectNames | Select -ExpandProperty Name }
}

Export-ModuleMember -Function *