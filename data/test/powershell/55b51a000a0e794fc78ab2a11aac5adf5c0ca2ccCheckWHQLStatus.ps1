##/***************************************
## Copyright (c) All rights reserved
##
## File: CheckWHQLStatus.ps1
##
## Authors (s)
##
##   Mike Cao <bcao@redhat.com>
##
## This file is used to run check the status of test runs 
##
## This work is licensed under the terms of the GNU GPL,Version 2.
##
##****************************************/
function local:GetScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}
	. (Join-Path (GetScriptDirectory) "Library_HCK_MachinePoolAPI.ps1" )
	. (Join-Path (GetScriptDirectory) "Library_WHQL_ENV_Parsing.ps1" )
	
	$ObjectModel1 = LoadObjectModel "microsoft.windows.Kits.Hardware.objectmodel.dll"
	$ObjectModel2 = LoadObjectModel "microsoft.windows.Kits.Hardware.objectmodel.dbconnection.dll"
	
function CheckWHQLStatus
{
	GetXMLValues
	GetKitValues
	$Project = $Manager.GetProject($ProjectName)
	$Project.GetTests() | foreach {
		$_.GetTestResults() | foreach{
			if($_.status -eq "Running")
			{
				
				Write-Host test name is $_.Name
				Write-Host task status is $_.status
				Write-Host Test is $_.Test.Name
				Write-Host Test Target is $_.Target.DriverStatus

			}
		
		}
	}	
}

. CheckWHQLStatus