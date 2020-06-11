properties {
  $nugetApiKey = ""

  $binRoot = "..\bin"

  $solution = "..\NHibernate.Cache.DynamicCacheBuster.sln"
  $nuspec = "..\NHibernate.Cache.DynamicCacheBuster.nuspec"

  $nuget = resolve-path "..\.nuget\nuget.exe"
}

task default -depends build-package

task clean {
  if (test-path $binRoot) {
    rm $binRoot -force -recurse
  }
}

task build -depends clean {

  exec {
    # NOTE: 1591 is XML docs.
    msbuild "$solution" /t:"Clean;Build" /p:Configuration="Release" /p:NoWarn=1591
  }

}

task build-package -depends build {
  
  mkdir $binRoot

  exec {
    & $nuget pack $nuspec -outputDirectory $binRoot
  }

}

task publish-package -depends build-package {

  exec {
    $nugetPackage = resolve-path "$binRoot\*.nupkg"
    & $nuget push "$nugetPackage" $nugetApiKey
  }

}