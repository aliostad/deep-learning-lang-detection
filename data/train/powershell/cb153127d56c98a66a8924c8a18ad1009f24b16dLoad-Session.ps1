function Load-Session {
    param($NuGetAppModel)

    # Try to load the assembly containing the types
    $OpsAssembly = Join-Path (Convert-Path "$PSScriptRoot\..\..\..\..\src\NuGet.Services.Operations") "bin\Debug\NuGet.Services.Operations.dll"
    if(!(Test-Path $OpsAssembly)) {
        throw "Unable to load environments. NuGet.Services.Operations has not been built."
    }
    Add-Type -Path $OpsAssembly

    $session = [NuGet.Services.Operations.OperationsSession]::Load((Convert-Path $NuGetAppModel));
    $session
}