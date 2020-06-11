$ErrorActionPreference = "stop"

function run_cmd($commandName, $arguments, $expectedExitCode) {
	$concatenatedArguments = ""
	$arguments | ForEach-Object {$concatenatedArguments += "$_ "}

	Write-Host "----run_cmd----"
	Write-Host "----run_cmd command name: $commandName"
	Write-Host "----run_cmd arguments: $arguments"
	Write-Host "----run_cmd expected exit code: $expectedExitCode" 
	
    $startInfo = New-Object Diagnostics.ProcessStartInfo($commandName)
    $startInfo.UseShellExecute = $false
    $startInfo.Arguments = $concatenatedArguments
    $process = [Diagnostics.Process]::Start($startInfo)
    $process.WaitForExit()
    $exitCode = $process.ExitCode
    if($exitCode -ne $expectedExitCode) {
		$errorMessage = "The command exited with a code of: $exitCode"
		throw $errorMessage
	}
}

function new_virtualbox_vm ($name, $hostInstallersDirectory, $windowsKey, $vdiDirectory, $ipAddress, $hostIpAddress, $hostOnlyNetwork, $installersDriveLetter, $isoDrive, $osIso, $toolsDir, $memory, $cpuCores) {
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

		$obj | Add-Member -Type ScriptMethod -Name _createUnattendFloppy -Value {
			$floppyDir = "$($this.WorkingDirectory)\floppy"
			$unattendFile = "$floppyDir\autounattend.xml"

			if((Test-Path $floppyDir)) {
				Remove-Item $floppyDir -Force -Recurse
			}
			New-Item $floppyDir -Type Directory

			Copy-Item "$($this.LibDir)\oracle.cer" $floppyDir
			Get-Content "$($this.LibDir)\autounattend.template" | 
				% { $_  -Replace "#{ProductKey}",$windowsKey `
						-Replace "#{ComputerName}",$this.Name `
						-Replace "#{Password}",$this.AdminUser.Password.PlainText `
						-Replace "#{IpAddress}",$this.IpAddress `
						-Replace "#{HostIpAddress}",$this.HostipAddress	
				} | Out-File $unattendFile -Encoding "UTF8"

			run_cmd "$($this.ToolsDir)\bfi10\bfi.exe" "-f=$($this.FloppyImage)",$floppyDir 0
		}
		$obj | Add-Member -Type ScriptMethod -Name run_vbox_cmd -Value { param($arguments)
			run_cmd "$($this.VirtualBoxDir)\VBoxManage.exe" $arguments 0
		}
		$obj | Add-Member -Type ScriptMethod -Name _createVm -Value {
			$this._createUnattendFloppy()
			$vdi = "$($this.VdiDirectory)\$($this.Name).vdi"
			$osIso = "$($this.HostInstallersDirectory)\$($this.OsIso)"
			
			$this.run_vbox_cmd(@("createvm","--name $($this.Name)","--ostype Windows2008_64","--register"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--memory $($this.Memory)"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--cpus $($this.CpuCores)"))
			$this.run_vbox_cmd(@("createhd","--filename $vdi","--size 40960"))
			$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "SATA Controller"',"--add sata","--controller IntelAHCI"))
			$this.run_vbox_cmd(@("storageattach $($this.Name)",'--storagectl "SATA Controller"',"--port 0","--device 0","--type hdd","--medium $vdi"))
			$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "IDE Controller"',"--add ide"))
			$this.run_vbox_cmd(@("storageattach $($this.Name)",'--storagectl "IDE Controller"',"--port 0","--device 0","--type dvddrive","--medium $osIso"))
			$this.run_vbox_cmd(@("storagectl $($this.Name)",'--name "Floppy"',"--add Floppy"))
			$this.run_vbox_cmd(@("storageattach $($this.Name)","--storagectl Floppy","--port 0","--device 0","--type fdd","--medium $($this.FloppyImage)"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--boot1 dvd","--boot2 floppy","--boot3 disk","--boot4 none"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--vram 128"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--nic1 hostonly"))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--hostonlyadapter1 `"$($this.HostOnlyNetwork)`""))
			$this.run_vbox_cmd(@("modifyvm $($this.Name)","--nic2 nat"))
			$this.run_vbox_cmd(@("sharedfolder add $($this.Name)","-name installers","-hostpath $($this.HostInstallersDirectory)"))
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
			New-PSSession -ComputerName $this.IpAddress -Credential $this.AdminUser.Credential -Authentication $authentication
		}
		$obj | Add-Member -Type ScriptMethod _mapGuestInstallersDirectory {
			run_cmd "net" @("use", $this.InstallersDriveUnc, "/User:$($this.AdminUser.Name)", "$($this.AdminUser.Password.PlainText)") 0
		}
		$obj | Add-Member -Type ScriptMethod _waitForWinRm -Value {
			$numberOfTries = 0

			$session = $null

			while($true) {
				try {
					Write-Host "Waiting for WinRM to become available attempt $numberOfTries"
					$this.NegotiateRemoteSession({ param($session) $session.Execute({})})
					break;
				} catch {
					if($numberOfTries -lt 40) { 
						Write-Host $_
						$numberOfTries++
						Start-Sleep -s 60
					} else {
						throw $_
					}
				}
			}
		}
		$obj | Add-Member -Type ScriptMethod _downloadInstallers {
			$hostPath = "$($this.HostInstallersDirectory)\$name"
			$guestPath = "$($this.InstallersDirectory)\$name"

			$toDownload = @()
			$this.Installers.GetEnumerator() | % {
				$fullPath = "$($this.HostInstallersDirectory)\$($_.Value)"
				if(!(Test-Path $fullPath)) {
					throw "Cannot find $fullPath"
				}
				$toDownload += $fullPath
			}
			
			if(!(Test-Path $this.InstallersUnc)) {
				New-Item $this.InstallersUnc -Type Directory
			}

			$toDownload | % {
				Copy-Item $_ "$($this.InstallersUnc)\" -Recurse -Force
		}
	}
	$obj
}
