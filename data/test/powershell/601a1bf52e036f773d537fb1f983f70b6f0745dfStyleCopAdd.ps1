Param(
[Parameter(Mandatory=$True)]
[string]$project_path
 )
   
$doc = New-Object System.Xml.XmlDocument
$doc.Load($project_path)
$manager = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$manager.AddNamespace("tns", "http://schemas.microsoft.com/developer/msbuild/2003");
$node = $doc.SelectSingleNode("/tns:Project/tns:PropertyGroup[contains(@Condition, 'Debug')]", $manager)

if (!$node)
{ 
    write "Project file does not contain 'Debug' node"
    return
}

if (!$node.CodeAnalysisRuleSet)
{
    $codeAnalysisRuleSet = $doc.CreateElement($null, "CodeAnalysisRuleSet", "http://schemas.microsoft.com/developer/msbuild/2003")
    $node.appendChild($codeAnalysisRuleSet) > $null
    $codeAnalysisRuleSet.InnerText = "`$(SolutionDir)\External\SCodingStandards.ruleset"
    $doc.Save($project_path)
}

if (!$node.RunCodeAnalysis)
{
    $runCodeAnalysis = $doc.CreateElement($null, "RunCodeAnalysis", "http://schemas.microsoft.com/developer/msbuild/2003")
    $node.appendChild($runCodeAnalysis) > $null
    $runCodeAnalysis.InnerText = "true"
    $doc.Save($project_path)
}



if (!$node.StyleCopTreatErrorsAsWarnings)
{
    $styleCopTreatErrorsAsWarnings = $doc.CreateElement($null, "StyleCopTreatErrorsAsWarnings", "http://schemas.microsoft.com/developer/msbuild/2003")
    $node.appendChild($styleCopTreatErrorsAsWarnings) > $null
    $styleCopTreatErrorsAsWarnings.InnerText = "true"
    $doc.Save($project_path)
}

if ($node.RunCodeAnalysis -and $node.RunCodeAnalysis -ne "true")
{
    $node.RunCodeAnalysis = "true"
    $doc.Save($project_path)
}

if ($node.StyleCopTreatErrorsAsWarnings -and $node.StyleCopTreatErrorsAsWarnings -ne "true")
{
    $node.StyleCopTreatErrorsAsWarnings = "true"
    $doc.Save($project_path)
}
  
if ($node.CodeAnalysisRuleSet -ne "`$(SolutionDir)\External\CodingStandards.ruleset")
{
    $node.CodeAnalysisRuleSet = "`$(SolutionDir)\External\CodingStandards.ruleset"
    write $_.Name
    write "CodeAnalysisRuleSet is set to CodingStandards.ruleset"
    $doc.Save($project_path)
}

$node = $doc.SelectSingleNode("/tns:Project/tns:Import[contains(@Project, 'Microsoft.StyleCop.targets')]", $manager)

if (!$node)
{
	$projectNode = $doc.SelectSingleNode("/tns:Project", $manager)

    $import = $doc.CreateElement($null, "Import", "http://schemas.microsoft.com/developer/msbuild/2003")
    $import.SetAttribute("Project",  "`$(SolutionDir)\External\StyleCop\Microsoft.StyleCop.targets")

    $projectNode.appendChild($import) > $null
    $doc.Save($project_path)
}