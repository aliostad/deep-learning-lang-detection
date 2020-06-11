#-----------------------------------------------------------------------------#
# User Interfaces and Input
#-----------------------------------------------------------------------------#

Import-Module "C:\PS\01 - Intro\PuttingItAllTogether_Functions.ps1"

$title = "Pick something really cool" 

$menu = @"
  1. Pluralsight
  2. Arcane Code
  3. Bow ties
  4. Fezzes
  5. Bugatti Veyrons
 
"@

Set-AppColors
Clear-Host
Display-AppHeader $title
$menu

$choice = Read-Host -Prompt "Select a Menu Option: "

Write-Host  
Write-Host "You thought number $choice was really cool! "
Write-Host  
$reason = Read-Host -Prompt "What makes you think that?"

Write-Host  
Write-Host "Oh, so you think ""$reason"" is a good reason. Interesting. Lets save that for later!"

$file = Read-Host -Prompt "Enter a file name to save it to, or just hit enter to not save it"

if ($file.Length -gt 0)
{
  Write-TxtFile $file $reason # -debug # Add -debug to display debugging aids
}
else
{
  "You chose not to save your reason. Pity, it was a good one."
}  
