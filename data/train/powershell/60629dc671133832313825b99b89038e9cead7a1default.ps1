$erroractionpreference = "Stop"
properties {
    $location = (get-location);
    $outdir = (join-path $location "Build");
    $bindir = (join-path $outdir "Bin");
}

task default -depends Help
task deply -depends Help


task Help {
    write-host "To Create Nuget-Packages Locally: psake.cmd 'Create:Nuget'" -ForegroundColor Magenta
}

task Check {
	# nothing
}

task Clean {
	rmdir -force -recurse $outdir -ea SilentlyContinue
}

task Rebuild -depends Clean {
    $solution = get-location;
	exec { msbuild /nologo /v:minimal /t:rebuild /p:"Configuration=Release;OutDir=$bindir/WebApiDiscovery.Net/;SolutionDir=$solution/" "Source/WebApiDiscovery.Net/WebApiDiscovery.Net.csproj" }
}
task Create:Nuget -depends Rebuild,Check {
    push-location "$bindir/"
       
    copy "$location/Krowiorsch.WebApi.Discovery.nuspec" $bindir
    
    $version = ([System.Diagnostics.FileVersionInfo]::GetVersionInfo("$bindir\WebApiDiscovery.Net\WebApiDiscovery.Net.dll").productVersion);
    ..\..\.NuGet\NuGet.exe pack "Krowiorsch.WebApi.Discovery.nuspec" /version "$version"
    
    pop-location
}

