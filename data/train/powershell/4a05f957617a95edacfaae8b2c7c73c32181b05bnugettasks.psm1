Task NugetExists -Depends SetupContext {

  $global:context.nuget_file = Join-Path "$($global:context.build_dir)" NuGet.exe

  if (Test-Path $global:context.nuget_file){
    return
  }

  ((new-object net.webclient).DownloadFile('http://www.nuget.org/nuget.exe', $global:context.nuget_file))
}

Task NugetPack -Depends NugetExists {
    Import-Module "$($global:context.build_dir)\builtmodules\Crane.PowerShell.dll"
    Invoke-CraneNugetPackAllProjects $global:context.solution_context -BuildOutputPath  $global:context.build_artifacts_dir -NugetOutputPath  $global:context.nuget_artifacts_dir -Version $global:context.build_version | % {
        $_.StandardOutput
    }
}

Task NugetPublish -Depends NugetExists, NugetPack {
    Import-Module "$($global:context.build_dir)\builtmodules\Crane.PowerShell.dll"
    Invoke-CraneNugetPublishAllProjects $global:context.solution_context -NugetOutputPath $global:context.nuget_artifacts_dir -Version $global:context.build_version -Source $global:context.nuget_api_url -ApiKey $global:context.nuget_api_key | % {
        $_.StandardOutput
    }
}