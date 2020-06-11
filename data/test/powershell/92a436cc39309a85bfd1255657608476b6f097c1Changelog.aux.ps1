#This file will provide functions to manage and interpret changelog...


#This read the changelog.md and finds all versions in file.
#The version is in format ## X.Y.Z - (DATE)
#The return will be be this object with following properties:
	#Version: The version string
	#Date: the date of version
Function GetVersions{
	$GMV =(GetGMV)
	
	$Versions = @();
	
	(Get-Content $GMV.CHANGELOGFILE) | %{
	
		#Check if current line matchs the version line!
		$MatchVersionLine = $_ -match '## \[?(\d+\.\d+\.\d+)\]? - (\d{4}-\d{2}-\d{2})';
		
		if($MatchVersionLine){
			$Date = [Datetime]::ParseExact($matches[2],"yyyy-MM-dd",[Globalization.CultureInfo]::InvariantCulture);
			$Versions += New-Object PSObject -Prop @{Version=$matches[1];Date=$Date};
		}
	
	}
	
	
	
	return $Versions;
}

#This will returns all change log messages associated with a specific version. If $version is null, the most recent version will be dumped!
#The result will include this properties:
	#message:  the full message
	#group: the group: Added, Changed, Deprecated, Removed, Fixed, Security
	#component: The name of cmdlet or component the change apply to. If empty, is a change on custommssql module.
Function GetVersionChangeLog {
	param($Version = $null)
	$ErrorActionPreference = "Stop";
	$GMV = (GetGMV);
	
	#Regexes
		if($Version){
			$MatchVersionLineRegEx = "## \[?($Version)\]? - (\d{4}-\d{2}-\d{2})";
		} else {
			$MatchVersionLineRegEx = '## \[?(\d+\.\d+\.\d+)\]? - (\d{4}-\d{2}-\d{2})';
		}
		
		$AllGroups = ('Added','Changed', 'Deprecated', 'Removed', 'Fixed', 'Security' -join "|")	
		$GroupLineRegEx = "^### ($AllGroups)"
		
		$ComponentRegEx = "^- \(([^)]+)\)"
		$LinkLineRegEx = "^\[[^\]]+\]:"
	
	$VersionLineFound = $false;
	$CurrentGroup = "";
	$Ended = $false;
	$Logs = @();
	$VersionText = "";
	
	(Get-Content $GMV.CHANGELOGFILE) | %{
		
		if($Ended){
			return;
		}
		
		if($_ -match $LinkLineRegEx){ #if a link [xxxxx]:
			return;
		}
		
		if(!$_){
			return; # if empty line!
		}
		
		if($_ -match $MatchVersionLineRegEx){
			if($VersionLineFound){
				#If the VersionLine already found, then this mark end of previous version logs...
				$Ended = $true;
			} else {
				#If not found, this is start of a version that we dump!
				$VersionLineFound = $true;
				$VersionText = $matches[1];
			}
			
			return; #next line!
		}
		
		if(!$VersionLineFound){
			return; #Continue to next line!
		}
		
		#if matchs a group of changes header...
		if($_ -match $GroupLineRegEx){
			$CurrentGroup = $matches[1];
			return;
		}
	
		#If line starts with the component specifications...
		if( $_ -match $ComponentRegEx ){
			$ComponentName = $matches[1];
		} else {
			$ComponentName = "";
		}
	
		#If none of conditions above is satisfied, then get the line
		$Logs += New-Object PSObject -Prop @{message=$_;group=$CurrentGroup;component=$ComponentName;version=$VersionText}

	}
	
	return $Logs;
}