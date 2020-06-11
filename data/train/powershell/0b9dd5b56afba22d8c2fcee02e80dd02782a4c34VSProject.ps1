
[Reflection.Assembly]::LoadWithPartialName("Microsoft.Build.Engine") | Out-Null
[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null

# TODO: Make this work in the pipeline and also with the command-line
function Get-ProjectTransitive($fileName)
{
    $fullName = resolve-path $fileName;
    $engine = New-Object Microsoft.Build.BuildEngine.Engine;
    $project = New-Object Microsoft.Build.BuildEngine.Project($engine);
    $project.Load($fullName) | Out-Null;

    Write-Output $project;
    
    $refs = $project.GetEvaluatedItemsByName("ProjectReference");
    $refs | foreach { Get-ProjectTransitive($_.FinalItemSpec) } 
}

function Set-ProjectToolsVersion($file, $ver)
{
    # Not using the built-in XML support because I'm a snob.
    $fullName = resolve-path $file;
    $doc = [System.Xml.Linq.XElement]::Load($fullName, [System.Xml.Linq.LoadOptions]::PreserveWhitespace);

    $currentVer = $doc.Attribute("ToolsVersion").Value;
    if ($currentVer -ne $ver)
    {
        $doc.Attribute("ToolsVersion").Value = $ver;
        $doc.Save($fullName);
    }
}
