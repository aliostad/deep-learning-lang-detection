# environment variables

Write-Host "Loading Environment Variables..." -NoNewline
. "$Home\Documents\WindowsPowershell\LoadEnvVars.ps1"
Write-Host "Done"
# set up build environment


Write-Host "Loading Visual Studio Environment...." -NoNewline
. "$Home\Documents\WindowsPowershell\LoadVisualStudioEnvironment.ps1"
Write-Host "Done"

Write-Host "Loading poshgit..."
# source git module
. 'C:\tools\poshgit\dahlbyk-posh-git-869d4c5\profile.example.ps1'
Write-Host "Done"

# aliases
Set-Alias vim vim.exe
