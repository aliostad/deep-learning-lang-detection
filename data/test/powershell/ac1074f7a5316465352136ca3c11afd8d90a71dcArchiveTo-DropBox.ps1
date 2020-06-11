$date = get-date -format "yyyyMMddThhmmss"

$rootDirectory = "c:\home\my dropbox\DevelopmentTools\BlueDot_$date";

New-Item -type directory -path "$rootDirectory"

# Cygwin
$cygwinDirectory  = "$rootDirectory\Cygwin"
New-Item -type directory -path "$cygwinDirectory"
Copy-Item "c:\home\cygwin\Cygwin.bat" -destination "$cygwinDirectory"
Copy-Item "c:\home\cygwin\users\awhite\.tcshrc" -destination "$cygwinDirectory"
Copy-Item "c:\home\cygwin\users\awhite\.dircolors" -destination "$cygwinDirectory"
Copy-Item "c:\home\cygwin\users\awhite\bin\*" -destination "$cygwinDirectory"

# PowerShell
$powershellDirectory = "$rootDirectory\PowerShell"
New-Item -type directory -path "$powershellDirectory"
Copy-Item "c:\Documents and Settings\awhite\My Documents\WindowsPowerShell\*" "$powershellDirectory"
Copy-Item -recurse "c:\windows\system32\WindowsPowerShell\v1.0\Modules" "$powershellDirectory"
Copy-Item "c:\home\powershell\*" "$powershellDirectory"

# Git
$gitDirectory = "$rootDirectory\Git"
New-Item -type directory -path "$gitDirectory"
Copy-Item "c:\Documents and Settings\awhite\.gitconfig" "$gitDirectory"
Copy-Item "c:\Program Files\Git\cmd\git-diffmerge-diff.sh" "$gitDirectory"
Copy-Item "c:\Program Files\Git\cmd\git-diffmerge-merge.sh" "$gitDirectory"

# Vim
$vimDirectory = "$rootDirectory\Vim"
New-Item -type directory -path "$vimDirectory"
Copy-Item "c:\program files\vim\vim72\vimrc_example.vim" "$vimDirectory"
Copy-Item "c:\program files\vim\vim72\gvimrc_example.vim" "$vimDirectory"
Copy-Item "c:\program files\vim\vim72\syntax\log4j.vim" "$vimDirectory"
Copy-Item "c:\program files\vim\vim72\syntax\ps1.vim" "$vimDirectory"
