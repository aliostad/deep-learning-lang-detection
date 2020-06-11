function Import-Assembly {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        [string]$AssemblyName,

        [switch]$AsModule
    )

    # Discover full DLL path
    $dll = Get-ChildItem -Filter "$AssemblyName.dll" -Recurse | %{ $_.FullName }
    if ($dll -eq '') {
        Throw "Cannot find assembly named $AssemblyName"
    }

    if ($AsModule) {
        Import-Module $dll -Force
    }
    else
    {
        # Load the DLL as a byte stream so that the Powershell console doesn't lock/hold a reference
        $fileStream = $null
        try {
            Write-Verbose "Loading assembly '$dll'"

            $fileStream = ([System.IO.FileInfo] (Get-Item $dll)).OpenRead()

            $assemblyBytes = New-Object byte[] $fileStream.Length
            $fileStream.Read($assemblyBytes, 0, $fileStream.Length)

            [System.Reflection.Assembly]::Load($assemblyBytes)
        } finally {
            if ($fileStream -ne $null) {
                $fileStream.Close()
                $fileStream = $null
            }
        }
    }
}
