param($installPath, $toolsPath, $package, $project) 

[System.Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null

<#
	Need to locate the package manifest and add a solution
	dependency.  
 #>

 
$solutionId = "8007a5f3-e5b3-4121-a64d-b3ba3e5dc174"
$path = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($project.FileName), "Package\Package.Template.xml")
$xml = [System.Xml.Linq.XDocument]::Load($path)

# get a reference to the default namespace
$ns = $xml.Root.GetDefaultNamespace()


$dependencies = $xml.Root.Element($ns + "ActivationDependencies")

if($dependencies -ne $null) {
 
    $dependency = $dependencies.Elements($ns + "ActivationDependency") `
        | ? { $_.Attribute("SolutionId") -ne $null } `
        | ? { $_.Attribute("SolutionId").Value -eq $solutionId }

    if($dependency -ne $null) {

        $dependency.Remove()

    }

}

$xml.Save($path)
