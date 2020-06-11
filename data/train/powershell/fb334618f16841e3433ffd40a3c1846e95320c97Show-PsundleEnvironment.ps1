<#
  .SYNOPSIS
  Displays information about the installed Psundle Modules.
#>
function Show-PsundleEnvironment(){
  $file = New-Object "System.IO.FileInfo" (Get-Module psundle)[0].Path
  $directory = $file.Directory.FullName
  pushd $directory
  $fetchData = (git fetch)
  $updates = (git log head..origin/master --oneline)
  popd

  $hash = @{
    "Module"= $file.Basename
    "Path"=$file.FullName
    "Updates" = [Array]$updates
    "HasUpdates" = ($updates.Length -gt 0)
    }

  $result = New-Object PSObject -Property $hash
  $result

  Get-PsundleModules | foreach { Get-PsundleModuleUpdates $_}
}
