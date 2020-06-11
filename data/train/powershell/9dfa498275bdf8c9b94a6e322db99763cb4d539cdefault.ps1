properties{
    $build_number = "0"
    $configuration = "Debug"
    $teamcityBuild = "False"
    $chocolateyApiKey = ""
    $chocolateyApiUrl = ""
    $verbose = "False"
}

$build_dir = (Split-Path $psake.build_script_file)
$add_includes = Join-Path $build_dir "add-includes.ps1"

& $add_includes @($build_dir)

FormatTaskName (("-"*25) + "[{0}]" + ("-"*25))

Task TeamCityBuildStep -Depends PatchAssemblyInfo, UpdateCarbon, BuildSolution, Test
Task Default -Depends BuildSolution, Test
Task BuildSolution -Depends Clean, Build

Task SetupContext {
  $global:context = ContextClass -psake_build_script_dir $build_dir -relative_solution_path ..\src\PerfGen.sln -props $properties
  $global:context
}
