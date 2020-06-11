param($installPath, $toolsPath, $package, $project)

function GetAllProjectItemsUnder($parent)
{
    $items = @($parent.ProjectItems | ForEach { $_ })

	foreach ( $item in $parent.ProjectItems )
	{
		$items = $items + @(GetAllProjectItemsUnder $item)
	}

	$items
}

function GetAllProjectItems()
{
	GetAllProjectItemsUnder $project
}

function SetBuildPropertiesForFile($file, $buildAction, $copyOption)
{
    Write-Host "Setting build properties for file $($file.Name) to: $buildAction, $copyOption"
	$file.Properties.Item("BuildAction").Value = $buildAction
	$file.Properties.Item("CopyToOutputDirectory").Value = $copyOption
}

function SetBuildProperties($wildcard, $buildAction, $copyOption)
{
	$projectItems | Where { $_.Name -like $wildcard } | `
		ForEach { SetBuildPropertiesForFile $_ $buildAction $copyOption }
}


# http://stackoverflow.com/a/7427431/79820
$buildActionNone = 0        
$buildActionContent = 2

# http://nuget.codeplex.com/discussions/252412
$doNotCopy = 0
$copyAlways = 1             

$projectItems = GetAllProjectItems

SetBuildProperties "build_marker.txt" $buildActionNone $copyAlways
SetBuildProperties "Web.*.config" $buildActionContent $doNotCopy
SetBuildProperties "*.ps1" $buildActionContent $doNotCopy
