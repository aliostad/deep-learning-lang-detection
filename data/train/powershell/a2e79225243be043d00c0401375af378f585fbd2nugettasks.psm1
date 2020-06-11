Task NugetExists -Depends SetupContext {

  $global:context.nuget_file = Join-Path "$($global:context.build_dir)" NuGet.exe

  if (Test-Path $global:context.nuget_file){
    return
  }

  ((new-object net.webclient).DownloadFile('http://www.nuget.org/nuget.exe', $global:context.nuget_file))
}

Task NugetPack -Depends NugetExists {
    if (!(test-path $global:context.nuget_artifacts_dir))
    {
        mkdir $global:context.nuget_artifacts_dir | out-null
    }

    $global:context.solution_context.Solution.Projects | where { $_.NugetSpec -ne $null } | % {
        Write-Host $global:context.nuget_file @("pack"; $_.NugetSpec.Path; "-Properties" , "version_number=$($global:context.build_version);build_output=$($global:context.build_artifacts_dir)")
        & $global:context.nuget_file @("pack"; $_.NugetSpec.Path; 
            "-OutputDirectory", "$($global:context.nuget_artifacts_dir)"
            "-Properties" , "version_number=$($global:context.build_version);build_output=$($global:context.build_artifacts_dir)")
    }
}

Task NugetPublish -Depends NugetExists, NugetPack {
    $global:context.solution_context.Solution.Projects | where { $_.NugetSpec -ne $null } | % {
        $nugetFile = "$($global:context.nuget_artifacts_dir)\$($_.Name).$($global:context.build_version).nupkg"
        Write-Host Publishing: $nugetFile
        if ($global:context.verbose)
        {
            Write-Host $global:context.nuget_file @("push"; $nugetFile; 
            "-Source"; $context.nuget_api_url;
            "-ApiKey"; $context.nuget_api_key)
        }
        & $global:context.nuget_file @("push"; $nugetFile; 
            "-Source"; $context.nuget_api_url;
            "-ApiKey"; $context.nuget_api_key)
    }
}