#
# Cadmus.Foundation.psm1
#

if (-Not $logger)
{
	Add-Type -Path 'Cadmus.Foundation.dll'
	$logger = New-Object -TypeName 'Cadmus.Foundation.ConsoleLogger'
}

function Log-Info() 
{
	param ([string] $Message)
	$logger.LogInfo($Message)
}

function Log-Success() 
{
	param ([string] $Message)
	$logger.LogSuccess($Message)
}

function Log-Warning() 
{
	param ([string] $Message)
	$logger.LogWarning($Message)
}

function Log-Error() 
{
	param ([string] $Message)
	$logger.LogError($Message)
}

function Log-Verbose()
{
	param ([string] $Message)
	$logger.LogVerbose($Message)
}

function Log-Header() 
{
	param ([string] $Message)
	$logger.LogHeader($Message)
}

function Start-Verbose()
{
	$logger.StartVerbose()
}

function Stop-Verbose()
{
	$logger.StopVerbose()
}

function Show-BigHeader()
{
	param ([string] $Header)
	Log-Header '=================================================='
	Log-Header $Header
	Log-Header '=================================================='
}


#Set-Item -Path WSMan:localhost\Client\TrustedHosts -Value 'nestor,apollo' -Force