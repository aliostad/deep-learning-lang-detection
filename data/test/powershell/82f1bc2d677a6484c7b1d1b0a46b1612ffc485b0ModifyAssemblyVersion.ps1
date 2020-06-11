# Update versions.
param( [string]$mode = "fix", [string]$suffix = $null, [bool]$forceRebuild = $false )

$baseDirectory = ".\src"

if( $forceRebuild -or ![IO.File]::Exists( ".\tools\UpdateVersion\bin\UpdateVersion.exe" ) )
{
	& .\build.ps1 Release Rebuild
}

[Version]$version = $null
if( $versionString -ne $null )
{
	try
	{
		$version = new-object Version( $versionString )
	}
	catch { }
}
switch ( $mode )
{
	"show"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" --show
	}
	"fix"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" -b
	}
	"minor"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" -n
	}
	"major"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" -j
	}
	"beta"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" -n --suffix Beta
	}
	"rc"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" --suffix RC
	}
	"release"
	{
		& ".\tools\UpdateVersion\bin\UpdateVersion.exe" -d "$baseDirectory" --no-suffix
	}
	default
	{
		throw ( "Unknown mode `"{0}`"" -f $mode )
	}
}