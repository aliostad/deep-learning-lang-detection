# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Get RestAPI Key
$RestAPIKey = $PoSHQuery.RestAPIKey

# Check HTTP POST
if (!$RestAPIKey)
{
	$RestAPIKey = $PoSHPost.RestAPIKey
	$RequestType = "POST"
}
else
{
	$RequestType = "GET"
}

# Request Time
$RequestTime = Get-Date

# Check RestAPI Key
$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
$RestAPIKeyValue = Get-Content -Path $RestAPIKeyConfig

if ($RestAPIKey)
{
	if ($RequestType -eq "GET")
	{
		$LinuxVMHost = $PoSHQuery.VMHost
		$RefreshHostRequest = $PoSHQuery.Refresh
	}
	
	if ($RequestType -eq "POST")
	{
		$LinuxVMHost = $PoSHPost.VMHost
		$RefreshHostRequest = $PoSHPost.Refresh
	}

	if ($RestAPIKey -eq $RestAPIKeyValue)
	{
		$ResultCode = "1"
		$ApiResponse = "201"
		$ResultMessage = "RestAPI key validated."
	}
	else
	{
		$ResultCode = "0"
		$ApiResponse = "401"
		$ResultMessage = "RestAPI key is not correct."
	}
}
else
{
	$ResultCode = "0"
	$ApiResponse = "403"
	$ResultMessage = "RestAPIKey is not provided."	
}

# Refresh SetLinuxVM temp
if ($RefreshHostRequest)
{
	if ($RefreshHostRequest -eq "All")
	{
		$TempPath = "$HomeDirectory\temp\Search-LinuxVM.$RefreshHostRequest.xml"
	}
	
	$TestTempPath = Test-Path -Path $TempPath
	if ($TestTempPath)
	{
		Remove-Item -Path $TempPath
	}
}

# Process
if ($ResultCode -eq "1")
{
	if (!$LinuxVMHost)
	{
		# Temp Files Path
		$TempPath = "$HomeDirectory\temp\Search-LinuxVM.AllHost.xml"
		
		# Check Temp Path
		$TempPathTest = Test-Path $TempPath
		
		if (!$TempPathTest)
		{
			$ApiOutput = Search-LinuxVM -OutXML
			Add-Content -Path $TempPath -Value $ApiOutput -EA SilentlyContinue
		}
		else
		{
			# Refresh Temp
			if ($RefreshHostRequest -eq "True")
			{
				Remove-Item -Path $TempPath
				$ApiOutput = Search-LinuxVM -OutXML
				Add-Content -Path $TempPath -Value $ApiOutput -EA SilentlyContinue
			}
			else
			{
				$ApiOutput = Get-Content $TempPath -EA SilentlyContinue
			}
		}
	}
	else
	{
		# Temp Files Path
		$TempPath = "$HomeDirectory\temp\Search-LinuxVM.$LinuxVMHost.xml"
		
		# Check Temp Path
		$TempPathTest = Test-Path $TempPath
		
		if (!$TempPathTest)
		{
			$ApiOutput = Search-LinuxVM -VMHost $LinuxVMHost -OutXML
			Add-Content -Path $TempPath -Value $ApiOutput -EA SilentlyContinue
		}
		else
		{
			# Refresh Temp
			if ($RefreshHostRequest -eq "True")
			{
				Remove-Item -Path $TempPath
				$ApiOutput = Search-LinuxVM -VMHost $LinuxVMHost -OutXML
				Add-Content -Path $TempPath -Value $ApiOutput -EA SilentlyContinue
			}
			else
			{
				$ApiOutput = Get-Content $TempPath -EA SilentlyContinue
			}
		}
	}
}

# Generate Api Output
if (!$ApiOutput)
{
	# Generate Api Output
	$ApiOutput = New-Object Psobject
	$ApiOutput | Add-Member Noteproperty ApiResponse $ApiResponse
	$ApiOutput | Add-Member Noteproperty RequestTime $RequestTime
	$ApiOutput = $ApiOutput | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
}

if ($MimeType -eq "text/psxml")
{
@"
$($ApiOutput)
"@
}
else
{
@"
<script type="text/javascript">
window.location = "/"
</script>
"@
}

# Clear Variables
$RestAPIKey = $null;
$ApiOutput = $null;