# Accept build from command line
param(
	[string]$build
)

# Define source, temporary, and destitation files

$tmpTar="C:\Temp\Temp.tar"
$srcOva="Z:\Product\TS_Buzz\AVE_OVFs\TS2014\5.8.0." + $build + "\vSphereDataProtection-5.8.ova"
$destOva="C:\OVAs\vSphereDataProtection-5.8-NoCert.ova"

# Copy from source to temporary. Build command and write to file, since Invoke-Expression called in the Start-Job ScriptBlock doesn't seem to work

Write-Host "Copying $srcOva to $tmpTar"

$cmd = "copy $srcOva $tmpTar"
$cmd > C:\Temp\Copy.ps1

#$copyJob = Start-Job -ScriptBlock { Invoke-Expression -Command $cmd }
$copyJob = Start-Job -ScriptBlock { C:\Temp\Copy.ps1 }

while($copyJob.State -eq "Running"){

   Write-Host "." -NoNewLine
    Sleep(1)

}


Write-Host "Copy complete, extracting $tmpTar"

# Switch to working in Temp
cd C:\Temp

# Extract File

$zipTool="C:\Program Files\7-Zip\7z.exe"
$zipOpts="x"

$cmd = "& '" + $zipTool + "' " + $zipOpts + " " + $tmpTar
Invoke-Expression $cmd

# Build new file, excluding certificate

#Creates wrong archive type (RAR)
#$zipTool="c:\Program Files\WinRAR\Rar.exe"
#$zipOpts="a"

#Creates correct archive type (Tar) with files out of order
$zipTool="c:\Program Files\7-Zip\7z.exe"
$zipOpts="a -ttar"

$cmd = "& '" + $zipTool + "' " + $zipOpts + " " + $destOva + " *.ovf"
Invoke-Expression -Command $cmd
$cmd = "& '" + $zipTool + "' " + $zipOpts + " " + $destOva + " *.vmdk"
Invoke-Expression -Command $cmd

# Cleanup. Delete temporary scripts and files
$cmd = "del C:\Temp\*"
#Invoke-Expression $cmd
