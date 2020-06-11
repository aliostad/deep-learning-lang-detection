<#
    SRAC Installation Conductor for Windows
    Author: Leben Asa (GMU-2014)
    Install SRAC load module from translated C sources.
#>

if($SRAC_Code -eq $null) {
    "Don't forget to edit SRAC_Code to correct SRAC installation directory."
    "Running script with manual SRAC_Code definition"
    $global:SRAC_Code = "D:/SRACs/SRAC"
}

" XXX Production of SRAC load module started."
if($CComp -eq $null) {
    $global:CComp = "gcc"
}
if($CFlag -eq $null) {
    $global:CFlag = "-DPOSIX_C"
}

#---------- Set Load Module Name & Directory Name of Include Statement
$LMN = "$SRAC_Code/bin/SRAC.100m"

#---------- Make Working Directory -------------------------------
$Date = Get-Date -uformat "%Y.%m.%d.%H.%M.%S"
$Workdir = "$SRAC_Code/tmp/tmpSRAC.$Date"

mkdir $Workdir
cd "$SRAC_Code/src/F2C"
cp *.c $Workdir

#---------- Compile C programs ----------------
cd $Workdir
&"$CComp" -c $CFlags *.c
"--- end compile process for C-programs ---"

#---------- Link all objects --------
&"$CComp" -o $LMN *.o
"--- end linking process ---"

cd "$SRAC_Code/bin"

function LmToExe {
    $Dir = Get-Location
    mkdir "tmp"
    cp '*.100m' "tmp"
    Get-ChildItem *.100m | Rename-Item -NewName { $_.name -replace '\.100m', '.exe' }
    Move-Item "tmp/*" -Destination $Dir
    Remove-Item "tmp"
}

LmToExe
cd .
Remove-Item $Workdir

" XXX Production of SRAC load module completed."
" XXX All processes completed."