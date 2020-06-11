param($installPath, $toolsPath, $package, $project)
# $installPath is the path to the folder where the package is installed
# $toolsPath is the path to the tools directory in the folder where the package is installed
# $package is a reference to the package object.
# $project is a reference to the EnvDTE project object and represents the project the package is installed into.

$pname=$project.ProjectName
"Hello from install-clientaspnet.ps1 in $pname" | Out-Host

# this is the project type gouid of an ASP.NET MVC 4 Application type
$isMVC = (Get-MSBuildProperty "ProjectTypeGuids" -ProjectName $pname).EvaluatedValue -match "{E3E379DF-F4C6-4180-9B81-6769533ABE47}"

"isMVC=$isMVC" | Out-Host

$ourReferences = (
   "Zetbox.API",
   "Zetbox.API.Client",
   "Zetbox.API.Common",
   "Zetbox.API.Server",
   "Zetbox.Client",
   "Zetbox.Client.WPF",
   "Zetbox.Client.WPF.Toolkit",
   "Zetbox.Client.ASPNET.Toolkit"
)

foreach ($reference in $project.Object.References)
{
    if ($ourReferences -contains $reference.Name)
    {
        $refname = $reference.Name
        "Matched $refname" | Out-Host
        $reference.CopyLocal = $isMVC;
    }
}

# add the clientaspnet.targets relative to project dir
$relativeSolutionPath = [NuGet.PathUtility]::GetRelativePath($project.FullName, $dte.Solution.Properties.Item("Path").Value)
$relativeSolutionPath = [IO.Path]::GetDirectoryName($relativeSolutionPath)
$relativeSolutionPath = [NuGet.PathUtility]::EnsureTrailingSlash($relativeSolutionPath)

$importPath = ($relativeSolutionPath + ".zetbox\clientaspnet.targets")
if (! (((Get-MSBuildProject).Imports | %{ $_.ImportingElement.Project.contains(".zetbox\clientaspnet.targets")}) -contains $true)) {
	Add-Import $importPath $project.ProjectName
}
