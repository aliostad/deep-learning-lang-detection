Function Save-AzdeProject {
    Param (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true)]
        [AzureDeploymentEngine.project]$project,
        [string]$Path,
        [switch]$force
    )

    if (!($Path))
    {
        $SavePath = Join-Path -Path $artifactpath -ChildPath "$($project.ProjectName)"
        $savepath = Join-Path -Path $SavePath -ChildPath "$($project.ProjectName).json"
         
    }
    Else
    {
        $SavePath = $Path
    }

    if (!(test-path $SavePath))
    {
        new-item $SavePath -ItemType File -Force | out-null
    }
    ElseIf ((test-path $SavePath) -and ($force))
    {
        get-item $SavePath | remove-item -Force
        new-item $SavePath -ItemType File -Force | out-null

    }

    #Todo: Better logic for not overwriting files
    $project | ConvertTo-Json -Depth 15 | Set-Content -Path $SavePath -Force
    Write-enhancedVerbose -MinimumVerboseLevel 2 -Message "Writing deployment config to $savepath"
}


Function import-AzdeProject
{
    Param ($Path)
    $jsonstring = Get-content $Path -Raw
    
    $jsonconverter = New-Object AzureDeploymentEngine.JsonFunctions
    $Deployment = $jsonconverter.ConvertToProjectFromJson($jsonstring)
    $Deployment
}


Function Import-AzdeVMConfiguration
{
    Param ($Path,$string)
    if ($string)
    {
        $jsonstring = $string
    }
    Else
    {
        $jsonstring = Get-content $Path -Raw
    }
    
    
    $jsonconverter = New-Object AzureDeploymentEngine.JsonFunctions
    $vm = $jsonconverter.ConvertToVmFromJson($jsonstring)
    $vm
}