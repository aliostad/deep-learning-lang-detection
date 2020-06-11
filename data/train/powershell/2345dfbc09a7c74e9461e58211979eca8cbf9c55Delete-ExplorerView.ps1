# Author: Mayank Kumar Singh 
# Date: Nov 18, 2015 
# Description:
#		1. Deletes the Explorer View from all the libraries 
#		2. Logs all runtime error in log file 
#   	
#   
# Notes: 
#		1. This script should not be called directly. This script will be called from an automated script dynamically.
#
# ----------------------------------------------------------------------------------

# Script parameters
param(
	[Parameter(Mandatory=$true)] [string] $SourceFilePath
)


#Global variables
$ScriptDirectoryName = "DeleteExplorerView"
$ScriptName = "Delete-ExplorerView"
$LogFileName = $CurrentDirectoryPath + "\" + $ScriptDirectoryName + "\" + $LogDirectoryName + "\" + $ScriptName + "-" + $CurrentDateTime + ".log"


# Reads site collection list from source file
function Get-SiteList($Path){
	$SiteList = $null
	try{
		Add-Log -Location $MyInvocation.MyCommand.Name -Message "Reading site list from source file..." -Detail ([String]::Empty) -Type "GENERIC"	 
		$SiteList = Import-Csv $Path -Header "Url"		
	}
	catch [Exception]{
		Add-Log -Location $MyInvocation.MyCommand.Name -Message $_.Exception.Message -Detail $_.Exception.ToString() -Type "ERROR"	 
	}
	return $SiteList
}

# # Reads the site collection and deletes the Explorer View
function Read-Webs($SiteUrl){
	$Site = $null
	try{
		$Site = Get-SPSite $SiteUrl -ErrorAction SilentlyContinue
		if( $Site -ne $null ){
			Add-Log -Location $MyInvocation.MyCommand.Name -Message "Reading site '$SiteUrl'" -Detail ([String]::Empty) -Type "GENERIC"	 
			
			foreach( $web in $Site.AllWebs )
			{
				Add-Log -Location $MyInvocation.MyCommand.Name -Message "Reading web '$($web.Url)'" -Detail ([String]::Empty) -Type "GENERIC"	 
				try
				{
					foreach ($list in ($web.Lists | ? {$_ -is [Microsoft.SharePoint.SPDocumentLibrary]})) 
            		{					
						$view = $list.Views["Explorer View"]
						if($view -ne $null){
							$list.Views.Delete($view.ID)
							Add-Log -Location $MyInvocation.MyCommand.Name -Message "Deleted view 'Explorer View' in list '$($list.Title)'" -Detail ([String]::Empty) -Type "SUCCESS"	 
						}						
					}
		
				}
				catch [Exception]{
					Add-Log -Location $MyInvocation.MyCommand.Name -Message $_.Exception.Message -Detail $_.Exception.ToString() -Type "ERROR"	 
				}
				finally{
					Dispose-Object $Web
				}
			}
		}
		else{
			Add-Log -Location $MyInvocation.MyCommand.Name -Message "Site with Url '$SiteUrl' was not found" -Detail "Site URL: $SiteUrl" -Type "ERROR"	 
		}
	}
	catch [Exception]{		
		Add-Log -Location $MyInvocation.MyCommand.Name -Message $_.Exception.Message -Detail $_.Exception.ToString() -Type "ERROR"	 
	}
	finally{
		 Dispose-Object  $Site
	}	
	
	
}


# Reads each site collection from the list
function Read-Sites($SiteList){	
	try{
		foreach ( $Site in $SiteList ){	
			If(![string]::IsNullOrEmpty($Site.Url.Trim())){
    		   Read-Webs $Site.Url.Trim()    			
            }			
		}
	}
	catch [Exception]{		
		Add-Log -Location $MyInvocation.MyCommand.Name -Message $_.Exception.Message -Detail $_.Exception.ToString() -Type "ERROR"	 
	}
}

# Main function to execute script
function Execute-GetExplorerViewDelete(){
	try{
		
		$DirectoryNames = @()
		$DirectoryNames += $CurrentDirectoryPath + "\" + $ScriptDirectoryName + "\" + $LogDirectoryName
		$DirectoryNames += $CurrentDirectoryPath + "\" + $ScriptDirectoryName + "\" + $ExportDirectoryName

		If((Delete-Directories -DirectoryPathCollection $DirectoryNames) -eq $false ){		
			Write-Host $CurrentDateTime "ERROR: Error in removing directories" -ForegroundColor Red							
			Return 
		}
	
		If((Create-Directories -DirectoryPathCollection $DirectoryNames) -eq $false ){		
			Write-Host $CurrentDateTime "ERROR: Error in creating directories" -ForegroundColor Red							
			Return 
		}
		
		Add-Log -Location $MyInvocation.MyCommand.Name -Message "Started executing script '$ScriptName.ps1'" -Detail ([String]::Empty) -Type "BLOCKSTART"	 
	
		[Array] $SiteList = [Array]( Get-SiteList $SourceFilePath )   
	
		If ( $SiteList -ne $null ){
			If( $SiteList.Count -gt 0 ){		
				Read-Sites $SiteList	
			}
			Else{
				Add-Log -Location $MyInvocation.MyCommand.Name -Message "Source file doesn't contain any records" -Detail ([String]::Empty) -Type "WARNING"	
			}
		}
		Else{
			Add-Log -Location $MyInvocation.MyCommand.Name -Message "Unable to read source file or file doesn't contain any records" -Detail "File Path: $SourceFilePath" -Type "ERROR"	
		}
	
	
	}
	catch [Exception]{		
		Add-Log -Location $MyInvocation.MyCommand.Name -Message $_.Exception.Message -Detail $_.Exception.ToString() -Type "ERROR"	 
	}
	
	Add-Log -Location $MyInvocation.MyCommand.Name -Message "Finished executing script '$ScriptName.ps1'" -Detail ([String]::Empty) -Type "BLOCKEND"	 
}


Execute-GetExplorerViewDelete



