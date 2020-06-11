Function Get-WelcomeMessage{
	param([string] $context)
	$webApp = Get-SPWebApplication -Name "WebApplication - PFZW"
	return $webApp
	#return "Welcome from context {0}" -f $context
}

Function Get-VirtualDirectoryForWebApp
{
	param
	(
		$WebApplication,
		[String] $Zone
	)
	$path = $Webapplication.GetIisSettingsWithFallback($Zone).Path
	$path
}

Function Get-HelloMessage{
	param([string] $context)	
	return "Hello from context {0}" -f $context
}

Function Set-WelcomeMessage{
	param([string] $context)
	$message = "Welcome from context {0}" -f $context
	Write-Host "Setting the welcome message as {0}" -f $message
	return $message
}

Function Invoke-NonTerminatingError{
	Write-Error "New error"
}

Function Invoke-TerminatingError{
	throw "New error"
}