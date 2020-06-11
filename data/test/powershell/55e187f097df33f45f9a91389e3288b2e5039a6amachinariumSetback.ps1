####################################################################################
# @author Foresterre
#
# @required Requires a valid backup location
#
# Run before starting Machinarium.
# If the hash and Machinarium folders already exist in the flash player path,
# it will use this path. Otherwise it will use a default path.
####################################################################################

####################################################################################
# Settings
####################################################################################

# Settings: Destination of the save file
#           The default location (desktop) will be used if this path does not exist.
$saveLocation = "C:\Machinarium"

####################################################################################
# & locations
####################################################################################

# second location to try if given location is invalid
$desktop = [Environment]::GetFolderPath("Personal")
$defaultSaveLocation = Join-Path -path $desktop -childPath "MachinariumSave\saves"

$saveLocationExist = Test-Path $saveLocation
if ($saveLocationExist -ne $True) {
    $saveLocation = $defaultSaveLocation
}

# default flash player path
$cantFindPath = Join-Path -path $env:APPDATA -childPath "Macromedia\Flash Player\#SharedObjects\AAAAAAAA\localhost\Program\Steam\steamapps\common\Machinarium\Machinarium.exe"

Write-Host "---------------------------------------------------------------------- "
Write-Host ""
Write-Host "   Save file copier Part II (Restores the save file) =)"
Write-Host "   Duty: Copy save file of Machinarium from $saveLocation to    "
Write-Host "   FlashPlayer local data"
Write-Host ""
Write-Host "---------------------------------------------------------------------- "

# static info
$fpPart = "Macromedia\Flash Player\#SharedObjects\"
$saveFile = "Machinarium.sol"
$soLoc = Join-Path -path $env:APPDATA -childPath $fpPart


# the following two assignments will throw an error when the path is not found.
# However, since it's an operational error, it can not silently be caught.
# If these will be thrown, don't bother, the script will use the default path.

# find the Machinarium path
$mapLocation = Get-ChildItem $soLoc -rec -include *Machinarium.exe*  -force

# Check whether the given directories exist.
$mapLocationExists = Test-Path $mapLocation


if ($mapLocationExists -ne $True) {
    Write-Host "Could'nt find Machinarium appdata save path, using default := "
    Write-Host $cantFindPath
    $mapLocation = $cantFindPath
}

# join the path with the savefile
$saveFileFull = Join-Path -path $saveLocation -childPath $saveFile


$saveFileFullExists = Test-Path $saveFileFull



Write-Host "---------------------------------------------------------------------- "
Write-Host ""
Write-Host "   Machinarium save location := "
Write-Host "   $mapLocation"
Write-Host ""
Write-Host "---------------------------------------------------------------------- "

####################################################################################
# Actual save file copying
####################################################################################


# Set the savefile back
if ($saveFileFullExists -eq $True) {
    
    if ($mapLocationExists -ne $True) {
        Write-Host "ERROR Unable to find the location of the Machinarium save location"
        Write-Host "Creating location"
        New-Item -ItemType Directory -Force -Path $mapLocation
    }

    Write-Host "Copying savefile..."
    Copy-Item  $saveFileFull  $mapLocation -Recurse -Force
    
} else {
    Write-Host "ERROR Unable to find the location of the save, finishing..."
}

Write-Host ""
Write-Host "Program finished..."
