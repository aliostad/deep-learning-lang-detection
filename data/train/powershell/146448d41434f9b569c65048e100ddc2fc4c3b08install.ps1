param ($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "Update-AssemblyBinding.psm1")

# Get the path to the current project
$projectPath = Split-Path -Parent $project.FullName

# Writing assembly redirect information 

#load the configuration file for the project
$configPath = Join-Path $projectPath "web.config"
$config = New-Object xml
$config.psbase.PreserveWhitespace = $true
$config.Load($configPath)

$config = Update-AssemblyBinding $config $installPath

# save the new bindingRedirects
$config.Save($configPath)

Remove-Module "Update-AssemblyBinding"