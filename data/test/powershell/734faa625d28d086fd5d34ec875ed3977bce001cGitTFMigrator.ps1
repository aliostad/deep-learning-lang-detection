Param(
	[string]$sourceTFS,
	[string]$destinationTFS,
	[string]$sourceFolder,
	[string]$destinationFolder,
	[string]$workingDir         = 'C:\temp\TFSMigrator',
	[string]$force,
	[switch]$h,
	[switch]$help
);

# START non-configurable variables at runtime

$ErrorActionPreference	= "stop"
$global:gittfURL	= 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip';
$global:gitURL		= 'https://msysgit.googlecode.com/files/Git-1.8.5.2-preview20131230.exe';
$global:gittfArchive	= 'git-tf.zip';
$global:gitInstaller	= 'git-installer.exe';
$global:gittfBasePath	= 'C:\git-tf';
$global:tempPath	= 'C:\temp';
$global:gittf		= '';
$global:git		= '';
$global:gitDefaultPath	= "${env:programfiles(x86)}\Git\cmd\";
$global:gitExe		= "git.exe";
$global:initialFolder	= pwd;
$global:argList		= @('-NoProfile', '-NoExit', '-Command', '"' + $MyInvocation.MyCommand.Path);
	$global:argList += $MyInvocation.BoundParameters.GetEnumerator() | Foreach {"-$($_.Key)", "'$($_.Value)'"};
	$global:argList += $MyInvocation.UnboundArguments;
	$global:argList += '"';

# END non-configurable variables at runtime

function WriteHeader
{
	Write-Host '';
	Write-Host '==';
	Write-Host '==   TFS Source Code Migration Tool - git-tf, v1.3.0';
	Write-Host '==   Mitchell Barry, 03/24/2014';
	Write-Host '==';
	Write-Host '';
}

function PrintHelp
{
	Write-Host '';
	Write-Host 'Expects 2 parameters, 4 optional';
	Write-Host '';
	Write-Host "    -sourceFolder      '$/TeamProject/Path'";
	Write-Host "    -destinationFolder '$/TeamProject/Path'";
	Write-Host "    [-sourceTFS]       'http://tfs.yourhost.net:8080/tfs/DefaultCollection'";
	Write-Host "    [-destinationTFS]  'http://tfs.yourhost.net:8080/tfs/SecondCollection'";
	Write-Host "    [-workingDir]      'C:\temp\TFSMigrator'";
	Write-Host "    [-force]           'true' : will not prompt to confirm settings";
	Write-Host "    [-h,-help]         (flag) if included, will display this menu";
	Write-Host '';
	Write-Host '';
	Write-Host ' * If Git installation required, Administrator role is needed';
	Write-Host ' * The script will automatically download and help you install Git and Git-TF';
	Write-Host ' * It is your responsibility to ensure a proper Team Project is specified in source and destination';
	Write-Host ' * This script will not create new Team Projects';
	Write-Host ' * User running script requires "Check-in other users changes" permission on destination TFS';
	Write-Host ' * Supports TFS 2010+';
	Write-Host '';
	Write-Host '';
	Write-Host 'Press any key to continue...';
	$in = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

function CheckAdministrator
{
	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		Write-Host 'Migration will continue in elevated privilege window.';
		Write-Host '';
		Start-Process PowerShell.exe -Verb Runas -WorkingDirectory $pwd -ArgumentList $global:argList;
		exit;
	}
}

function ValidateInput
{
	if (([bool]$sourceTFS) -and ([bool]$destinationTFS) -and ([bool]$sourceFolder) -and ([bool]$destinationFolder) -and ([bool]$workingDir))
	{
		return $true;
	}
	else
	{
		return $false;
	}
}

function Download-Web-File ([string] $urlPath, [string] $filePath) 
{
	$webClient = (New-Object Net.WebClient);
	$webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;
	$webClient.DownloadFile($urlPath, $filePath);
}

function Extract-Zip ([string] $zipfilename, [string] $destination) 
{
	if(Test-Path($zipfilename)) 
	{ 
		$shellApplication = new-object -com shell.application;
		$zipPackage = $shellApplication.NameSpace($zipfilename);
		$destinationFolder = $shellApplication.NameSpace($destination);
		$destinationFolder.CopyHere($zipPackage.Items());
	}
	else 
	{   
		Write-Host $zipfilename "not found";
	}
} 

function PrepareGit
{
	# check in PATH first
	$gitcmd = (Get-Command git -TotalCount 1 -ErrorAction SilentlyContinue);
	if ($gitcmd) 
	{
		Write-Host "Found git at '$gitcmd.Definition'";
		$global:git = $gitcmd.Definition;
	}
	# next, check default install location (if no PowerShell restart after git installation)
	elseif ((Get-Command (Join-Path $gitDefaultPath $gitExe) -TotalCount 1 -ErrorAction SilentlyContinue))
	{
		$gitcmd = (Get-Command (Join-Path $gitDefaultPath $gitExe) -TotalCount 1 -ErrorAction SilentlyContinue);
		$global:git = $gitcmd.Definition;
	}
	# else, no git installed
	else 
	{
		CheckAdministrator;
		Write-Host 'Downloading Git from msysgit.googlecode.com ...';
		Download-Web-File $gitURL (Join-Path $tempPath $gitInstaller);
		Write-Host 'Installing...';
		Write-Host '';
		$args = '/silent', "/components='icons,assoc,assoc_sh'";
		Start-Process -wait (Join-Path $tempPath $gitInstaller) $args;
		$global:git = (Get-Command (Join-Path $gitDefaultPath $gitExe)).Definition;
		$args = 'config', '--global', 'core.autocrlf', 'false';
		&$git $args; # do not manage line endings of files
		UpdatePath; # add Git to %PATH%
	}
}

function UpdatePath
{
	# https://blogs.technet.com/b/heyscriptingguy/archive/2011/07/23/use-powershell-to-modify-your-environmental-path.aspx
	$OldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path;
	if ($env:Path | Select-String -SimpleMatch $gitDefaultPath)
	{
		return;
	}
	$NewPath = $OldPath + ';' + $gitDefaultPath;
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $NewPath
	Write-Host 'Git added to %PATH%';
	Write-Host '';
}

function PrepareGitTF
{
	if ((Test-Path $gittfBasePath) -eq 0)
	{
		mkdir $gittfBasePath 2>&1 | Out-Null;
		Write-Host 'Downloading Git-TF from microsoft.com ...';
		Download-Web-File $gittfURL (Join-Path $tempPath $gittfArchive);
		Write-Host 'Extracting...'
		Extract-Zip (Join-Path $tempPath $gittfArchive) $gittfBasePath;
		Write-Host '';
	}
	$gittfDir = (Get-ChildItem $gittfBasePath | Where {$_.PSisContainer}).FullName; #expects single folder
	$global:gittf = (Join-Path $gittfDir 'git-tf.cmd'); 
}

function CloneToRepository
{
	if ((Test-Path $workingDir) -eq 1)
	{
		Remove-Item -Recurse -Force $workingDir;
	}
	mkdir $workingDir 2>&1 | Out-Null;
	cd $workingDir;
	$args = 'clone', $sourceTFS, $sourceFolder, 'oldserver', '--deep';
	&$gittf $args;
}

function CheckInToDestination
{
	# intialize new git repository for destination
	$args = 'init', 'newserver';
	&$git $args;
	
	cd 'newserver';

	# pull all changes from source location
	$args = 'pull', '..\oldserver', '--depth', '100000000';
	&$git $args;

	# configure new repository for destination folder & TFS connection
	$args = 'configure', $destinationTFS, $destinationFolder;
	&$gittf $args;

	# commit your changes by performing checkin
	$args = 'checkin', '--deep', '--autosquash', '--keep-author';
	&$gittf $args; # user must be project administrator with "Check-in other users' changes" permission for --keep-author
}

function ResetWorkspace
{
	cd $initialFolder;
}

function Run
{
	Clear-Host;
	WriteHeader;
	if (ValidateInput -and !$h -and !$help)
	{
		PrepareGitTF; # ensure 'git-tf.cmd' is available
		PrepareGit;	# ensure 'git.exe' installed
		CloneToRepository; # pulls code down from source TFS
		
		if ($force.ToUpper() -eq 'TRUE') 
		{
			CheckInToDestination; # commit code pulled from source into destination TFS
		}
		else 
		{
			Write-Host '';
			Write-Host '';
			Write-Host 'Confirm uploading source code -->';
			Write-Host "  FROM $sourceTFS : $sourceFolder";
			Write-Host "    TO $destinationTFS : $destinationFolder";
			Write-Host '';
			if ((Read-Host "Is this information correct? [Y/N]").ToUpper() -eq 'Y')
			{
				CheckInToDestination; # commit code pulled from source into destination TFS
			}
			else
			{
				Write-Host '';
				Write-Host 'Check-in cancelled.';
			}
		}
	}
	else
	{
		PrintHelp;
	}
	ResetWorkspace; # change directory back to starting directory
	
	Write-Host '';
}

Run;
