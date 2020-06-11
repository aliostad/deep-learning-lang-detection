$ErrorActionPreference = "Continue";

$vm_name= $%id%VmName%id%;

####################################################################################################
#Global Counters
#########################################################
$BackupFailure = 0;
$BackupSuccess = 0;
$BackupWarning = 0;
$CopyFailure = 0;
$CopySuccess = 0;
$CopyWarning = 0;
#######################################################################################################
#Check Veeam and plugin Installed

$ServiceName = 'Veeam Backup Service';
$VeeamService = Get-Service -Name $ServiceName;

if($VeeamService -ne $null)
{
    if ($VeeamService.Status -ne 'Running' ){
        $ErrorActionPreference = "Continue" ;
        Write-Error  'Veeam Backup Service is not Running - Full Error is:';
        };
    }
else {
    $ErrorActionPreference = "Continue" ;
    Write-Error  'Veeam Backup Service is not Installed - Full Error is:';
};


try 
 { 
Add-PSSnapin VeeamPSSnapIn -ErrorVariable scriptError ; 
}
catch
{
 $ErrorActionPreference = "Continue" ;
 Write-Warning "Unable to load the VeeamPSSnapIn make sure you have the plugin is registered with powershell  - Full Error is:";
 exit 101;
};

if ($scriptError -ne $null )
{
$ErrorActionPreference = "Continue" ;
Write-Warning 'Unable to load the VeeamPSSnapIn make sure you have the plugin is registered with powershell - Full Error is:';
};

###########################################################################################

#####################################
###Check Input Param

if ($vm_name -eq $null) {
	Write-Warning "Please input the name of the VM you would like to monitor. ";
};


###
# Find all BackupJobs that completed in the last 24 hours.  Do the same for Copy Sessions
$BackupSessions = (Get-VBRBackupSession | ? {$_.JobType -like "Backup" -And $_.EndTime -ge (Get-Date).AddHours(-24)}) | Get-VBRTaskSession;
$CopySessions = (Get-VBRBackupSession | ? {$_.JobType -like "BackupSync" -And $_.EndTime -ge (Get-Date).AddHours(-24)}) | Get-VBRTaskSession;

$Vm = Find-VBRViEntity | ? {$_.Name -like $vm_name};
$VmDiscName = $Vm.Name;
$VmId = $Vm.Id;
$VmHost = $Vm.VmHostName;
# Find any backup sessions this VM has been a part of in the last 24 hours
$VmBackupSessions = $BackupSessions | ? {$_.Name -like $VmDiscName};
$SessionCount = $VmBackupSessions.Count;
if ($SessionCount -eq 0) {Write-Warning "$VmDiscName was not part of any backup job in the last 24 hours" ; $BackupFailure++ };
ForEach ($Session in $VmBackupSessions) {
	$BackupJobResult = $Session.Status;
	$Backup_JobName = $Session.JobName;
	$BackupJobStartTime = $Session.Progress.StartTime;
	$BackupJobEndTime = $Session.EndTime;
	[int64]$Backup_JobSize = ([int64]$Session.Progress.ProcessedSize) / 1GB;
	$BackupTransferred = [math]::Round(([int64]$VmSession.Progress.TransferedSize) / 1GB,2);
	$BackupJobType = $VmSession.JobType;
	if ($BackupJobResult -like "Success") {$BackupSuccess++};
	if ($BackupJobResult -like "Warning") {$BackupWarning++};
	if ($BackupJobResult -like "Failed") {$BackupFailure++};
};
$VmCopySessions = $CopySessions | ? {$_.Name -like $VmDiscName};
$CopyCount = $VmCopySessions.Count;
if ($CopyCount -eq 0) {Write-Warning "$VmDiscName was not part of any backup copy job in the last 24 hours" ; $CopyFailure++ };
ForEach ($CopySession in $VmCopySessions) {
	$CopyJobResult = $CopySession.Status;
	$Copy_JobName = $CopySession.JobName;
	$CopyJobStartTime = $CopySession.Progress.StartTime;
	$CopyJobEndTime = $CopySession.EndTime;
	[int64]$CopyJobSize = ([int64]$CopySession.Progress.ProcessedSize) / 1GB;
	$CopyTransferred = [math]::Round(([int64]$CopySession.Progress.TransferedSize) / 1GB,2);
	$CopyJobType = $CopySession.JobType;
	if ($CopyJobResult -like "Success") {$CopySuccess++};
	if ($CopyJobResult -like "Warning") {$CopyWarning++};
	if ($CopyJobResult -like "Failed") {$CopyFailure++};
};


if ($BackupSuccess -ge 1) {
	$backup_result = 1;
	};
if ($BackupSucess -eq 0 -And $BackupFailure -eq 0 -And $BackupWarning -ge 1) {
	$backup_result = 2;
};
if ($BackupSuccess -eq 0 -And $BackupFailure -ge 1){
	$backup_result = 3;
};
if ($CopySuccess -ge 1) {
	$copy_result = 1;
};
if ($CopySucess -eq 0 -And $CopyFailure -eq 0 -And $CopyWarning -ge 1) {
	$copy_result = 2;
};	
if ($CopySuccess -eq 0 -And $CopyFailure -ge 1){
	$copy_result = 3;
};





######################################################################
### Pass teh result to output
 $%id%vmnameoutput%id% = $VmDiscName;
 $%id%backupresult%id% = $backup_result;
 $%id%copyresult%id% = $copy_result;
 $%id%backupfailures%id% = $BackupFailure;
 $%id%backupwarnings%id% = $BackupWarning;
 $%id%copyfailures%id% = $CopyFailure;
 $%id%copywarnings%id% = $CopyWarning;
 $%id%backupjobname%id% = $Backup_JobName;
 $%id%copyjobname%id% = $Copy_JobName;
 $%id%backupjobsize%id% = $Backup_JobSize;
 $%id%backupsessions%id% = $SessionCount;
 $%id%copysessions%id% = $CopyCount;
 $%id%backuptransferGb%id% = $BackupTransferred;
 $%id%copytransferGb%id% = $CopyTransferred;
 
