#######################################################################
# Default PowerShell Profile
#
# Attempts to load the profile from ~/.dotfiles, if installed
########################################################################

$dotfiles = "$env:HOME.dotfiles"

if ( test-path $dotfiles ) {
  . "$dotfiles\powershell\profile.ps1"
} else {
  Write-Host "[Warning]" -foregroundcolor magenta -backgroundcolor yellow -nonewline
  Write-Host " ~/.dotfiles" -foregroundcolor red -nonewline
  Write-Host " not installed. You'll need to change the default profile."
  Write-Host ""
}
