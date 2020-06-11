Properties {
	$base_dir = resolve-path .\..\..\
	$packages_dir = "$base_dir\packages"
	$build_artifacts_dir = "$base_dir\build"
	$solution_name = "$base_dir\WebApiContrib.Logging.Raygun.sln"
	$nuget_exe = "$base_dir\.nuget\Nuget.exe"
}

Task Default -Depends BuildWebApiContrib, NuGetBuild

Task BuildWebApiContrib -Depends Clean, Build

Task Clean {
	Exec { msbuild $solution_name /t:Clean /p:Configuration=Release }
}

Task Build -depends Clean {
	Exec { msbuild $solution_name /t:Build /p:Configuration=Release /p:OutDir=$build_artifacts_dir\ } 
}

Task NuGetBuild -depends Clean {
	& $nuget_exe pack "$base_dir/src/WebApiContrib.Logging.Raygun/WebApiContrib.Logging.Raygun.csproj" -Build -OutputDirectory $build_artifacts_dir -Verbose -Properties Configuration=Release
}
