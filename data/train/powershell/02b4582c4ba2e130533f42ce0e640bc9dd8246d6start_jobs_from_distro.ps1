#
# install-jobs.ps1
#

Param(
  [Parameter(Mandatory=$True)] 
  [string]$distributionpath,
  [Parameter(Mandatory=$True)]
  [string]$installdir,
  [Parameter(Mandatory=$True)]
  [string]$distributionname,
  [Parameter(Mandatory=$True)]
  [string]$bobykarpath,
  [Parameter(Mandatory=$True)]
  [string]$jobsfolder,
  [switch]$debugmode
)

#region Helper functions

Function ExitWithMessage($ExitMessage)
{

	Write-Host ($ExitMessage)
	Exit
}

#endregion


$jobsdistribution=(Join-Path -path $distributionpath -ChildPath $distributionname) + ".zip"
#check, if distro exists
if (-Not (Test-Path $jobsdistribution)) 
{
    ExitWithMessage ("Distribution {0} doesn't exist!" -f $jobsdistribution)
} 

#check, if installdir exists. If not, create it
if (-Not (Test-Path $installdir)) 
{
	#try creating installdir
    New-Item -Path $installdir -ItemType directory
	if ($?.Equals($false))
	{
		ExitWithMessage ("Error creating {0}. ErrorMessage: {1}!" -f $installdir, $Error[0])
    }
}

#check, if target path already exists
$newdistributionpath=Join-Path -path $installdir -ChildPath $jobsfolder
if(Test-Path $newdistributionpath)
{
	ExitWithMessage ("Target path {0} already exists" -f $newdistributionpath)
}


#if (-Not (Test-Path $bobykar)) 
#{
#    ExitWithMessage ("Boby kar file {0} doesn't exist!" -f $bobykar)
#}
#Copy-Item $bobykar $netoriuminstalldir

#extracting distribution
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($jobsdistribution, $installdir)
if ($?.Equals($False))
{
	ExitWithMessage ("Error unzipping distribution. ErrorMessage: {0}!" -f $Error[0])
}

Start-Sleep -Milliseconds 500
$distributionpath=Join-Path -path $installdir -ChildPath $distributionname
Rename-Item -path $distributionpath -NewName $newdistributionpath

Set-Location $newdistributionpath


$karafscript=[io.path]::combine($installdir, $jobsfolder, "bin\karaf.bat")
$karafscript="""$karafscript"""

$cmdparams=@("/K";$karafscript)

if($debugmode.Equals($True))
{
	$cmdparams += "debug"
}

Start-Process cmd.exe $cmdparams

Write-Host "JOBS successfully started"

