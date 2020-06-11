$package = 'VirtualBox.ExtensionPack'
$vboxName = 'Oracle VM VirtualBox Extension Pack'

try {
  # simulate the unix command for finding things in path
  # http://stackoverflow.com/questions/63805/equivalent-of-nix-which-command-in-powershell
  function Which([string]$cmd)
  {
    Get-Command -ErrorAction "SilentlyContinue" $cmd |
      Select -ExpandProperty Definition
  }

  function Uninstall-ExtensionPack([string] $name)
  {
    $vboxManageDefault = Join-Path $Env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe'

    $vboxManage = (Which VBoxManage),
      $vboxManageDefault |
      ? { Test-Path $_ } |
      Select -First 1

    if (!$vboxManage)
    {
      throw 'Could not find VirtualBox VBoxManage.exe necessary to install extension pack'
    }

    &$vBoxManage extpack uninstall `"$name`"
  }

  Uninstall-ExtensionPack $vboxName

  if ($LASTEXITCODE -ne 0)
  {
    Write-ChocolateyFailure $package @"
Due to a VirtualBox bug, VBoxManage appears unresponsive.

Please reboot the machine, and attempt to uninstall the VirtualBox extension pack
using the command line:

VBoxManage extpack uninstall `"$vboxName`"
"@
  }
  else
  {
    Write-ChocolateySuccess $package
  }
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
