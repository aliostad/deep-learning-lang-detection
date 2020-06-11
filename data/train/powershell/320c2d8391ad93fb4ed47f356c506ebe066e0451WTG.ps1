<#
.Synopsis
   Automates the creation of Windows To Go USB sticks.
.DESCRIPTION
   This script will automate the creation of Windows To Go USB sticks and
   leverage PowerShell jobs to queue them and write an image sequentially.

   BitLocker is automatically enabled and a PIN is randomly generated. The PIN
   is recorded along with the Recovery Key on the root of the workstation
   executing the script.
.EXAMPLE
   .\WTG.ps1 -ImagePath C:\image.wim -Domain test.local -Unattend C:\Unattend.xml -ComputerName TEST01 -Suffix 1000
.EXAMPLE
   .\WTG.ps1 -ImagePath C:\image.wim -Unattend C:\Unattend.xml -ComputerName TEST01
.INPUTS
   None.
.OUTPUTS
   None.
.NOTES
   This script requires the WinToGo.psm1 module.
   
   Due to a restriction of DISM, Windows cannot write multiple WIM files at the
   same time. The script will iterate through each USB stick and execute them
   sequentially.
#>
Param (
    [Parameter(Mandatory=$true,  
                Position=0)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [String]$ImagePath,
	
	[Parameter(Mandatory=$true)]
	[ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [String]$Unattend,
	
    [Parameter(Mandatory=$true)]
    [String]$ComputerName,

    [Parameter(Mandatory=$false)]
    [String]$Domain,

	[Parameter(Mandatory=$false)]
	[String]$Suffix,

    [Parameter(Mandatory=$false)]
    [String]$BitLockerPIN,
    
    [Parameter(Mandatory=$false)]
    [Switch]$VMTest
)

#$ConfirmPreference = 'Low'

Write-Debug 'Checking for administrative privileges'
$myWindowsID= [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal= New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
If ($myWindowsPrincipal.IsInRole($adminRole)) {
    Write-Debug -Message 'Currently running with administrative privileges'
   }
Else {
    Write-Debug -Message 'Currently running with limited user rights.'
    Write-Verbose -Message 'You need to execute this script with administrative privileges. Exiting.'
    Exit
}

Write-Verbose -Message 'Loading dependencies.'
If (Get-Module -Name WinToGo) {
    Write-Debug -Message 'WinToGo is currently loaded'
} 
Else {
    Write-Debug -Message 'WinToGo is not currently loaded. Attemping to load it.'
    If (Test-Path .\WinToGo) {
        Write-Debug -Message 'Found WinToGo module folder in working directory'
        If (Test-Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules") {
            Write-Debug -Message "PowerShell Module folder exists in user profile. Copying the WinToGo PowerShell Module to $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
            Copy-Item -Path .\WinToGo -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules" -Force -Recurse
            Write-Debug -Message 'Importing the WinToGo PowerShell Module'
            Import-Module -Name WinToGo
        }
        Else {
            Write-Debug -Message "Creating the PowerShell Modules folder at $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
            New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules" | Out-Null
            Write-Debug -Message "Copying the WinToGo PowerShell Module to $env:USERPROFILE\Documents\WindowsPowerShell\Modules"
            Copy-Item -Path .\WinToGo -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules" -Force -Recurse
            Write-Debug -Message 'Importing the WinToGo PowerShell Module'
            Import-Module -Name WinToGo
        }
    }
    Else {
        Write-Verbose -Message 'Cannot find/load a needed dependency (WinToGo.psm1). Exiting.'
        Write-Debug -Message 'WinToGo module not loaded.'
        Exit
    }
}

Write-Debug -Message 'Defining drive letters'
$DriveLetters = 68..90 | ForEach-Object {"$([char]$_):"} | Where-Object {(New-Object System.IO.DriveInfo $_).DriveType -eq 'noRootdirectory'}
$DriveIndex = 2

Write-Debug -Message 'Grabing disk objects'
If ($VMTest.IsPresent -eq $true) {
    Write-Debug 'VMTest variable is true, removing the USB filter'
    $Disks = Get-Disk | Where-Object {$_.Size -gt 20Gb -and -not $_.IsBoot}
}
Else {
    Write-Debug 'VMTest is false, only using USB based volumes'
    $Disks = Get-Disk | Where-Object {$_.Path -match "USBSTOR" -and $_.Size -gt 20Gb -and -not $_.IsBoot}
}

Write-Debug -Message "The value of ImagePath is: $ImagePath"
Write-Debug -Message "The value of BitLockerPIN is: $BitLockerPIN"
Write-Debug -Message "The value of Domain outside the job is $Domain"
Write-Debug -Message "The value of Unattend is: $Unattend"
Write-Debug -Message "The value of ComputerName outside the job is: $ComputerName"

Write-Debug -Message "Stopping the Windows Hardware Detection service"
Try {
    Stop-Service -Name ShellHWDetection
}
Catch {
    Write-Debug -Message "Error in stopping ShellHWDetection. May have already been stopped or does not exist."
}

If ($Disks.Path) {
    Write-Debug -Message 'Beginning If Statement for each disk'
	ForEach ($Disk in $Disks) {
		Write-Debug -Message 'Launching PowerShell Job'
        Start-Job -InitializationScript {Import-Module -Name WinToGo} -ScriptBlock {
			$DebugPreference = 'Continue'
            
			$Disk = $args[0]
			Write-Debug -Message "The value of Disk is: $Disk"
			$ImagePath = $args[1]
			Write-Debug -Message "The value of ImagePath is: $ImagePath"
			$BitLockerPIN = $args[2]
			Write-Debug -Message "The value of BitLockerPIN is: $BitLockerPIN"
			$Domain = $args[3]
			Write-Debug -Message "The value of Domain is: $Domain"
			$ComputerName = $args[4]
			Write-Debug -Message "The value of ComputerName is: $ComputerName"
			$Suffix = $args[5]
			Write-Debug -Message "The value of Suffix is: $Suffix"
			$Unattend = $args[6]
            Write-Debug -Message "The value of Unattend is: $Unattend"

            $ComputerName = $ComputerName + "-" + $Suffix
            
			Write-Debug -Message "Calling Initialize-WTGStick function"
			$OSVolume = Initialize-WTGStick -Disk $Disk -BitLockerPIN $BitLockerPIN -ComputerName $ComputerName
                
            Write-Debug -Message 'Calling Write-WTGStick function'
			Write-WTGStick -DriveLetter $OSVolume.DriveLetter -Image $ImagePath -ComputerName $ComputerName -Unattend $Unattend
			
            $Unattend = $OSVolume.DriveLetter + ":\Windows\System32\Sysprep\Unattend.xml"
            
            If ($Domain) {
			
                Write-Debug -Message 'Calling Join-WTGDomain function'
			    Join-WTGDomain -OSDriveLetter ($OSVolume.DriveLetter) -Unattend $Unattend -Domain $Domain -ComputerName $ComputerName
            }
            
			Write-Debug -Message 'Calling BCDBoot.exe to write BCD Store to the stick'
            $SystemDriveLetter = ($Disk | Get-Partition | Where-Object {$_.Size -eq 350MB -and $_.Type -eq "FAT32"}).DriveLetter.ToString()
            Write-Debug -Message "The value of SystemDriveLetter is: $SystemDriveLetter"
			Start-Process -FilePath "$($OSVolume.DriveLetter):\Windows\System32\bcdboot.exe" -WorkingDirectory "$($OSVolume.DriveLetter):\Windows\System32" -ArgumentList "$($OSVolume.DriveLetter):\Windows /f ALL /s ${SystemDriveLetter}:" -WindowStyle Hidden -Wait
        
		} -ArgumentList $Disk,$ImagePath,$BitLockerPIN,$Domain,$ComputerName,$Suffix,$Unattend | Wait-Job
        
		Write-Debug -Message "Current drive index is $DriveIndex"
		$DriveIndex = $DriveIndex + 2
        $Suffix = [String]([Int]$Suffix + 1)
		Write-Debug -Message "Updated drive index is $DriveIndex"
	}
}
Else {
    Write-Debug -Message "No USB sticks detected in the Disk variable."
    Write-Verbose -Message 'No USB sticks detected.'
}
