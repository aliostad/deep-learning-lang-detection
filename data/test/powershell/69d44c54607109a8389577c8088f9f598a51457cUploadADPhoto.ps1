$SAMName=Read-Host "Administrator"

$root = [ADSI]'GC://dc=digitaltulip,dc=net'
$searcher = new-object System.DirectoryServices.DirectorySearcher($root)
$searcher.filter = "(&(objectClass=user)(sAMAccountName=$SAMName))"
$user = $searcher.findall()
$userdn = $user[0].path
$userdn = $userdn.trim("GC")
$userdn = "LDAP" + $userdn

function Select-FileDialog
{
param([string]$Title,[string]$Directory,[string]$Filter="All Files (*.*)|*.*")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
$objForm = New-Object System.Windows.Forms.OpenFileDialog
$objForm.InitialDirectory = $Directory
$objForm.Filter = $Filter
$objForm.Title = $Title
$objForm.ShowHelp = $true
$Show = $objForm.ShowDialog()
If ($Show -eq "OK")
{
Return $objForm.FileName
}
Else 
{
Write-Error "Operation canceled by user."
}
}

$photo = Select-FileDialog -Title "Select a photo" -Directory "%userprofile%" -Filter "JPG Images (*.jpg)|*.jpg|PNG Images (*.png)|*.png"

$user = [ADSI]($userdn)
[byte[]]$file = Get-Content $photo -Encoding Byte

# clear previous image if exist 
$user.Properties["thumbnailPhoto"].Clear()

# write the image to the user's thumbnailPhoto attribute by converting the byte[] to Base64String 
$result = $user.Properties["thumbnailPhoto"].Add($file)

# commit the changes to AD 
$user.CommitChanges()

if ($result -eq "0")
{
Write-Host "Photo successfully uploaded."
} 
else
{
Write-Error "Photo was not uploaded."
}