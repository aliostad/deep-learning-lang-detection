param($installPath, $toolsPath, $package, $project)

# Don't support old NuGet versions as it's impractical to handle all their different sets of sematics
if ([NuGet.PackageManager].Assembly.GetName().Version -lt 1.4) 
{
	throw "Scaffolding requires NuGet (Package Manager Console) 1.4 or later"
}

function GetLoadedScaffoldingAssemblyVersion() {
	try {
		return [MyScaffolder.RepositoryScaffolder].Assembly.GetName().Version
	} catch {
		return $null
	}
}
$ScaffoldingAssemblyVersion = GetLoadedScaffoldingAssemblyVersion

if ($ScaffoldingAssemblyVersion -eq $null)
{
		# OK, Load the required dlls.
		$dllPath = Join-Path $installPath "scaffolders"
		$dllPath = Join-Path $dllPath "MyScaffolder.RepositoryScaffolder.dll"
		$packagesRoot = [System.IO.Path]::GetDirectoryName($installPath)

		if (Test-Path $dllPath) 
		{
			# Enable shadow copying so the package can be uninstalled/upgraded later
			# [System.AppDomain]::CurrentDomain.SetShadowCopyFiles()

			# Load the .NET PowerShell module.
			Import-Module $dllPath
		} 
		else 
		{
			Write-Warning ("Could not find Scaffolding module. Looked for: " + $dllPath)
		}
}