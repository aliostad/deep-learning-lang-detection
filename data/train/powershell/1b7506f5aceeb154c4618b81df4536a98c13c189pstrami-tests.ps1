Get-Module -Name pstrami | Remove-Module

$fullPathIncFileName = $MyInvocation.MyCommand.Definition
$currentScriptName = $MyInvocation.MyCommand.Name
$currentExecutingPath = $fullPathIncFileName.Replace("\$currentScriptName", "")

Import-Module (resolve-path "$currentExecutingPath\..\pstrami\pstrami.psm1")
Function Test.Can_load_config_file() {
    #Arrange
    #Act
    Load-Configuration  "$currentExecutingPath\..\pstrami\pstrami.config.ps1"
	$Actual = Get-Environments
    
    #NOTE: This only works if there are environments defined
    
    #Assert
    if($Actual -eq $null) {
		throw ("environment did not load")
	}	
}

Test.Can_load_config_file
