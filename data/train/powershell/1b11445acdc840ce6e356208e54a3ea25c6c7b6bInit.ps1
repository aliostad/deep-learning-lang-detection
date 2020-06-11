param($installPath, $toolsPath, $package, $project)

# Get the solution's path and name
$solution = Get-Interface $dte.Solution ([EnvDTE80.Solution2])
$solutionPath = Split-Path $solution.FileName -Parent
$solutionName = Split-Path $solution.FileName -Leaf

# Generate the name of the solution after targets file and copy it in if it doesn't exist
$targetsSource = (Join-Path $toolsPath "after.sln.targets")
$targetsDestination = (Join-Path $solutionPath "after.$solutionName.targets")
if (-not (Test-Path $targetsDestination)) {
    Copy-Item $targetsSource $targetsDestination
}

# Ensure the .deploy directory exists at the root of the solution
$deployPath = Join-Path $solutionPath ".deploy"
if (-not (Test-Path $deployPath)) {
    New-Item $deployPath -ItemType Directory
}

# Copy the targets files into the .deploy directory
Copy-Item (Join-Path $toolsPath "Release.targets") $deployPath
Copy-Item (Join-Path $toolsPath "Variables.targets") $deployPath
Copy-Item (Join-Path $toolsPath "TeamBuildNumber.targets") $deployPath