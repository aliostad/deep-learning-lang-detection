#
# updates JOBS on windows
#

Function ExitWithMessage ($ExitMessage)
{
	Write-Host ($ExitMessage)
	Exit
}

Function CheckDistroExists ($jobsdistribution)
{
	#check, if distro is here
	if (-Not (Test-Path $jobsdistribution)) 
	{
		ExitWithMessage ("Distribution {0} doesn't exist" -f $jobsdistribution)
	} 
}

Function ExtractDistro ($jobsdistribution, $netoriuminstalldir)
{
	#extracting distribution
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($jobsdistribution, $netoriuminstalldir)
	if ($?.Equals($False))
	{
		ExitWithMessage ("Error unzipping distribution. ErrorMessage: {0}" -f $Error[0])
	}
}

Function RenameToJobsfolder ($netoriuminstalldir, $distributionname, $jobsfolder)
{
	Rename-Item -path (Join-Path -path $netoriuminstalldir -ChildPath $distributionname) -NewName $jobsfolder
	if ($?.Equals($False))
	{
		ExitWithMessage ("Could not rename extracted folder. ErrorMessage: {0}" -f $Error[0])
    }
}

Function FindJobsInstallation ($jobsserviceid)
{
	#check if JOBS windows service runs and return the path to the service exe
	$jobsservice=(gwmi win32_service|?{$_.name -eq $jobsserviceid})

	if ($jobsservice -eq $null)
	{
		ExitWithMessage ("Can't find a JOBS installation. No Service JOBS-Runtime installed")
	}

	return $jobsservice.pathname
}

Function ExtractNetoriumPath ($serviceexepath, $serviceexename)
{
    $pos=$serviceexepath.LastIndexOf($serviceexename)
	if ($pos -eq -1)
	{
		ExitWithMessage ("Couldn't find the string {0} in path {1}. Can't find the path of the JOBS installation" `
			-f $serviceexename, $serviceexepath)
	}

	$netoriuminstalldir=$serviceexepath.Substring(0, $pos - 1)
	return $netoriuminstalldir
}

Function CopyData ($jobsinstalldir, $netoriuminstalldir, $distributionname)
{
	$source=Join-Path -Path $jobsinstalldir -ChildPath "data\elasticsearch\jobs"
	$target=Join-Path (Join-Path -Path $netoriuminstalldir -ChildPath $distributionname) -ChildPath "data\elasticsearch"
	Copy-Item $source -Destination $target -Recurse
	if ($?.Equals($False))
	{
		ExitWithMessage ("Could not copy data {0} to {1}. ErrorMessage: {2}" -f $source, $target, $Error[0])
    }

	$source=Join-Path -Path $jobsinstalldir -ChildPath "etc\JOBS-Runtime-wrapper.conf"
	$target=Join-Path (Join-Path -Path $netoriuminstalldir -ChildPath $distributionname) -ChildPath "etc"
	Copy-Item $source -Destination $target -Recurse
	if ($?.Equals($False))
	{
		ExitWithMessage ("Could not copy {0} to {1}. ErrorMessage: {2}" -f $source, $target, $Error[0])
    }

	$source=Join-Path -Path $jobsinstalldir -ChildPath "bin\JOBS-Runtime-service.bat"
	$target=Join-Path (Join-Path -Path $netoriuminstalldir -ChildPath $distributionname) -ChildPath "bin"
	Copy-Item $source -Destination $target -Recurse
	if ($?.Equals($False))
	{
		ExitWithMessage ("Could not copy {0} to {1}. ErrorMessage: {2}" -f $source, $target, $Error[0])
    }
}

Function HandleServiceStartStopErrors ($processexitcode)
{
	if ($processexitcode -eq 0)
	{
		#everything is fine
		return
	}
	elseif ($processexitcode -eq -8003)
	{
		ExitWithMessage "Error starting service"
	}
	elseif ($processexitcode -eq -8004)
	{
		ExitWithMessage "Error stopping service"
	}
	else
	{
		ExitWithMessage ("Unknown error start/stop service. Exit code {0}" -f $processexitcode)
	}
}

Function StartStopService ($jobsinstalldir, $jobsserviceid, $dostart)
{
	$startstopparam
	if ($dostart -eq $True)
	{
		$startstopparam="-dostartservice"
	}
	else
	{
		$startstopparam="-dostopservice"
	}

	$startstopscript=Join-Path -path $jobsinstalldir -ChildPath "bin\servicehelper.ps1"
    $processresult = Start-Process powershell.exe -PassThru -Wait -Verb Runas -ArgumentList '-windowstyle', 'Hidden', `
	    '-File', $startstopscript, $jobsserviceid, $startstopparam

	HandleServiceStartStopErrors $processresult.ExitCode
}


###### This is the entry point to the script ######

Write-Host "`n###### Updating Netorium JOBS ######`n"

$jobsserviceid="JOBS-Runtime"
$jobsfolder="Jobs"
$serviceexename=Join-Path -Path $jobsfolder -ChildPath "bin\JOBS-Runtime-wrapper.exe"
$distributionname="jobs-distribution-0.0.25-SNAPSHOT"
$jobsdistribution=(Join-Path -Path $PSScriptRoot -ChildPath $distributionname) + ".zip"

Write-Host "checking, if distro exists"
CheckDistroExists $jobsdistribution

Write-Host "trying to find a JOBS installation"
$serviceexepath=FindJobsInstallation $jobsserviceid

$netoriuminstalldir=ExtractNetoriumPath $serviceexepath $serviceexename
$jobsinstalldir=Join-Path -Path $netoriuminstalldir -ChildPath $jobsfolder
Write-Host ("found a JOBS installation in {0}" -f $jobsinstalldir)

Write-Host "extracting distro"
ExtractDistro $jobsdistribution $netoriuminstalldir

Write-Host "stopping windows service"
StartStopService $jobsinstalldir $jobsserviceid $False

Write-Host "copying data"
CopyData $jobsinstalldir $netoriuminstalldir $distributionname

#Sometimes removing doesn't work after copying. Waiting a little should help
Start-Sleep -Milliseconds 2000
Remove-Item $jobsinstalldir -Recurse

RenameToJobsfolder $netoriuminstalldir $distributionname $jobsfolder

Write-Host "starting windows service"
StartStopService $jobsinstalldir $jobsserviceid $True

Write-Host "`n###### Netorium JOBS updated successfully ######`n"