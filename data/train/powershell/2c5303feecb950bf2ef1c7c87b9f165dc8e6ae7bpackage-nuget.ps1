Param(
	[switch]$pushLocal,
	[switch]$pushNuget,
	[switch]$cleanup
)

if (Test-Path -Path nuget-powershell) 
{
	rmdir nuget-powershell -Recurse
}
rm *.nupkg

.\nuget pack .\AccidentalFish.ApplicationSupport.Owin\AccidentalFish.ApplicationSupport.Owin.csproj
.\nuget pack .\AccidentalFish.ApplicationSupport.Owin.Azure\AccidentalFish.ApplicationSupport.Owin.Azure.csproj -IncludeReferencedProjects
.\nuget pack .\AccidentalFish.ApplicationSupport.Owin.Mvc\AccidentalFish.ApplicationSupport.Owin.Mvc.csproj -IncludeReferencedProjects
.\nuget pack .\AccidentalFish.ApplicationSupport.Owin.WebApi\AccidentalFish.ApplicationSupport.Owin.WebApi.csproj -IncludeReferencedProjects


if ($pushLocal)
{
	cp *.nupkg \LocalPackageRepository
}

if ($pushNuget)
{
	.\nuget push *.nupkg
}

if ($cleanup)
{
	rmdir nuget-powershell -Recurse
	rm *.nupkg
}
