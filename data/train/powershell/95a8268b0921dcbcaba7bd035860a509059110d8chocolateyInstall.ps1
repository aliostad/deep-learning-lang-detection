$package = 'VirtualBox.ExtensionPack'
$version = '4.3.16'
$build = '95972'
$packName = "Oracle_VM_VirtualBox_Extension_Pack-$version-$build.vbox-extpack"
$packUrl = "http://download.virtualbox.org/virtualbox/$version/$packName"

try {
  # simulate the unix command for finding things in path
  # http://stackoverflow.com/questions/63805/equivalent-of-nix-which-command-in-powershell
  function Which([string]$cmd)
  {
    Get-Command -ErrorAction "SilentlyContinue" $cmd |
      Select -ExpandProperty Definition
  }

  function Install-ExtensionPack([string] $url)
  {
    $vboxManageDefault = Join-Path $Env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe'

    $vboxManage = (Which VBoxManage),
      $vboxManageDefault |
      ? { $_ -and { Test-Path $_ } } |
      Select -First 1

    if (!$vboxManage)
    {
      throw 'Could not find VirtualBox VBoxManage.exe to install extension pack with'
    }

    $fileName = $url -split '/' | Select -Last 1
    $appTemp = Join-Path $Env:Temp $package
    if (!(Test-Path $appTemp))
    {
      New-Item $appTemp -Type Directory
    }
    $packageTemp = Join-Path $appTemp $fileName
    Get-ChocolateyWebFile -url $url -fileFullPath $packageTemp

    Push-Location $appTemp
    &$vboxManage extpack install --replace $packName
    Pop-Location
  }

  Install-ExtensionPack $packUrl

  if ($LASTEXITCODE -ne 0)
  {
    Write-ChocolateyFailure $package @"
Due to a VirtualBox bug, VBoxManage appears unresponsive.

Please reboot the machine, and reinstall this packge with the -force switch.

cinst $package -force
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
