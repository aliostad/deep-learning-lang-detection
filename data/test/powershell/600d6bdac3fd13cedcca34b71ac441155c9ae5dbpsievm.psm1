<#
  this is loosely based on https://github.com/xdissent/ievms/blob/master/ievms.sh
#>
function Get-ChocolateyExe {
	$cho = "$env:ProgramData\chocolatey\choco.exe";
	if(!(Test-Path -Path $cho) ) {
		Write-Host -BackgroundColor Red -ForegroundColor White "Unable to locate chocolatey. Installing chocolatey...";
		Invoke-InstallChocolatey;
		if(!(Test-Path -Path $cho) ) {
			throw [System.IO.FileNotFoundException] "Still unable to locate chocolatey, even after install attempt."
		}
	}
	return $cho;
}

function Invoke-InstallChocolatey {
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | Write-Host;
}

function Get-IEVM {
	[CmdletBinding()]
	Param (
		[ValidateSet("XP", "Vista", "7", "8", "8.1", "10")]
		[Parameter(Mandatory=$true, Position=0)]
		[string]$OS,
		[string[]] $Shares
	);

	DynamicParam {
		# Set the dynamic parameters' name
		$ievParam = "IEVersion";
		# Create the dictionary 
		$RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary;
		# Create the collection of attributes
		$AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute];
		# Create and set the parameters' attributes
		$ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute;
		$ParameterAttribute.Mandatory = $true;
		$ParameterAttribute.Position = 1;

		# Add the attributes to the attributes collection
		$AttributeCollection.Add($ParameterAttribute);
		$arrSet = @();
		switch ($OS) {
			"xp" {
				$arrSet = @("6","8");
			}
			"vista" {
				$arrSet = @("7");
			}
			"7" {
				$arrSet = @("8","9","10","11");
			}
			"8" {
				$arrSet = @("10");
			}
			"8.1" {
				$arrSet = @("11");
			}
			"10" {
				$arrSet = @("Edge");
			}
		}
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet);
		# Add the ValidateSet to the attributes collection
		$AttributeCollection.Add($ValidateSetAttribute);
		# Create and return the dynamic parameter
		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ievParam, [string], $AttributeCollection);
		$RuntimeParameterDictionary.Add($ievParam, $RuntimeParameter);
		return $RuntimeParameterDictionary;
	}

	begin {
		$PSIEVMVERSION = "0.1.0.0";
		$VMUser = "IEUser";
		$VMPassword = "Passw0rd!";
		$IEVersion = $PsBoundParameters[$ievParam];
		$buildNumber = "20141027";
		$baseURL = "https://az412801.vo.msecnd.net/vhd/VMBuild_{0}/VirtualBox/IE{1}/Windows/IE{1}.{3}{2}.For.Windows.VirtualBox.zip";

		$vbunit = "11";
		switch -Regex ($IEVersion) {
			"^edge$" {
				$vbunit = "8";
				$buildNumber = "20150801";
				$baseURL = "https://az792536.vo.msecnd.net/vms/VMBuild_{0}/VirtualBox/MS{1}/Windows/Microsoft%20{1}.Win{2}.For.Windows.VirtualBox.zip";
			}
			"^(6|7|8)$" {
				$vbunit = "10";
			}
		}
		$url = $baseURL -f $buildNumber, $IEVersion, ($OS -replace "\.", ""), @{$true="";$false="Win"}[$OS -imatch "^(xp|vista)$"];

		$vmName = ("IE{0} - Win{1}" -f $IEVersion, $OS)
		$vmPath = (Join-Path $pwd $vmName);
		$ova = (Join-Path $vmPath "${vmName}.ova" );
		$zip = (Join-Path $vmPath "${vmName}.zip");
		$vbox = (Join-Path $vmPath "${vmName}.vbox");
	}
	
	process {
		# if the vmPath doesnt exist, create it.
		if(!(Test-Path -Path $vmPath)) {
			New-Item -Path $vmPath -ItemType Directory;
		}

		# if the VM does not exist
		if( !(Test-Path -Path $vbox) ) {
			if(!(Test-Path -Path $zip) -and !(Test-Path -Path $ova)) {
				Start-BitsTransfer -Source $url -Destination $zip;
			}

			if((Test-Path -Path $zip) -and !(Test-Path -Path $ova)) {
				Write-Host ("Extracting `"$zip`" -> `"$vmPath`"") -BackgroundColor Gray -ForegroundColor Black;
				Expand-Archive -Path $zip -DestinationPath (Split-Path -Path $zip) -Force;
				Write-Host ("Deleting `"$zip`"") -BackgroundColor Gray -ForegroundColor Black;
				Remove-Item -Path $zip -Force | Out-Null;
			}

			if( !(Test-Path -Path $ova) ) {
				Write-Host "OVA file not found." -BackgroundColor Red -ForegroundColor White;
				return;
			}

			$vbm = Get-VBoxManageExe;
			$disk = (Join-Path $vmPath ("$vmName-disk1.vmdk"));
			Write-Host ("Importing $ova to VM `"$vmName`"") -BackgroundColor Gray -ForegroundColor Black;
			Write-Host "$vbm import `"$ova`" --vsys 0 --vmname `"$vmName`" --unit $vbunit --disk `"$disk`"" -BackgroundColor White -ForegroundColor Black;
			(& $vbm import `"$ova`" --vsys 0 --vmname `"$vmName`" --unit $vbunit --disk `"$disk`" 2>&1) | select-object $_.ToString() | Write-Host;
			$Shared | foreach {
				$shareName = (Split-Path $_ -Leaf);
				Write-Host ("Adding share `"$shareName`" on VM `"$vmName`"") -BackgroundColor Gray -ForegroundColor Black;
				Write-Host "$vbm sharedfolder add `"$vmName`" --name `"$shareName`" --automount --hostpath `"$_`"" -BackgroundColor White -ForegroundColor Black;
				(& $vbm sharedfolder add `"$vmName`" --name `"$shareName`" --automount --hostpath `"$_`" 2>&1) | select-object $_.ToString() | Write-Host;
			}
			Write-Host ("Setting Extra data on VM `"$vmName`"") -BackgroundColor Gray -ForegroundColor Black;
			(& $vbm setextradata `"$vmName`" `"psievm`" `"{\`"created\`" : \`"(Get-Date -Format 'MM-dd-yyyy hh:mm')\`", \`"version\`" : \`"$PSIEVMVERSION`"}\`" 2>&1) | select-object $_.ToString() | Write-Host;
			Write-Host ("Taking initial snapshot of `"$vmName`"") -BackgroundColor Gray -ForegroundColor Black;
			Write-Host "$vbm snapshot `"$vmName`" take clean --description `"The initial VM state.`"" -BackgroundColor White -ForegroundColor Black;
			(& $vbm snapshot `"$vmName`" take clean --description `"The initial VM state.`" 2>&1) | select-object $_.ToString() | Write-Host;
		}

		Start-VBoxVM -VMName $vmName;
	}
}

function Start-VBoxVM {
	Param (
		[string] $VMName
	);
	$vbm = Get-VBoxManageExe;
	Write-Host "Starting VM `"$VMName`"" -BackgroundColor Gray -ForegroundColor Black;
	& $vbm startvm `"$VMName`";
}

function Test-VBoxVM {
	Param (
		[string] $VMName
	);
	# This doesnt work!
	try {
		$vbm = Get-VBoxManageExe;
		Write-Host "$vbm showvminfo `"$VMName`"" -BackgroundColor White -ForegroundColor Black;
		$r = (& $vbm showvminfo `"$VMName`" 2>&1) | select-object $_.ToString();
		$result = $r -notcontains "Could not find a registered machine named '$VMName'";
		if($result -eq $false) {
			Write-Host "Unable to find VM $VMName";
		} else {
			$r;
		}
		return $result;
	} catch {
		Write-Host "Unable to find VM $VMName";
		return $false;
	}
}

function Invoke-RemoteVBoxCommand {
	Param (
		[string] $VMName,
		[string] $Command,
		[string] $Arguments
	);
	$vbm = Get-VBoxManageExe;
	Write-Host "Executing `"$Command $Arguments`" on `"$VMName`"" -BackgroundColor Gray -ForegroundColor Black;
	(& $vbm guestcontrol `"$VMName`" run --username `"$VMUser`" --password `"$VMPassword`" --exe `"$Command`" -- `"$Arguments`" 2>&1) | select-object $_.ToString() | Write-Host;
}

function Get-VBoxManageExe {
	$vbm = @("${env:ProgramFiles(x86)}\Oracle\VirtualBox\VBoxManage.exe","${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe") | where { Test-Path -Path $_ } | Select-Object -First 1;
	if($vbm -eq $null) {
		Write-Host "Unable to locate VirtualBox tools. Installing via Chocolatey.";
		$choc = Get-ChocolateyExe;
		& $choc install virtualbox,vboxguestadditions.install -y | Write-Host;
	}
	return $vbm;
}