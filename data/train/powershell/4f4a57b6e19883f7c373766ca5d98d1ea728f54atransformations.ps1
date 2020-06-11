$Files = Get-ChildItem ".\Secured.Server\content\*.pp" -recurse -force
Foreach ($File in $Files)
	{
		(get-content $File -Raw) | foreach-object {$_ -replace "namespace Secured", 'namespace $rootnamespace$' -replace "using Secured", 'using $rootnamespace$' -replace "Secured.WebApiApplication", '$rootnamespace$.WebApiApplication' -replace 'Secured.App_Start','$rootnamespace$.App_Start' -replace 'namespace="Secured"','namespace="$rootnamespace$"' -replace 'Secured.Startup','$rootnamespace$.Startup' -replace "\[RequireHttps\]", '' -replace "(?ms)^\s+#region ExcludeFromPackage.*?#endregion", ''} | set-content $File	
  }