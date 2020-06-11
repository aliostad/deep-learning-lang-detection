#Examples from:
#http://www.iis.net/learn/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools

#Import IIS Module, Requires Admin Rights
Import-Module "WebAdministration"  -Verbose:$false | Out-Null

#Remove a site under \Sites\
function Delete-TrvSite($SiteName)
{
	$SiteNameFull = "IIS:\Sites\$SiteName" 
	if(Test-Path $SiteNameFull)
	{
        Write-Verbose "Removing '$SiteNameFull'" -Verbose
		Remove-Item $SiteNameFull -recurse		
	}
	else
	{
		Write-Verbose "Cannot remove site '$SiteNameFull', it does not exist" -Verbose
	}
}
# Deletes all content in folder
function Delete-TrvContent($folderPath)
{
    if(Test-Path $folderPath)
    {
	    Write-Verbose "Deleting all files and folders under '$folderPath'" -Verbose
        Remove-Item (Join-Path $folderPath /*) -recurse
    }
    else
    {
        Write-Verbose "Cannot remove content under '$folderPath'. Folder not found." -Verbose
    }
}

# Creates a site under \Sites\
function Create-TrvSite($SiteName, $SitePath, $AppPoolName, $portNr)
{
	Write-Verbose "Creating Site '$SiteName' with path '$SitePath' AppPool '$AppPoolName' PortNr '$portNr'" -Verbose
    $SiteNameFull = "\Sites\$SiteName"
	New-Item IIS:$SiteNameFull -physicalPath $SitePath -bindings @{protocol="http";bindingInformation=":${portNr}:"} -force
	Set-ItemProperty IIS:$SiteNameFull -name applicationPool -value $AppPoolName 
}

#Creates an Application under the site.
function Create-TrvApplication($SiteName, $ApplicationName, $ApplicationPath, $AppPoolName)
{
	$SiteNameFull = "\Sites\$SiteName"
	$ApplicationNameFull = "$SiteNameFull\$ApplicationName"
	
	Write-Verbose "Creating Application '$ApplicationNameFull' with path '$ApplicationPath'" -Verbose
	New-Item IIS:$ApplicationNameFull -physicalPath $ApplicationPath -type Application
	Write-Verbose "Creating Application Pool '$AppPoolName' for application '$ApplicationNameFull'" -Verbose
	Set-ItemProperty IIS:$ApplicationNameFull -name applicationPool -value $AppPoolName 
}

#Creates a virtual directory under site 
#ApplicationName is optional
function Create-TrvVirtualDirectory($SiteName, $ApplicationName, $VirtualDirectoryName, $VirtualDirectoryPath, $AppPoolName)
{
	$VirtualDirectoryNameFull = "\Sites\$SiteName"
	if ($ApplicationName)
	{ 
		$VirtualDirectoryNameFull = "$VirtualDirectoryNameFull\$ApplicationName"
	}
	
	$VirtualDirectoryNameFull = "$VirtualDirectoryNameFull\$VirtualDirectoryName" 
	Write-Verbose "Creating '$VirtualDirectoryNameFull' with path '$VirtualDirectoryPath'" -Verbose
	New-Item IIS:$VirtualDirectoryNameFull -physicalPath $VirtualDirectoryPath -type VirtualDirectory -force
	
}
# Create Application Pool
function Create-TrvApplicationPool($AppPoolName)
{
    #check if the app pool exists
    if (!(Test-Path "IIS:\AppPools\$AppPoolName" -pathType container))
    {
        Write-Verbose "Creating Application Pool '$AppPoolName'" -Verbose
        #create the app pool
        New-Item "IIS:\AppPools\$AppPoolName"
        #$appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value "v4.0"
        
    }
    else
    {
        Write-Verbose "Cannot create Application Pool '$AppPoolName' it already exists" -Verbose
    }
}
# Remove Application Pool (IIS7+)
function Delete-TrvApplicationPool($AppPoolName)
{
	if(Test-Path IIS:\AppPools\$AppPoolName)
	{
		Write-Verbose "Deleting '$AppPoolName'" -Verbose
		Remove-Item IIS:\AppPools\$AppPoolName -Recurse
	}
    else
    {
        Write-Verbose "Did not find '$AppPoolName'" -Verbose
    }
}
# Recycle Application Pool if it exists
function Restart-TrvApplicationPool($AppPoolName)
{
	if(Test-Path IIS:\AppPools\$AppPoolName)
	{
		Write-Verbose "Restarting '$AppPoolName'" -Verbose
		Restart-WebAppPool $AppPoolName
	}
    else
    {
        Write-Verbose "Did not find $AppPoolName" -Verbose
    }
}

# Safely copy folder (no errors when folder not found)
function Copy-TrvFolder($source, $target)
{
    if (!(Test-Path $target))
    {
		Write-Verbose "Could not find '$target'. Creating it" -Verbose
        New-Item $target -type directory       
    }
    
    if (Test-Path $source)
    {
		Write-Verbose "Copying files in '$source' to '$target'" -Verbose
        Copy-Item $source $target -recurse -force
       
    }
    else
    {
        Write-Verbose "Failed to move files, '$source' not found!" -Verbose
    }
}
# Safely stop site
function Stop-TrvSite($SiteName)
{
    $SiteNameFull = "IIS:\Sites\$SiteName" 
	if(Test-Path $SiteNameFull)
	{
        Write-Verbose "Stopping '$SiteNameFull'" -Verbose
		Stop-WebSite $SiteName	
	}
	else
	{
		Write-Verbose "Cannot stop site '$SiteNameFull', it does not exist" -Verbose
	}

}
#Safely start site
function Start-TrvSite($SiteName)
{
    $SiteNameFull = "IIS:\Sites\$SiteName" 
	if(Test-Path $SiteNameFull)
	{
        Write-Verbose "Starting '$SiteNameFull'" -Verbose
		Start-WebSite $SiteName	
	}
	else
	{
		Write-Verbose "Cannot start site '$SiteNameFull', it does not exist" -Verbose
	}

}