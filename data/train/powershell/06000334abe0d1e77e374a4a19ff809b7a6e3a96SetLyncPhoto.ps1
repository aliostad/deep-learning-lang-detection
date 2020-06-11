$userNK = "nkXXXXXXX"
$photoPath = "C:\Software\photo.jpg"

$loadSnapin = 0
$snapins = Get-PSSnapin
foreach ($snapin in $snapins){
    if ($snapin.Name -eq "Quest.ActiveRoles.ADManagement"){
        $loadSnapin = 1
        break
    }
}
if (!$loadSnapin){
    Add-PSSnapin Quest.ActiveRoles.ADManagement
}

$user = Get-QADObject $userNK -IncludeAllProperties
write-output $user.thumbnailPhoto

$photoExists = Test-Path $photoPath
if ($photoExists){
    $photo = [byte[]] (Get-Content $photoPath -Encoding byte)
    if ($photo){
        Set-QADUser $userNK -ObjectAttributes @{thumbnailPhoto=$photo}
        Set-QADUser $userNK -ObjectAttributes @{jpegPhoto=$photo}
        Write-Output "Profile image updated"
    }
}else{
    Write-Host -ForegroundColor Red "Photo not found"
}
