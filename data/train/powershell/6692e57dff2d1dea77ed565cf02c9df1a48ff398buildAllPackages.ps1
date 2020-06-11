# Copyright 2016, Galactic API Team.
# Licensed under the MIT License.
# Visit https://github.com/GalacticAPI/Galactic-NuGet for details.
#
# Note: This must be run from the Scripts directory in the Galactic-NuGet repository.

param(
	[Parameter(Mandatory=$True, Position = 1)]
	[string] $packageVersion
)

# Remove all existing packages from the build directory.
ri ..\*.nupkg

# Get all the template files in the NuSpecTemplates directory.
$templates = get-childitem ..\NuSpecTemplates

# Create packages from each template.
foreach ($template in $templates) {
	# Get the name of the package from the name of the template.
	$packageName = $template.BaseName
	
	# Create the package.
	.\buildPackage.ps1 $packageName $packageVersion
}