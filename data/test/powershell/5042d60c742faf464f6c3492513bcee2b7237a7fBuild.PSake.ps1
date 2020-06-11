#requires -Version 5;

$psake.use_exit_on_error = $true;

Properties {
    $moduleName = (Get-Item $PSScriptRoot\*.psd1)[0].BaseName;
    $basePath = $psake.build_script_dir;
    $buildDir = 'Release';
    $buildPath = (Join-Path -Path $basePath -ChildPath $buildDir);
    $releasePath = (Join-Path -Path $buildPath -ChildPath $moduleName);
    $exclude = @('.git*', '.vscode', 'Release', 'DscResource.Tests', 'Tests', 'Build.PSake.ps1', '*.png');
}

Task Default -Depends Build;

Task Build -Depends Init, Clean, Deploy;

Task Init {

} #end task Init

## Remove release directory
Task Clean -Depends Init {
    Write-Host (' Cleaning release directory "{0}".' -f $buildPath) -ForegroundColor Yellow;
    if (Test-Path -Path $buildPath) {
        Remove-Item -Path $buildPath -Include * -Recurse -Force;
    }
    [ref] $null = New-Item -Path $buildPath -ItemType Directory -Force;
    [ref] $null = New-Item -Path $releasePath -ItemType Directory -Force;
} #end task Clean

Task Test {
    $invokePesterParams = @{
        Path = "$basePath\Tests";
        OutputFile = "$releasePath\TestResult.xml";
        OutputFormat = 'NUnitXml';
        Strict = $true;
        PassThru = $true;
        Verbose = $false;
    }
    $testResult = Invoke-Pester @invokePesterParams;
    if ($testResult.FailedCount -gt 0) {
        Write-Error ('Failed "{0}" unit tests.' -f $testResult.FailedCount);
    }
} #end task Test

Task Deploy -Depends Clean {
    Get-ChildItem -Path $basePath -Exclude $exclude | ForEach-Object {
        Write-Host (' Copying "{0}"' -f $PSItem.FullName) -ForegroundColor Yellow;
        Copy-Item -Path $PSItem -Destination $releasePath -Recurse;
    }
} #end task Deploy

Task Publish -Depends Build {
    $powershellApiKeyPath = Join-Path -Path $env:UserProfile -ChildPath 'PSGallery.apitoken';
    Write-Host (' Loading PowerShell Gallery API Key "{0}"' -f $powershellApiKeyPath) -ForegroundColor Yellow;
    $psGalleryApiKey = Get-Content -Path $powershellApiKeyPath | ConvertTo-SecureString;
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($psGalleryApiKey);
    $nuGetApiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
    Write-Host (' Publishing module "{0}"' -f $releasePath) -ForegroundColor Yellow;
    Publish-Module -Path $releasePath -NuGetApiKey $nuGetApiKey;
} #end task Publish
