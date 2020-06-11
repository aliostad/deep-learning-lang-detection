# Windows PowerShell
# テスト実行

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### 処理実行
######################################################################

###
### 前処理
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### 主処理
###

Write-Output $sep
Invoke-Expression "$basedir\CopyWithList.ps1"

Write-Output $sep
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test01"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir"

Write-Output $sep
Write-Output "オプション-Includeのテスト"
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test02"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir -Include ""\w{3}2"""

Write-Output $sep
Write-Output "オプション-Excludeのテスト"
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test03"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir -Exclude ""[^\w]c[^\w]"""

Write-Output $sep

###
### 後処理
###
Write-Verbose "$psName End"
