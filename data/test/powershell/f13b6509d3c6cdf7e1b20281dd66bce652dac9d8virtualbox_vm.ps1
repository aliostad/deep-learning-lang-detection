$ErrorActionPreference = "stop"

function run_cmd($commandName, $arguments, $expectedExitCode, $returnStdOut = $false) {
	$concatenatedArguments = ""
	$arguments | ForEach-Object {$concatenatedArguments += "$_ "}

	Write-Host "INFO: run_cmd"
	Write-Host "INFO: --command name: $($commandName)"
	Write-Host "INFO: --arguments: $($arguments)"
	Write-Host "INFO: --expected exit code: $($expectedExitCode)" 
	
	$startInfo = New-Object Diagnostics.ProcessStartInfo
	$startInfo.FileName = $commandName
	$startInfo.UseShellExecute = $false
	$startInfo.Arguments = $concatenatedArguments
	$process = New-Object Diagnostics.Process
	$process.StartInfo = $startInfo
	$process.Start() | Out-Null
	$process.WaitForExit()
	$exitCode = $process.ExitCode
	Write-Host "INFO: --exit code: $($exitCode)"
	if($exitCode -ne $expectedExitCode) {
		$errorMessage = "The command exited with a code of: $exitCode"
		throw $errorMessage
	}
}

function new_virtualbox_vm ($name, $hostInstallersDirectory, $windowsKey, $vdiDirectory, $ipAddress, $hostIpAddress, $hostOnlyNetwork, $installersDriveLetter, $isoDrive, $osIso, $toolsDir, $memory, $cpuCores) {
	Write-Host "INFO: new_virtualbox_vm."
	Write-Host "INFO: --Name: $($name)"
	Write-Host "INFO: --hostInstallersDirectory: $($hostInstallersDirectory)"
	Write-Host "INFO: --windowsKey $($windowsKey)"
	Write-Host "INFO: --vdiDirectory: $($vdiDirectory)"
	Write-Host "INFO: --ipAddress: $($ipAddress)"
	Write-Host "INFO: --hostIpAddress: $($hostIpAddress)"
	Write-Host "INFO: --hostOnlyNetwork: $($hostOnlyNetwork)"
	Write-Host "INFO: --installersDriveLetter: $($installersDriveLetter)"
	Write-Host "INFO: --isoDrive: $($isoDrive)"
	Write-Host "INFO: --osIso: $($osIso)"
	Write-Host "INFO: --toolsDir: $($toolsDir)"
	Write-Host "INFO: --memory: $($memory)"
	Write-Host "INFO: --cpuCores: $($memory)"
	$installersDirectory = "$($installersDriveLetter):\installers"
	$installersDriveUnc = "\\$($ipAddress)\$($installersDriveLetter)`$"
	$installersUnc = "\\$($ipAddress)\$($installersDriveLetter)`$\installers"
	$obj = new_vm_base $name $installersDirectory $isoDrive

	$obj | Add-Member -Type NoteProperty HostInstallersDirectory $hostInstallersDirectory
	$obj | Add-Member -Type NoteProperty WindowsKey $windowsKey
	$obj | Add-Member -Type NoteProperty HostIpAddress $hostIpAddress
	$obj | Add-Member -Type NoteProperty IpAddress $ipAddress
	$obj | Add-Member -Type NoteProperty VdiDirectory $vdiDirectory
	$obj | Add-Member -Type NoteProperty FloppyImage "$workingDirectory\floppy.img"
	$obj | Add-Member -Type NoteProperty HostOnlyNetwork $hostOnlyNetwork
	$obj | Add-Member -Type NoteProperty VirtualBoxDir "C:\Program Files\Oracle\VirtualBox"
	$obj | Add-Member -Type NoteProperty OsIso $osIso
	$obj | Add-Member -Type NoteProperty InstallersDriveLetter $installersDriveLetter
	$obj | Add-Member -Type NoteProperty InstallersDriveUnc $installersDriveUnc
	$obj | Add-Member -Type NoteProperty InstallersUnc $installersUnc
	$obj | Add-Member -Type NoteProperty ToolsDir $toolsDir
	$obj | Add-Member -Type NoteProperty Memory $memory
	$obj | Add-Member -Type NoteProperty CpuCores $cpuCores

	$obj | Add-Member -Type ScriptMethod -Name _createUnattendFloppy -Value { param($hostOnlyMacAddress)
		$floppyDir = "$($this.WorkingDirectory)\floppy"
		$unattendFile = "$floppyDir\autounattend.xml"

		if((Test-Path $floppyDir)) {
			Remove-Item $floppyDir -Force -Recurse
		}
		New-Item $floppyDir -Type Directory

		Copy-Item "$($this.LibDir)\oracle.cer" $floppyDir
		Copy-Item "$($this.LibDir)\set_host_only_static_ip.ps1" $floppyDir
		Get-Content "$($this.LibDir)\autounattend.template" | 
			% { $_  -Replace "#{ProductKey}",$windowsKey `
					-Replace "#{ComputerName}",$this.Name `
					-Replace "#{Password}",$this.AdminUser.Password.PlainText `
					-Replace "#{IpAddress}",$this.IpAddress `
					-Replace "#{HostIpAddress}",$this.HostipAddress	 `
					-Replace "#{HostOnlyMacAddress}",$hostOnlyMacAddress
			} | Out-File $unattendFile -Encoding "UTF8"

		run_cmd "$($this.ToolsDir)\bfi10\bfi.exe" "-f=$($this.FloppyImage)",$floppyDir 0
	}
	$obj | Add-Member -Type ScriptMethod -Name run_vbox_cmd -Value { param($arguments)
		run_cmd "$($this.VirtualBoxDir)\VBoxManage.exe" $arguments 0
	}
	$obj | Add-Member -Type ScriptMethod -Name _createVm -Value {
		$vdi = "$($this.VdiDirectory)\$($this.Name).vdi"
		$osIso = "$($this.HostInstallersDirectory)\$($this.OsIso)"
		
		$this.run_vbox_cmd(@("createvm","--name $($this.Name)","--ostype Windows2008_64","--register"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--memory $($this.Memory)"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--cpus $($this.CpuCores)"))
		$this.run_vbox_cmd(@("createhd","--filename $vdi","--size 60960"))
		$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "SATA Controller"',"--add sata","--controller IntelAHCI"))
		$this.run_vbox_cmd(@("storageattach $($this.Name)",'--storagectl "SATA Controller"',"--port 0","--device 0","--type hdd","--medium $vdi"))
		$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "IDE Controller"',"--add ide"))
		$this.run_vbox_cmd(@("storageattach $($this.Name)",'--storagectl "IDE Controller"',"--port 0","--device 0","--type dvddrive","--medium $osIso"))
		$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "Floppy"',"--add Floppy"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--vram 128"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--nic1 hostonly"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--hostonlyadapter1 `"$($this.HostOnlyNetwork)`""))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--nic2 nat"))
		$this.run_vbox_cmd(@("sharedfolder add $($this.Name)","-name installers","-hostpath $($this.HostInstallersDirectory)"))

		$hostOnlyMacAddress = (& "$($this.VirtualBoxDir)\VBoxManage.exe" "showvminfo" "$($this.Name)" "--machinereadable" | ? { $_ -Match "macaddress1" }).Split('"')[1]
		$this._createUnattendFloppy($hostOnlyMacAddress)
		Write-Host "INFO: Host only adapter macAddress: $($hostOnlyMacAddress)"
		$this.run_vbox_cmd(@("storageattach $($this.Name)","--storagectl Floppy","--port 0","--device 0","--type fdd","--medium $($this.FloppyImage)"))
		$this.run_vbox_cmd(@("modifyvm $($this.Name)","--boot1 dvd","--boot2 floppy","--boot3 disk","--boot4 none"))

		$this.run_vbox_cmd(@("startvm $($this.Name)","--type gui"))

		$this._waitForWinRm()
		$this._installGuestAdditions()
		$this.run_vbox_cmd(@("controlvm $($this.Name)","clipboard bidirectional"))
		$this._mapGuestInstallersDirectory()
	}
	$obj | Add-Member -Type ScriptMethod _installGuestAdditions -Value {
		$this.run_vbox_cmd(@("storageattach $($this.Name)",'--storagectl "IDE Controller"',"--port 0","--device 0","--type dvddrive","--medium `"$($this.VirtualBoxDir)\VBoxGuestAdditions.iso`""))
		$this.RemoteSession({ param($sesson)
			$session.Execute({ param($remoteVm)
				$remoteVm.CmdLine.Execute("certutil", @('-addstore -f "TrustedPublisher"', "A:\Oracle.cer"), 0)
				$remoteVm.CmdLine.Execute("D:\VBoxWindowsAdditions.exe", @("/S"), 0)
			})
		})
	}
	$obj | Add-Member -Type ScriptMethod _waitForBoot {
		$this._waitForWinRm()
	}
	$obj | Add-Member -Type ScriptMethod _setWinRmUri {
		$this.WinRmUri = $this.Name
	}
	$obj | Add-Member -Type ScriptMethod CreatePSSession { param($authentication)
		Write-Host "INFO: Creating remote powershell sesstion"
		Write-Host "INFO: --New-PSSession -ComputerName $($this.IpAddress) -Credential $($this.AdminUser.Credential) -Authentication $($authentication)"
		New-PSSession -ComputerName $this.IpAddress -Credential $this.AdminUser.Credential -Authentication $authentication
		Write-Host "INFO: --Done Creating remote powershell session"
	}
	$obj | Add-Member -Type ScriptMethod _mapGuestInstallersDirectory {
		Write-Host "INFO: Mapping guest installers directory"
		Write-Host "INFO: --Adding firewall rule to enable file and printer sharing"
		$this.RemoteSession({ param($session)
			$session.Execute({ param($context)
				$context.CmdLine.Execute("netsh", @("advfirewall", "firewall", "set", 'rule group="File and Printer Sharing"', "new", "enable=Yes"), 0)
			})
		})
		Write-Host "INFO: --Mapping guest unc path"
		run_cmd "net" @("use", $this.InstallersDriveUnc, "/User:$($this.AdminUser.Name)", "$($this.AdminUser.Password.PlainText)") 0
	}
	$obj | Add-Member -Type ScriptMethod _waitForWinRm -Value {
		Write-Host "INFO: Waiting for WinRm to become available"
		$numberOfTries = 0

		$session = $null

		while($true) {
			try {
				Write-Host "INFO: Waiting for WinRM to become available attempt $($numberOfTries)"
				$this.NegotiateRemoteSession({ param($session) $session.Execute({})})
				break;
			} catch {
				if($numberOfTries -lt 40) { 
					Write-Host "INFO: --WinRm is not available. Error: $($_)"
					$numberOfTries++
					Write-Host "INFO: --Waiting 60 seconds before next try"
					Start-Sleep -s 60
				} else {
					Write-Host "INFO: --Number of tries exceeded. Max: 40, NumberOfTries: $($numberOfTries)"
					throw $_
				}
			}
		}
	}
	$obj | Add-Member -Type ScriptMethod  _validateInstallers {
		$this.Installers.GetEnumerator() | % {
			$fullPath = "$($this.HostInstallersDirectory)\$($_.Value)"
			Write-Host "INFO: Validate installer. FullPath: $($fullPath)"
			if(!(Test-Path $fullPath)) {
				throw "Cannot find $fullPath"
			}
		}
	}
	$obj | Add-Member -Type ScriptMethod _downloadInstallers {
		Write-Host "Creating directory for installers. InstallersUnc: $($this.InstallersUnc)"
		if(!(Test-Path $this.InstallersUnc)) {
			New-Item $this.InstallersUnc -Type Directory
		}

		$this.Installers.GetEnumerator() | % {
			$fullPath = "$($this.HostInstallersDirectory)\$($_.Value)"
			Write-Host "INFO: Downloading installer. FullPath: $($fullPath)"
			Copy-Item $fullPath "$($this.InstallersUnc)\" -Recurse -Force
		}
	}
	$obj
}
