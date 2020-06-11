function DownloadReadline() {
	$psget = Join-Path $([System.IO.Path]::GetDirectoryName($Profile)) "Modules\PsGet\PsGet.psm1"
	if (Test-Path $psget) {
		Import-Module $psget
	} else {
		(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
	}
}

function LoadMacros($file) {
	if (Test-Path "$PSScriptRoot\$file") {
		doskey /EXENAME=PowerShell.exe /MACROFILE="$PSScriptRoot\$file"
	}
}

# Not loading by default as it breaks doskey
function LoadReadline() {
	Install-Module PSReadline
	Set-PSReadlineKeyHandler -Key Enter -Function AcceptLine
	Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function DeleteCharOrExit
	Set-PSReadlineKeyHandler -Key 'Ctrl+k' -Function KillLine
	Set-PSReadlineKeyHandler -Key 'Ctrl+u' -Function BackwardKillLine
}

function b64ToHex($str) {
    [System.BitConverter]::ToString([System.Convert]::FromBase64String($str)).Replace("-", "")
}

function Add-Path($path) {
	if (Test-Path $path) {
		$env:path = "$path;" + $env:path
	}
}

LoadMacros "aliases.doskey"
LoadMacros "aliases_powershell.doskey"

Add-Path "$PSScriptRoot\..\..\Apps\bin"

$script = Join-Path "$PSScriptRoot\..\prog\PS" "$env:ComputerName.ps1"
if (Test-Path $script) {
	Write-Host "Loading $script"
	. $script
}
Remove-Variable script

