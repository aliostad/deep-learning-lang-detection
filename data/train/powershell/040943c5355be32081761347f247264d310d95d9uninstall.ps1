param($installPath, $toolsPath, $package, $project)


if($project -eq $null)
{
	$project = Get-Project
}


$project.Save()

$projectXml = New-Object System.Xml.XmlDocument
$projectXml.Load($project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'

$imports = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\Microsoft.TypeScript.Default.props')]" $projectXml -Namespace @{msb = $namespace}
if ($imports)
{
    foreach ($import in $imports)
    {
        $import.Node.ParentNode.RemoveChild($import.Node)
    }
}

$imports2 = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\Microsoft.TypeScript.targets')]" $projectXml -Namespace @{msb = $namespace}
if ($imports2)
{
    foreach ($import in $imports2)
    {
        $import.Node.ParentNode.RemoveChild($import.Node)
    }
}

$project.Save()
$projectXml.Save($project.FullName)