$script_dir = Split-Path -parent $MyInvocation.MyCommand.Definition

function isItThere($cmd) {
	try {
		"$cmd --version" | iex | %{$isItTherevstr = $_}
		return $isItTherevstr.Length -gt 0
	} catch {
		return $false
	}
}

if (isItThere("VBoxManage")) {
	echo "VBoxManage already in the PATH"
	exit 0
}

$vboxInstall = ${env:ProgramFiles}, ${env:ProgramFiles(x86)} | %{ "$_\Oracle\VirtualBox"} |  ?{ Test-Path $_ } | select -First 1
$env:Path += ";$vboxInstall"
[System.Environment]::SetEnvironmentVariable("PATH", $env:Path, "User")
echo "Added VBoxManage to the PATH"
