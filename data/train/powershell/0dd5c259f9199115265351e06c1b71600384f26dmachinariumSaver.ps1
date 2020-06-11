####################################################################################
# @author Foresterre
#
# @required Requires a destination to be set
#           
#
####################################################################################

####################################################################################
# Settings 
####################################################################################

# Settings: Destination of the save file
#           The default location (desktop) will be used if this path does not exist.
$dest = "C:\Machinarium"

####################################################################################
# & locations
####################################################################################

# default save location to use if given location is invalid
$desktop = [Environment]::GetFolderPath("Personal")
$defaultDestLocation = Join-Path -path $desktop -childPath "MachinariumSave\saves"

$destLocationExists = Test-Path $dest
if ($destLocationExists -ne $True) {
    $dest = $defaultDestLocation
}

Write-Host "---------------------------------------------------------------------- "
Write-Host ""
Write-Host "   Save file copier Part I =)"
Write-Host "   Duty: Copy save file of Machinarium from FlashPlayer settings to    "
Write-Host "   $dest"
Write-Host ""
Write-Host "---------------------------------------------------------------------- "

$fpPart = "Macromedia\Flash Player\#SharedObjects\"
$saveFile = "Machinarium.sol"

$soLoc = Join-Path -path $env:APPDATA -childPath $fpPart

# Find the Machinarium path
$mapLoc = Get-ChildItem $soLoc -rec -include *Machinarium.exe*

# Join the path with the savefile
$fullLoc = Join-Path -path $mapLoc -childPath $saveFile


# Check whether the given directories exist.
$locExists = Test-Path $fullLoc
$destExists = Test-Path $dest

Write-Host "---------------------------------------------------------------------- "
Write-Host ""
Write-Host "   Machinarium location := "
Write-Host "   $fullLoc"
Write-Host ""
Write-Host "---------------------------------------------------------------------- "

####################################################################################
# Actual save file copying
####################################################################################


# Save file to folder
if ($locExists -eq $True) {
    Write-Host "Machinarium location exists"
    
    if ($destExists -ne $True) {
        New-Item -ItemType Directory -Force -Path $dest
    }

    Write-Host "Copying savefile..."
    Copy-Item  $fullLoc  $dest -Recurse -Force
    
} else {
    Write-Host "ERROR Unable to find the location of Machinarium, finishing..."
}

Write-Host ""
Write-Host "Program finished..."
