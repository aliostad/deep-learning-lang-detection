#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: New-Entity.ps1
# Description: 
#   Creates a new entity and provides a selection dialog for entity aspects.
# Dependencies: 
#   Build-Entity.ps1
#   System.Windows.Forms
# Remarks:
#   Is used by the runner New-<profile name>.exe
#=============================================================================

#$VerbosePreference = "Continue"
$DebugPreference = "Continue"

Write-Verbose "+++ New-Entity.ps1"

$myDir = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$wfa = [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$entityName = Read-Host "Name"
if (-not $entityName)
{
	[Windows.Forms.MessageBox]::Show("The process was aborted.", "Create entity", "Ok", "Information")
	return
}

$targetDir = [IO.Path]::Combine([Environment]::CurrentDirectory, $entityName)
if (Test-Path $targetDir)
{
	$dlgResult = [Windows.Forms.MessageBox]::Show( `
		"The directory '$entityName' allready exists. Use anyway?", `
		"Create entity", "YesNo", "Question")
	if ($dlgResult -eq "No")
	{
		return
	}
}
else
{
	mkdir $targetDir | Out-Null
}

& "$myDir\Build-Entity.ps1" `
	-entityRoot $targetDir `
	-entityName $entityName `
	-promptForAspects

Write-Verbose "--- New-Entity.ps1"
