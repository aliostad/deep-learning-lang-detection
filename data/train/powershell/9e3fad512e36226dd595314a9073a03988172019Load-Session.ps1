function Load-Session {
    param($NuGetAppModel)

    # Try to load the assembly containing the types
    $OpsAssembly = Join-Path (Convert-Path "$PSScriptRoot\..\..\..\..\src\NuGet.Services.Operations") "bin\Debug\NuGet.Services.Operations.dll"
    if(!(Test-Path $OpsAssembly)) {
        throw "Unable to load environments. NuGet.Services.Operations has not been built."
    }

    # Shadow-copy the assembly
    $tmp = Join-Path ([IO.Path]::GetTempPath()) "NuOps"
    if(!(Test-Path $tmp)) {
        mkdir $tmp | Out-Null
    }
    $asm = Join-Path $tmp "NuGet.Services.Operations.dll"
    if(Test-Path $asm) {
        rm -for $asm
    }
    cp $OpsAssembly $asm

    Add-Type -Path $asm

    $session = [NuGet.Services.Operations.OperationsSession]::Load((Convert-Path $NuGetAppModel));
    $session
}