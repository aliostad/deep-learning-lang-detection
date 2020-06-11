function Get-ScriptDirectory
{
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value
	Split-Path $Invocation.MyCommand.Path
}
$thisDir = Get-ScriptDirectory
Write-Host 'Deleting all build-product files from Libs\JhLib..'
@(
	$thisDir + '\bin'
	$thisDir + '\obj'
	$thisDir + '\JhLib.csproj.user'
	$thisDir + '\JhLib_UnitTests\bin'
	$thisDir + '\JhLib_UnitTests\obj'
	$thisDir + '\JhLib_UnitTests\JhLib_UnitTests.suo'
	$thisDir + '\JhLib_UnitTests\JhLib_UnitTests.sln.DotSettings.user'
	$thisDir + '\JhLib_UnitTests_MsTest\bin'
	$thisDir + '\JhLib_UnitTests_MsTest\obj'
	$thisDir + '\JhLib_UnitTests_MsTest\TestResults'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp\bin'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp\obj'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp.suo'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp.sln.DotSettings.user'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp_WindowsForms\bin'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxTestApp_WindowsForms\obj'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxUnitTests\bin'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\JhMessageBoxUnitTests\obj'
	$thisDir + '\JhMessageBox\JhMessageBoxTestApp\TestResults'
) |
Where-Object { Test-Path $_ } |
ForEach-Object { Remove-Item $_ -Recurse -Force -ErrorAction Stop }


