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

Describe "Invoke-OneDriveApiCall" {

    Context "-> Authenticate and GET" {

        It "authenticates if no token is present" {
            Invoke-OneDriveApiCall -Path 'drive'
            $PSOD.token | Should Not BeNullOrEmpty
        }

        It "gets the default drive" {
            $response = Invoke-OneDriveApiCall -Path 'drive'
            $response | Should Not BeNullOrEmpty
        }

        $path = 'drive/root:/'

        It "gets items by path" {
            $response = Invoke-OneDriveApiCall -Path $path
            $response.name | Should Be 'root'
        }

        It "takes the path as pipeline input" {
            $response = $path | Invoke-OneDriveApiCall
            $response.name | Should Be 'root'
        }

        It "takes pipeline input by property name" {
            $obj = [pscustomobject]@{ Path = $path }
            $response = $obj | Invoke-OneDriveApiCall
            $response.name | Should Be 'root'
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $uri }

        It "works even with incorrect slashes" {
            $rsp = Invoke-OneDriveApiCall -Path 'wrong\slashes\'
            $rsp | Should Be ($PSOD.api.url + "wrong/slashes/")
        }

    }

    Context "-> Correctly sets parameters for Invoke-RestMethod" {

        Mock -ModuleName PSOD -CommandName Get-OneDriveAuthtoken -MockWith {
            return ("http://localhost:8080/#access_token=ABC123==&token_type=bearer&expires_in=3600&scope=onedrive.readwrite files.read&user_id=uid123" | New-OneDriveToken) 
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $Method }

        It "Method" {
            $m = Invoke-OneDriveApiCall -Path "drive" -Method POST
            $m | Should Be "POST"
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $Body }

        It "Body" {
            $body = [ordered]@{
                name   = 'TestFolder'
                folder = @{}
            } | ConvertTo-Json
            $m = Invoke-OneDriveApiCall -Path "drive" -Body $body
            $m | Should Be $body
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $Headers }

        $defaultHeaders = @{
            Authorization = "bearer $($PSOD.token)"
            Accept        = 'application/json'
        }

        It "Headers" {
            $m = Invoke-OneDriveApiCall -Path "drive"
            $defaultHeaders.Count -eq $m.Count -and 
                -not ($m.Keys | ? { $m[$_] -ne $defaultHeaders[$_] }) |
                Should Be $true
        }

        It "Additional Headers" {
            $additionalHeaders = @{ Additional = "Test" }
            $allHeaders = $defaultHeaders + $additionalHeaders
            $m = Invoke-OneDriveApiCall -Path "drive" -AdditionalRequestHeaders $additionalHeaders
            $allHeaders.Count -eq $m.Count -and 
                -not ($m.Keys | ? { $m[$_] -ne $allHeaders[$_] }) |
                Should Be $true
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $InFile }

        It "InFile" {
            $m = Invoke-OneDriveApiCall -Path "drive" -InFile "c:\path\file.txt"
            $m | Should Be "c:\path\file.txt"
        }

        Mock -ModuleName PSOD Invoke-RestMethod { return $OutFile }

        It "OutFile" {
            $m = Invoke-OneDriveApiCall -Path "drive" -OutFile "c:\path\file.txt"
            $m | Should Be "c:\path\file.txt"
        }

    }

    Context "-> Error handling" {

        Set-Variable -Name ErrorActionPreference -Scope Global -Value Stop

        It "handles WebExceptions correctly" {
            try {
                Invoke-OneDriveApiCall -Path 'doesnotexist'
            } catch {
                $except = $_
            }
            $except.Exception.Message | Should Be "'doesnotexist' - Invalid API or resource. (Error code: invalidRequest)"
        }

        It "handles all other errors differently" {
            $PSOD.api.url = "test:\\api-path"
            try {
                Invoke-OneDriveApiCall -Path 'anothererror'
            } catch {
                $except = $_
            }
            $except.Exception.Message | Should Be "The URI prefix is not recognized."
        }

    }

}
