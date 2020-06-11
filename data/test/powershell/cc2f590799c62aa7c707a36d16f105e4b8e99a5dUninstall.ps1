#  Copyright (c) Adam Ralph. All rights reserved.

param($installPath, $toolsPath, $package, $project)

# save any unsaved changes before we start messing about with the project file on disk
$project.Save()

# read in project XML
$projectXml = [xml](Get-Content $project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'

#remove import nodes
$nodes = @(Select-Xml "//msb:Project/msb:Import[contains(@Project,'\packages\Nerdery.CSharpCodeStyle')]" $projectXml -Namespace @{msb = $namespace} | Foreach {$_.Node})
if ($nodes)
{
    foreach ($node in $nodes)
    {
        $node.ParentNode.RemoveChild($node)
    }
}

# remove warning nodes
$nodes = @(Select-Xml "//msb:Project//msb:StyleCopTreatErrorsAsWarnings" $projectXml -Namespace @{msb = $namespace} | Foreach {$_.Node.ParentNode.RemoveChild($_.Node)})

# save changes
$projectXml.Save($project.FullName)