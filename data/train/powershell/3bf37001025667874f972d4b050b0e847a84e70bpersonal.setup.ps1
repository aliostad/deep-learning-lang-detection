Set-StrictMode -Version 1

function InstallChocolatey {
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
	}


function InstallVim {
	}


function InstallPowerShell {
	cinst PowerShell
	}


function InstallFreeCommander {
	cinst FreeCommander
	}


function InstallFireFox {
	cinst FireFox
	}


function InstallFireFoxExtensions {
	# NoScript
	# Vimperator
	# LastPass
	}


function InstallDropBox {
	cinst Dropbox
	}


function UpdateWindowsSettings {
	# Set file view options (Show Hidden Files, Show Extensions, etc)
}


function InstallMicrosoftSecurityEssentials {
	throw "Not Implemented"
}



# MAIN SCRIPT
# ========================================
UpdateWindowsSettings
InstallChocolatey
InstallPowerShell
InstallVim
InstallFreeCommander
InstallFireFox
InstallFireFoxExtensions
InstallDropBox
InstallMicrosoftSecurityEssentials
