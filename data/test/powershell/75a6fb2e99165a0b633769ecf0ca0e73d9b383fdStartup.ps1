<#
   .SYNOPSIS 
   Simple script to check if services are running and warm-up IIS

   .DESCRIPTION
   Stripped down version of the K2 Core VM's startup script. Only checks services, warms up IIS and starts services that needed to auto-start.
   
   .PARAMETER ConfigName
   Specifies the configuration section to use.  The section marked as default=true will be used if this parameter is left blank.

   .INPUTS
   None. You cannot pipe objects to Startup.ps1.

   .OUTPUTS
   Log. Statup.ps1 generates information to console and StartupTransaction.log for all commands executed.

   .EXAMPLE
   C:\PS> .\Startup.ps1

   .EXAMPLE
   C:\PS> .\Startup.ps1 -ConfigName "Core"

#>

param([string]$ConfigName ="Core");

# Disable Execution Policy
Set-ExecutionPolicy Unrestricted

# use try/catch to make sure we report a Ready state even if the scripts fail for some reason
try
{

    # Load Config
    [xml]$configs = Get-Content C:\build_git\K2NE.Scripts\WarmUpWeb\StartupConfig.xml

    # Load configuration by name
    $config = $configs.startupConfigurations.configuration | Where-Object {$_.name -eq $ConfigName }
    if($config -eq $null)
    {
        # Try again, but load configuration by default flag
        $config = $configs.startupConfigurations.configuration | Where-Object {$_.default -eq $true}
        if($config -eq $null)
        {
            Write-Warning "Configuration for $configName not available."
            Write-Warning "Processing will stop."; Break
        }
    }
    # Build up the configuration section variables
    $serviceStatus = $config.serviceStatus
    $urls = $config.urls

    
    # Need to see if the requested services are Running before continuing
    if($serviceStatus)
    {
	    Write-Output ""
	    Write-Output "---- Waiting for Services Startup ----"
	    foreach($status in $serviceStatus.status)
	    {
		    $serviceCheck = Get-Service -DisplayName $status.displayName
		    Write-Output "Checking $($serviceCheck.DisplayName) is $($status.status)"
            $counter=0		
            while(($serviceCheck.Status -ne $status.status) -and $counter -lt 20)
		    {
			    Write-Host -nonewline "."
			    Start-Sleep 1
			    $serviceCheck = Get-Service -DisplayName $status.displayName
                $counter++
		    }
		    Write-Output "$($serviceCheck.DisplayName) is $($serviceCheck.Status)"
	    }
        Write-Output "All required services have started."
    }

    Write-Output ""
    Write-Output "---- Warming up App Pools ----"
    Import-Module -Name WebAdministration #-ErrorAction SilentlyContinue
    dir 'iis:\AppPools' -ErrorAction SilentlyContinue | foreach {$path = "IIS:\AppPools\" + $_.Name; Start-WebItem $path} #-ErrorAction SilentlyContinue

    if($urls)
    {
	    Write-Output ""
	    Write-Output "---- Warming up URLs ----"
	    foreach($url in $urls.url)
	    {
		    if($url.enabled -eq $true)
		    {
			    Write-Output "Warming up $($url.category) at URL $($url.path)"
                # ErrorAction doesn't work for this commandlet so use try/catch
                try
                {
                    Invoke-RestMethod -Uri $url.path -UseDefaultCredentials | Out-Null
                    Write-Output "Warm up URL $($url.path) completed."
                }
                catch
                {
                    Write-Output "ERROR: $_"
                }
		    }
	    }
    }

    # Make sure all services set to start Auto are started
    Write-Output ""
    Write-Output "---- Checking Services set to Auto start ----"
    $autoServices = gwmi win32_service -filter "startmode = 'auto' AND state != 'running'" 
    Write-Output "Found $($autoServices.Count) stopped services"
    foreach($autoService in $autoServices)
    {
        if($autoService.DisplayName -eq "SharePoint Search Host Controller")
        {
            # We have to let SP manage this service and shouldn't do anything
            Break
        }
	    # See if service is "Stopping" first and if so lets just kill it and try again
	    if($autoService.Status -eq "Stopping")
	    {
		    Stop-Process -ProcessName $autoService.Name -Force
	    }
	    # Try to start the service.  Wait 20 seconds max
	    Write-Output "Starting $($autoService.DisplayName)"
	    Start-Service $autoService.Name -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        # | Out-Null
	    $autoService = Get-Service -Name $autoService.Name
	    $counter = 0
	    while(($autoService.Status -ne "Running") -and ($counter -lt 20))
	    {
		    Write-Host -nonewline "."
		    $autoService.Refresh();
		    Start-Sleep 1
		    $counter++
	    }
        if($counter -gt 0){Write-Output ""}
        Write-Output "$($autoService.DisplayName) is $($autoService.Status)"
    }
    Write-Output ""
    Write-Output "The system has been warmed up successfully."

}
catch
{
    [System.Exception]
    Write-Output "System Exception Occurred: $($Error)"
}
finally
{
   
}