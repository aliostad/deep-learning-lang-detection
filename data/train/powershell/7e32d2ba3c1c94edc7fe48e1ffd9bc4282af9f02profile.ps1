########################################################################
# PowerShell Initialization Script
#
# Make sure profile.default.ps1 is installed to
#   ~/Documents/{User}/WindowsPowerShell/profile.ps1
########################################################################


#
# Set the $HOME variable for our user
# and make powershell recognize ~\ as $HOME in paths
#
$env:HOME = resolve-path (join-path ([environment]::getfolderpath("mydocuments")) "..\")
set-variable -name HOME -value (resolve-path $env:HOME) -force
(get-psprovider FileSystem).Home = $HOME

#
# Global and core env variables
#
$HOME_ROOT  = [IO.Path]::GetPathRoot
$PROJECTS = "$HOME_ROOT\Projects"
$DOTFILES = "$HOME\.dotfiles"
$PS = "$DOTFILES\powershell"
$env:EDITOR = 'sublime_text.exe -nw'

#
# Load all path first
#
. "$PS\path.ps1"

#
# Load all other config files
#
ls "$PS\*.ps1" -exclude profile.*,path.* | %{
  . (resolve-path $_)
}

#
# Set the shell and OS default location
#

#set-location $HOME
[System.Environment]::CurrentDirectory = $HOME