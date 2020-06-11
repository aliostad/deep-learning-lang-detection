################################################################################
# Author     : Antony Onipko
# Copyright  : (c) 2016 Antony Onipko. All rights reserved.
################################################################################
# This work is licensed under the
# Creative Commons Attribution-ShareAlike 4.0 International License.
# To view a copy of this license, visit
# https://creativecommons.org/licenses/by-sa/4.0/
################################################################################

. $PSScriptRoot\setup-test.ps1

Describe "Remove-OneDriveItem" {

    $path    = "PSOD/odrm"
    $file1   = "doc1.docx"
    $file2   = "excel1.xlsx"
    $folder1 = joinPath $path 'Folder1'
    $folder2 = joinPath $path 'Folder2'

    $timeToCopy = 5 # Seconds. Increase if getting test failures.

    # setup test
    $copyPath = "PSOD/odcp"
    $copyFolder = joinPath $copyPath 'Folder1' 
    @(
        $copyFolder
        (joinPath $copyPath 'Folder2')
        (joinPath $copyFolder $file1)
        (joinPath $copyFolder $file2)
    ) | Copy-OneDriveItem -Destination $path
    Start-Sleep -Seconds $timeToCopy

    It "check test folder setup (if this fails, results might not be accurate)" {
        $rsp = Get-OneDriveChildItem -Path $path -Recurse
        $rsp.Count | Should Be 6
    }

    Context "-> Remove file" {
        It "remove file by path" {
            $p = joinPath $path $file1
            $rsp = Remove-OneDriveItem -Path $p
            $check = Get-OneDriveItem -Path $p -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
        It "remove file by id" {
            $p = joinPath $path $file2
            $id = (Get-OneDriveItem $p).id
            $rsp = Remove-OneDriveItem -ItemId $id
            $check = Get-OneDriveItem -ItemId $id -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
    }

    Context "-> Remove directory" {
        It "remove directory by path" {
            $rsp = Remove-OneDriveItem -Path $folder1
            $check = Get-OneDriveItem -Path $folder1 -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
        It "remove directory by id" {
            $id = (Get-OneDriveItem $folder2).id
            $rsp = Remove-OneDriveItem -ItemId $id
            $check = Get-OneDriveItem -ItemId $id -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
    }

    # setup test 
    @(
        (joinPath $copyFolder $file1)
        (joinPath $copyFolder $file2)
    ) | Copy-OneDriveItem -Destination $path
    Start-Sleep -Seconds $timeToCopy

    Context "-> Alias" {
        It "works with the alias odrm" {
            $p = joinPath $path $file1
            $rsp = $p | odrm
            $check = Get-OneDriveItem -Path $p -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
        It "works with the alias oddel" {
            $p = joinPath $path $file2
            $rsp = oddel $p
            $check = Get-OneDriveItem -Path $p -ErrorAction SilentlyContinue
            $rsp -and ($check -eq $null) | Should Be $true
        }
    }

}
