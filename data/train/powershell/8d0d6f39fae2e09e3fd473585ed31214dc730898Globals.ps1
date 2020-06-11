#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

function Test-Administrator
{
	$user = [Security.Principal.WindowsIdentity]::GetCurrent();
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Check-RunAsAccount
{
	$runasUser = $env:USERNAME
	if ($runasUser -like "*adm")
	{
		if ((Test-Administrator) -eq $false)
		{
			$ackMessage = "This utility must be run with an ADS\*adm account and with explict admin elevation."
			[System.Windows.Forms.MessageBox]::Show($ackMessage, "Error", 0)
			$MainForm.Close()
			exit
		}
		else
		{
		}
	}
	else
	{
		$ackMessage = "This utility must be run with an ADS\*adm account and with explict admin elevation."
		[System.Windows.Forms.MessageBox]::Show($ackMessage, "Error", 0)
		$MainForm.Close()
		exit
	}
}

function write-logline
{
	param ($logPath,
		$logEntry)
	$timestamp = Get-Date -Format [yyyy-MM-dd][hh:mm:ss]
	$logEntry = $timestamp + " " + $logEntry
	$logEntry | Out-File -FilePath $logPath -Append -Force
}