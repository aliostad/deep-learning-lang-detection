#requires -version 4
<#
.SYNOPSIS
  Para verificar archivos binarios y borrar historial del servidor.
#>
 
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
 
#Set Error Action to Silently Continue
$ErrorActionPreference = "Stop"


#----------------------------------------------------------[Declarations]----------------------------------------------------------
 
#Script Version
$Script:ScriptVersion = "1.0"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Register-TfsPlugin {
	if (-not (Get-PSSnapin Microsoft.TeamFoundation.PowerShell -ErrorAction SilentlyContinue)) {
		if (-not (Get-PSSnapin Microsoft.TeamFoundation.PowerShell -Registered -ErrorAction SilentlyContinue)) {
			Start-Process "https://visualstudiogallery.msdn.microsoft.com/f017b10c-02b4-4d6d-9845-58a06545627f"
			throw "You need to install first 'TFS Power Tools'"
		}
		Add-PSSnapin Microsoft.TeamFoundation.PowerShell
	}
	
	#help
	#Get-Command -module Microsoft.TeamFoundation.PowerShell
}

Function Register-TfsAlias {
	$Paths = `
		"C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\TF.exe",
		"C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\TF.exe",
		"C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\TF.exe",
		"C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe"
		
	$aliasFound = $false
	foreach ($path in $Paths) {
		if (Test-Path $path) {
			Set-Alias tf -Value $path -Scope "Script"
			$aliasFound = $true
			break;
		}
	}
	
	if (-not $aliasFound) {
		throw "Cannot find path for tf.exe"
	}
}

Function Initialize {
	Register-TfsPlugin
	Register-TfsAlias
}

Function Is-Excluded([Parameter(Mandatory=$true)][string]$Value, [Parameter(Mandatory=$true)][string[]]$Exclude) {
	if (-not $Exclude) { return $false; }
	foreach ($item in $Exclude) {
		if ($Value -match $item) { return $true; }
	}
	return $false;
}


#-----------------------------------------------------------[Initialize]-----------------------------------------------------------
Clear-Host
Initialize
Set-Location "C:\TFS\Zeus\1_Main"
#Set-Location "C:\TFS\Zeus\3_Stage\Web\Code OnTime\Projects\DotNetNuke Factory\ZWClubes\WebApp\App_Data\"

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$MinSize = [int]1e7
$ShowVersionedFiles = $true
$ShowUnversionedFiles = $true
$Exclude = '\\BaseDatos$', '\\Web$', '\\Windows$', '\\Windows\\Front$', '\\Code OnTime\b',
			'Comun\\Dnn\\Gadgets', 
			'\\(Controles|DotNetNuke|Extensiones|Logica)\\(bin|obj)\b', 
			"\\InnoSetupSamples\b", "\\_InnoSetupLibraries\b", 
			"\\ligerasdnn\b", "\\zeusdnn\b", 
			'\.csproj\.user$'
#C:\TFS\Zeus\3_Stage\dist\Versiones\002-V14.1_SP8\SitioWeb\zeusdnn
$MinSize = 0
$ShowVersionedFiles = $false


#---------------------------------------
$filteredFiles = Get-ChildItem . -Recurse | ? { ($_.Length -gt $MinSize -or $MinSize -eq 0) -and (-not (Is-Excluded $_.Fullname $Exclude))  }
if ($MinSize -gt 0) {
	$filteredFiles = $filteredFiles | Sort-Object -Property Length -Descending
}

foreach($file in $filteredFiles) {
	$versionedFile = Get-TfsItemProperty $file.FullName
	$isVersioned = $versionedFile -ne $null
	
	$showFile = ($ShowVersionedFiles -and $isVersioned) -or ($ShowUnversionedFiles -and !$isVersioned)
	
	if ($showFile) {
		if ($versionedFile) { $Color = "Blue" } else { $Color = "Red" }
		if ($versionedFile) { $itemHistoryCount = (Get-TfsItemHistory $file.FullName).Count }
		else { $itemHistoryCount = 0 }
		Write-Host ("[{0:#,#}] {1} [{2}]" -f $file.Length, $file.FullName, $itemHistoryCount) -ForegroundColor $Color
		if ($versionedFile) {
			$versionedFile.TargetServerItem
			#Get-TfsItemHistory $file.FullName | ft -AutoSize
			#$itemHistoryCount
		}
	}
}


