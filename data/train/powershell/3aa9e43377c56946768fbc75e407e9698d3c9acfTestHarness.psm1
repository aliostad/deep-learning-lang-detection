#requires -Version 2
$ErrorActionPreference = "Stop"

[bool]$script:AllTestsPassingAfterFixScriptRun = $true
[bool]$script:FixesMade = $false

function Write-TSProblem ([string]$Message) {
    Write-Host "Problem: $Message" -ForegroundColor Yellow
}

function Write-TSManualStep ([string]$Message) {
    Write-Host "Manual Step: $Message"
    if ($Confirm) {
        $Response = Read-Host -Prompt " Enter A to abort, anything else to continue"
        if ($Response -eq "a") { exit }
    }
}

function Write-TSFix ([string]$Message) {
    Write-Host "Fix Applied: $Message"
}

function ExecuteTest
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [string]$AssertionMessage,
        [ScriptBlock]$TestScript,
        [ScriptBlock]$FixScript
    )
    process {
        Write-Debug "Testing that $AssertionMessage"
        $Passed = & $TestScript
        if ($Passed)
        {
            Write-Verbose "Test passed for $AssertionMessage"
            return
        }
        Write-Verbose "Test failed for $AssertionMessage"

        if ($FixScript -eq $null)
        {
            $script:AllTestsPassingAfterFixScriptRun = $false
            Write-TSManualStep "Manually resolve '$AssertionMessage' (no automated fix script available)"
            return
        }

        if ($PSCmdlet.ShouldProcess($AssertionMessage, "Attempt automatic fix"))
        {
            $script:FixesMade = $true
            Write-Debug "Applying fix for $AssertionMessage"
            & $FixScript
            Write-Debug "Applied fix $AssertionMessage"
            Write-Verbose "Testing that $AssertionMessage"
            if (& $TestScript)
            {
                Write-Verbose "Test passed for $AssertionMessage"
            }
            else
            {
                $script:AllTestsPassingAfterFixScriptRun = $false
                Write-TSProblem "Automatic fix for '$AssertionMessage' failed: problem remains (you need to fix the fix script)"
            }
        }
    }
}

function Write-TestSummary()
{
    if ($script:AllTestsPassingAfterFixScriptRun) {
        if ($script:FixesMade) {
            Write-Host "All tests now passing (fixes were applied)" -ForegroundColor Green
        }
        else {
            Write-Host "All tests passed (no fixes applied)" -ForegroundColor Green
        }
        Write-Host "If you are still experiencing an issue, diagnose the problem then add more tests here to prevent it in the future" -ForegroundColor Green
    }
    else {
        throw "Some tests still failing (fixes failed, or manual steps required)"
    }
}

function Test-PSInstanceMatchesOSBitness {
    Write-Debug "Checking that we're running in the correct PowerShell console for the OS"
    if (@(Get-WmiObject -Class Win32_OperatingSystem)[0].OSArchitecture -eq "64-bit") {
        if ([IntPtr]::Size -ne 8) {
            throw "This script must run in a 64-bit PowerShell instance when using a 64-bit operating system."
        }
    }
}

function Test-PSInstanceIsElevated {
    Write-Debug "Checking that we're running in an elevated PowerShell instance"
    $Principal = New-Object -TypeName System.Security.Principal.WindowsPrincipal -ArgumentList ([System.Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "This script must run in an elevated PowerShell instance."
    }
}
