# Oh my powershell !
#
#############################

# Color tests (uncomment to DO IT)
#. (Resolve-Path ~/Documents/WindowsPowershell/color_test.ps1)

# Call git utilities
. (Resolve-Path ~/Documents/WindowsPowershell/gitutils.ps1)

# Call SVN utils
. (Resolve-Path ~/Documents/WindowsPowershell/svnutils.ps1)

# Load Aliases
. (Resolve-Path ~/Documents/WindowsPowershell/aliases.ps1)

# Load Aliases
. (Resolve-Path ~/Documents/WindowsPowershell/path_utils.ps1)

# Global customs
$Global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$UserType = "User"
$CurrentUser.Groups | foreach { if($_.value -eq "S-1-5-32-544") {$UserType = "Admin"} }

# The prompt function itself
function prompt {
  Write-host("")

  # Function to write path
  writePath
  
  # Add versioning infos
  if (isCurrentDirectoryGitRepository) {
    (writeGitInfo)
  }
  elseif(isCurrentDirectorySvnRepository) {
    (writeSvnInfo)
  }
  
  return "`n$ "
}