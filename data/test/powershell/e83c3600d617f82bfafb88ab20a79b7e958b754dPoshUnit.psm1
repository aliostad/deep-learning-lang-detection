#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
Trap { throw $_ }

if ((Get-Module NUnit) -eq $null)
{
    $nunitModulePath = "$PSScriptRoot\NUnit.psm1"

    if (-not (Test-Path $nunitModulePath))
    {
        throw "$nunitModulePath not found"
    }

    Import-Module $nunitModulePath
}

function Clear-PoshUnitContext
{
    $global:PoshUnitContext = New-Object PSObject -Property `
    @{
        TestsPassed = 0;
        TestsFailed = 0;
        TestFixturesFailed = 0;
        InsideInvokePoshUnit = $false;
        ShowStackTrace = $false;
        ShowErrors = $true;
        ShowOutput = $false;
        TestFixtureFilter = "*";
        TestFilter = "*";
    }
}

function Write-TestsSummary
{
    Write-Host ("Tests completed`nPassed: {0} Failed: {1}" -f $global:PoshUnitContext.TestsPassed, $global:PoshUnitContext.TestsFailed)
    if ($global:PoshUnitContext.TestFixturesFailed -ne 0)
    {
        Write-Host ("Test fixtures failed: {0}" -f $global:PoshUnitContext.TestFixturesFailed)
    }

    Write-Host "`n"
}

function Invoke-PoshUnit
{
    [CmdletBinding()]
    param
    (
        [string] $Path = "Tests",
        [string] $Filter = "*.Tests.ps1",
        [bool] $Recurse = $true,
        [bool] $ShowOutput = $false,
        [bool] $ShowErrors = $true,
        [bool] $ShowStackTrace = $false,
        [string] $TestFixtureFilter = "*",
        [string] $TestFilter = "*"
    )

    $global:PoshUnitContext = New-Object PSObject -Property `
    @{
        TestsPassed = 0;
        TestsFailed = 0;
        TestFixturesFailed = 0;
        InsideInvokePoshUnit = $true;
        ShowErrors = $ShowErrors;
        ShowStackTrace = $ShowStackTrace;
        ShowOutput = $ShowOutput;
        TestFixtureFilter = $TestFixtureFilter;
        TestFilter = $TestFilter;
    }

    $testFixtureFiles = Get-ChildItem -Path $Path -Filter $Filter -Recurse:$Recurse | `
        Select-Object -ExpandProperty FullName

    if (-not $testFixtureFiles)
    {
        Write-Warning "No TestFixture files found"
        return
    }

    foreach ($testFixtureFile in $testFixtureFiles)
    {

        Write-Verbose "Processing file '$testFixtureFile'"
        try
        {
            & $testFixtureFile
        }
        catch
        {
            Report-Error "Processing file '$testFixtureFile' failed" $_
        }
    }

    Write-TestsSummary

    Clear-PoshUnitContext
}

function Report-Error
{
    [CmdletBinding()]
    param
    (
        [string] $Message,
        [System.Management.Automation.ErrorRecord] $Error
    )

    $message = $Message
    if (($global:PoshUnitContext.ShowErrors) -and ($Error -ne $null))
    {
        $message += "`n$(Prepare-ErrorString $Error)"
    }

    Write-Host $message -ForegroundColor Red
}

function Prepare-ErrorString
{
    [CmdletBinding()]
    param
    (
        [System.Management.Automation.ErrorRecord] $Error
    )

    $invocationInfo = $Error.InvocationInfo

    $exception = $Error.Exception

    if ($exception -is [System.Management.Automation.MethodInvocationException])
    {
        $exception = $exception.InnerException
    }

    $errorMessage = "`n{0}`n{1}" -f $exception.Message, $invocationInfo.PositionMessage
    if ($global:PoshUnitContext.ShowStackTrace)
    {
        $errorMessage += ("`nStack trace:`n{0}" -f $Error.ScriptStackTrace)
    }

    $errorMessage;
}

function Invoke-Script
{
    param
    (
        [ScriptBlock] $ScriptBlock
    )

    $result = . $ScriptBlock
    if ($global:PoshUnitContext.ShowOutput)
    {
        $result
    }
}

function Test-Fixture
{
    [CmdletBinding()]
    param
    (
        [string] $Name,
        [ScriptBlock] $TestFixtureSetUp = {},
        [ScriptBlock] $TestFixtureTearDown = {},
        [ScriptBlock] $SetUp = {},
        [ScriptBlock] $TearDown = {},
        [PSObject[]] $Tests = @()
    )

    if ($Name -notlike $global:PoshUnitContext.TestFixtureFilter)
    {
        Write-Verbose "Skipping Test Fixture '$Name' because it is not matching filter"
        return
    }

    if (-not $global:PoshUnitContext.InsideInvokePoshUnit)
    {
        Clear-PoshUnitContext
    }

    Write-Host "Test Fixture '$Name'" -ForegroundColor Yellow

    $isTestFixtureFailed = $false
    $testsPassed = 0
    $testsFailed = 0

    try
    {
        . Invoke-Script $TestFixtureSetUp
    }
    catch
    {
        Report-Error "TestFixtureSetUp failed. All tests within this test fixture will be marked as failed as well" $_
        $isTestFixtureFailed = $true
    }

    foreach ($test in $Tests)
    {
        if ($test.Name -notlike $global:PoshUnitContext.TestFilter)
        {
            Write-Verbose "Skipping Test '$($test.Name)' because it is not matching filter"
            continue
        }

        $isTestPassed = $false

        Write-Host "`n    Test '$($test.Name)'" -ForegroundColor Yellow
        if ($isTestFixtureFailed)
        {
            Report-Error "Test fixture failed"
            $testsFailed++
            continue
        }

        try
        {
            . Invoke-Script $SetUp
        }
        catch
        {
            Report-Error "    SetUp failed. Test will be marked as failed as well" $_
            $testsFailed++
            continue
        }

        try
        {
            . Invoke-Script $test.Method
            Write-Host "    Passed" -ForegroundColor Green
            $isTestPassed = $true
        }
        catch
        {
            Report-Error "    Failed" $_
        }
        finally
        {
            try
            {
                . Invoke-Script $TearDown
                if ($isTestPassed)
                {
                    $testsPassed++
                }
                else
                {
                    $testsFailed++
                }
            }
            catch
            {
                Report-Error "    TearDown failed. Test will be marked as failed as well" $_
                $testsFailed++
            }
        }
    }

    Write-Host ""
    
    try
    {
        . Invoke-Script $TestFixtureTearDown
    }
    catch
    {
        Report-Error "TestFixtureTearDown failed. All tests within this test fixture will be marked as failed" $_
        $isTestFixtureFailed = $true
    }

    if ($isTestFixtureFailed)
    {
        $global:PoshUnitContext.TestFixturesFailed++
        $testsFailed += $testsPassed
        $testsPassed = 0
    }

    $global:PoshUnitContext.TestsPassed += $testsPassed
    $global:PoshUnitContext.TestsFailed += $testsFailed

    Write-Host ""

    if (-not $global:PoshUnitContext.InsideInvokePoshUnit)
    {
        Write-TestsSummary
        Clear-PoshUnitContext
    }
}

function Test
{
    [OutputType([PSObject])]
    [CmdletBinding()]
    param
    (
        [string] $Name,
        [ScriptBlock] $Method
    )

    New-Object PSObject -Property `
    @{
        Name = $Name;
        Method = $Method
    }
}

function Get-TempTestPath
{
    $tempPath = "$env:Temp\Test_{0}" -f (Get-Date -Format "yyyy-MM-dd_HH-mm-ss-ffff")
    New-Item -Path $tempPath -ItemType Directory | Out-Null

    $tempPath
}

Clear-PoshUnitContext

Export-ModuleMember Invoke-PoshUnit, Test-Fixture, Test

Export-ModuleMember -Variable Assert, Is, Has, Throws
Export-ModuleMember Test-Delegate, Get-TempTestPath