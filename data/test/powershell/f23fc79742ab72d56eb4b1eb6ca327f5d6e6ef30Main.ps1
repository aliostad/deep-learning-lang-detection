<#
/******************************************************************************
 * VERITAS:    Copyright (c) 2017 Veritas Technologies LLC.
 * This software is licensed as described in the file LICENSE which is part of this repository    
 *****************************************************************************/
#>
#This function loads required modules for script execution 

function LoadModules
{
    $fqmn = "Main.ps1:LoadModules"
    try
    {
       
        #------------------------------------
        # Load BEMCLI module
        #------------------------------------
      		
		$ReturnValue = LoadBEMCLIModule
	
        $path =".\BEMCLIScripts\Alerts.psm1"
        import-module -name $path -Force       

        $path =".\BEMCLIScripts\Jobs.psm1"
        import-module -name $path -Force

        $path =".\BEMCLIScripts\JobHistory.psm1"
        import-module -name $path -Force
	
        $path =".\BEMCLIScripts\MediaServer.psm1"
        import-module -name $path -Force
    }
    catch
    {
        $ErrDetail = "Exception occurred loading modules." + $_.Exception.ToString()
       
    }
    
}


# This function loads BEMCLI module from BEInstallation Path

function LoadBEMCLIModule
{
    $fqmn = "Main.ps1:LoadBEMCLIModule"
    try
    {    
       
	    #to do : check how to fetch BE version at runtime. 
        $BERegKey = "HKLM:\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\14.0\Install"
        #Reading registry key for 14.0 BE Installation Path

		if (Test-Path $BERegKey)
        {
         #Reading registry key for 14.0 BE Installation Path

            $BERegPath = Get-ItemProperty $BERegKey
        }                
       
        if(($BERegPath -eq $null) -or ($BERegPath.Path -eq $null) -or ($BERegPath.Path -eq ""))
		{
			$BERegKey = "HKLM:\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\14.1\Install"
			
			if (Test-Path $BERegKey)
            {
			#Reading registry key for 14.1 BE Installation Path
			
			    $BERegPath = Get-ItemProperty $BERegKey
            }
		}
		
	   if(($BERegPath -eq $null) -or ($BERegPath.Path -eq $null) -or ($BERegPath.Path -eq ""))
		{
			$BERegKey = "HKLM:\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\14.2\Install"			
            if (Test-Path $BERegKey)
            {
			 #Reading registry key for 14.2 BE Installation Path			
			    $BERegPath = Get-ItemProperty $BERegKey
            }
		}
		        
		
         if(($BERegPath -eq $null) -or ($BERegPath.Path -eq $null) -or ($BERegPath.Path -eq ""))
		{
			$BERegKey = "HKLM:\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\16.0\Install"
			
			if (Test-Path $BERegKey)
            {
			#Reading registry key for 16.0 BE Installation Path
			
			    $BERegPath = Get-ItemProperty $BERegKey
            }
		}       

        #append BEMCLI module path with BE installation path 
        $BEMCLIModulePath = $BERegPath.Path + "Modules\BEMCLI" 

        #Loading BEMCLI module from path
        Import-Module -name $BEMCLIModulePath

      
    }
    catch [System.Exception]
    {
        $ErrDetail = "Exception occurred loading BEMCLI module" + $_.Exception.ToString()
       
    }
}

#Calling LoadModules function
LoadModules 

