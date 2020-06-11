# $Id: archive_logs.PS1,v 1.10 2008/12/01 19:53:17 powem Exp $
# Purpose:  Manage log files
# $Date: 2008/12/01 19:53:17 $

############################################################################
# This script moves files from the SDC share to an archiving share.        #
# After it copies the files from SDC to the archive, it checks for the     #
# existence of the copies and then deletes the originals if the copies are #
# verified to exist.                                                       #
# Set the location of storage and SDC shares below. The number of days     #
# prior to today's date that should be kept on SDC defaults to 3.  Pass in # 
# a negative number on the command line to override this value.            #
# Usage:  archive_logs.ps1      == archive logs older than 3 days          #  
#         archive_logs.ps1 -30  == archive logs older than 30 days         #
############################################################################

# ============================== Globals ==================================#

# set the time period prior to which logs should be archived.  Always a negative
# number of days.
param([double]$archiveLag = -3);

# location of the SDC share.
[string]$SdcStorage = "\\ctpowem01\share\logs\test1";
# location of the WebTrends log archive share.
[string]$WtStorage = "\\ctpowem01\share\logs\test2";
# Can't set a String in PS to $null, it will be coerced to "".
[string]$errPath="";

if ((Test-Path $SdcStorage) -eq $FALSE){ $errPath = "(Origin) " + $SdcStorage; }
elseif ((Test-Path $WtStorage) -eq $FALSE) {$errPath = "(Destination) " + $WtStorage; }

if ($errPath -ne ""){ Throw (New-Object system.IO.DirectoryNotFoundException); }

trap [System.IO.DirectoryNotFoundException] {
	Write-Host -foregroundcolor Red "Exception: $_ ";
	Write-Host -foregroundcolor Red "Bad path:  $errPath";
	exit 1;
}

# Get today's date, add the lag factor and convert date to string in given format.
$archiveDateString = ((Get-Date).AddDays($archiveLag)).toString("yyyy-MM-dd");
# Create a Regex Object for filename comparisons based on date string
[string]$re = "dcs-(\d{4}-\d{2}-\d{2})";
$dateRE = New-Object System.Text.RegularExpressions.Regex($re);

#========================= Function Definitions ===============================#

# ---------------------------------------------------------------------------------
# Determine whether log file is ready for archiving, based on the date in the name.
# isArchiveDate returns true if the file is past its sell-by date.
# Sample log name: dcsw8sdyem6tjrknu2zxntvm8_2o5p-dcs-2008-05-30-17-05802-emsa905z.log
function isArchiveDate([string]$fileName){

	$status = $FALSE;
	$dateMatch = [regex]::Match($fileName,$dateRE);
	$fileDateString = $dateMatch.Groups.Item(1).Value;
	
	if ($fileDateString -lt $archiveDateString){ $status = $TRUE; }
	return $status;
}

# ---------------------------------------------------------------------------------
# delete each file in the original directory that has a corresponding copy in
# the target.
function removeDuplicateFiles(){
	$srcList = Get-ChildItem -Recurse $SdcStorage -Include "*.log";
	$destListNames = @(Get-ChildItem -Name $WtStorage -Include "*.log");
	
	$dupeCount = 0;
	
	if ($srcList -eq $null){
		$errPath = $SdcStorage;
		Throw New-Object System.IO.FileNotFoundException;
	}
	if ($destListNames -eq $null){
		$errPath = $WtStorage;
		Throw New-Object System.IO.FileNotFoundException;
	}
	
	foreach ($file in $srcList){
		for($i=0; $i -lt $destListNames.length; $i++){
			if ($file.Name.Equals($destListNames[$i])){
				Remove-Item $file.FullName;	
				$dupeCount++;
				break;
			}
		}
		# Write-Host $file.Name;
	}
	Write-Host $dupeCount " files deleted.";
	
	trap [System.IO.FileNotFoundException] {
		Write-Host $_.Exception.Message;
		Write-Host "Path: $errPath";
		exit 1;
	}
}

# ============================= Processing ================================ #
# do the work using an anonymous function / scriptblock
&{
	$srcList = Get-ChildItem -Recurse $SdcStorage -Include "*.log";

	if ($srcList -eq $null) {
		$errPath = "`$srcList is null.";
		Throw (New-Object System.IO.FileNotFoundException);
	}

	foreach ($file in $srcList){

		if ((isArchiveDate($file.Name) -eq $TRUE) -and 
			($file.Extension -eq ".log"))
		{
			# Copy-Item -LiteralPath $file.FullName -Destination $WtStorage;
			# Write-Host $file.FullName " copied to "`n$WtStorage;
			Move-Item -LiteralPath $file.FullName -Destination $WtStorage;
			Write-Host $file.FullName " moved to "`n$WtStorage;
		}
		else { Write-Host "Skipping... " $file.Name; }
	}
	# after copy, remove originals
	# removeDuplicateFiles;
	
	trap [System.IO.FileNotFoundException] {
		Write-Host -foregroundcolor Red "Exception: $_ ";
		Write-Host -foregroundcolor Red "Bad path:  $errPath";
		exit 1;
	}
}
# =========================== End Processing ============================== #