Set-PSDebug -Strict
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$PSScriptRoot\..\Forge\Get-ForgeContext.ps1"
. "$PSScriptRoot\..\Forge\Initialize-ForgeContext.ps1"
. "$PSScriptRoot\..\Forge\$sut"

Describe "Copy-ForgeFile" {
    function Get-CallerModuleName { return "Forge.Test" }
    Initialize-ForgeContext -SourceRoot (Setup -Dir Templates -PassThru) `
        -DestinationPath ($DestinationPath = Setup -Dir Destination -PassThru) `
        -Binding @{ a = "-" }

    Setup -File (Join-path Templates TEST) -Content "COU<%= `$a %>COU"

    Setup -File (Join-path Templates TEST1.eps) -Content "CUI<%= `$a %>CUI"

    It "should copy file" {
        Copy-ForgeFile -Source "TEST"

        "$DestinationPath\TEST" | Should Exist
        "$DestinationPath\TEST" | Should Contain "^COU-COU$"
    }

    It "should copy EPS file" {
        Copy-ForgeFile -Source "TEST1"

        "$DestinationPath\TEST1" | Should Exist
        "$DestinationPath\TEST1" | Should Contain "^CUI-CUI$"
    }

    It "should throw an error if source does not exist" {
        {
            Copy-ForgeFile -Source "TEST2"
        } | Should Throw "Unable to find either 'TEST2' or 'TEST2.eps' source file"
    }

    It "should copy file to new name" {
        Copy-ForgeFile -Source "TEST" -Destination "TEST1"

        "$DestinationPath\TEST"  | Should Not Exist
        "$DestinationPath\TEST1" | Should Exist
        "$DestinationPath\TEST1" | Should Contain "^COU-COU$"
    }

    It "should copy file to directory" {
        $SomeDirectory = New-Item -Type Container (Join-Path $DestinationPath SomeDir)

        Copy-ForgeFile -Source "TEST" -Destination SomeDir

        "$SomeDirectory\TEST"  | Should Exist
        "$SomeDirectory\TEST"  | Should Contain "^COU-COU$"
    }

    AfterEach {
        if ($DestinationPath) {
            Remove-Item -Recurse $DestinationPath/*
        }
   }
}
