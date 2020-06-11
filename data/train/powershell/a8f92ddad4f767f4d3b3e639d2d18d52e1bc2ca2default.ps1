properties{
    $configuration = "Debug"
    $build_number = 0
    [switch]$teamcityBuild = $false
    $chocolateyApiKey = ""
    $chocolateyApiUrl = ""
    [switch]$verbose = $false
}

$build_dir = (Split-Path $psake.build_script_file)
$add_includes = Join-Path $build_dir "add-includes.ps1"

& $add_includes @($build_dir)

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task TeamCityBuildStep -Depends PatchAssemblyInfo, BuildSolution, Test, ChocolateyPublishPackage
Task Default -Depends BuildSolution, Test
Task BuildSolution -Depends Clean, Build

Task SetupContext {
  $global:context = ContextClass -psake_build_script_dir $build_dir -relative_solution_path "..\src\crane.sln" -props $properties
  $global:context
}

