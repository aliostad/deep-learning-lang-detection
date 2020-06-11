
Write-Host "$($MyInvocation.MyCommand.Path)" -BackgroundColor Yellow 

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
. $ScriptDir\Check-HDF5SnapinFunction.ps1
. $ScriptDir\Check-OpenHandlesFunction.ps1
. $ScriptDir\Print-MessagesFunctions.ps1

Check-HDF5Snapin

################################################################################
CreateHeading '0001' 'h5tmp exists'

$count = 0
Get-PSDrive | ? { $_.Name -eq 'h5tmp' } | % {$count++}

ShowValues 1 $count; CreateFooter

################################################################################
CreateHeading '0002' '$Env:PSH5XTmpFile defined'

$count = 0
Get-ChildItem env: | ? { $_.Name -eq 'PSH5XTmpFile' } | % {$count++}

ShowValues 1 $count; CreateFooter

################################################################################
CreateHeading '0003' 'Map drive RO'

$a = New-PSDrive -Name h5_1 -PSProvider HDF5 -Path $ScriptDir\sample.h5 -Root h5_1:\

$count = 0
Get-PSDrive | ? { $_.Name -eq 'h5_1' } | % {$count++}

ShowValues 1 $count; CreateFooter

################################################################################
CreateHeading '0004' 'Remove drive'

Remove-PSDrive h5_1

$count = 0
Get-PSDrive | ? { $_.Name -eq 'h5_1' } | % {$count++}

ShowValues 0 $count; CreateFooter

################################################################################
CreateHeading '0005' 'Map drive RW'

$a = New-PSDrive -Name h5_1 -PSProvider HDF5 -Path $ScriptDir\sample.h5 -Root h5_1:\ -Mode RW

$count = 0
Get-PSDrive | ? { $_.Name -eq 'h5_1' } | % {$count++}

ShowValues 1 $count; CreateFooter

################################################################################
CreateHeading '0006' 'Remove drive'

Remove-PSDrive h5_1

$count = 0
Get-PSDrive | ? { $_.Name -eq 'h5_1' } | % {$count++}

ShowValues 0 $count; CreateFooter

################################################################################
CreateHeading '0007' 'Map drive with forced file creation'

$file = [System.IO.Path]::GetTempFileName()
Remove-Item $file

$a = New-PSDrive -Name h5_1 -PSProvider HDF5 -Path $file -Root h5_1:\ -Force
$count = 0
if (Test-Path $file) { $count++ }
Get-PSDrive | ? { $_.Name -eq 'h5_1' } | % {$count++}

Remove-PSDrive h5_1
Remove-Item $file

ShowValues 2 $count; CreateFooter

################################################################################
CreateHeading '0008' 'Non-terminating error on attempt to map a non-HDF5 file'

$count = 0

New-PSDrive -Name h5_1 -PSProvider HDF5 -Path $ScriptDir\no.h5 -Root h5_1:\ -Mode RW -ErrorAction SilentlyContinue

$count--

ShowValues -1 $count; CreateFooter

################################################################################
CreateHeading '0009' 'Non-terminating error on attempt to map a non-existing file'

$count = 0

New-PSDrive -Name h5_1 -PSProvider HDF5 -Path ([System.IO.Path]::GetRandomFileName()) -Root h5_1:\ -ErrorAction SilentlyContinue

$count--

ShowValues -1 $count; CreateFooter

Check-OpenHandles
