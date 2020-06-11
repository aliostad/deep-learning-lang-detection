param (
    [switch]$debug = $false,
    [switch]$release = $false,
    [string]$outputPath = ""
)

$ErrorActionPreference = "Stop"

$outputPath = "..\..\..\install\bin"

Write-Host "Publishing NCC build."
Write-Host "Output directory: $outputPath"
Write-Host ""

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$NMMPath = "$scriptDirectory\..\NMM"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\ChinhDo.Transactions.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\Commanding.dll" "$outputPath\NCC"
# Copy-Item "$NMMPATH\bin\Release\GamebryoBase.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\ICSharpCode.TextEditor.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\ModManager.Interface.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\Mods.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\NexusClient.Interface.dll" "$outputPath\NCC"
# Copy-Item "$NMMPATH\bin\Release\NexusClientCLI.exe.manifest" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\Scripting.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\SevenZipSharp.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\Transactions.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\UI.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\Util.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\WeifenLuo.WinFormsUI.Docking.dll" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\NexusClientCLI.exe" "$outputPath\NCC"
Copy-Item "$NMMPATH\bin\Release\NexusClientCLI.exe.config" "$outputPath\NCC"
# stored in repository in binary form
Copy-Item "$NMMPATH\bin\Release\Castle.Core.dll" "$outputPath\NCC"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC\GameModes"
Copy-Item "$NMMPATH\bin\Release\GameModes\Fallout3.*" "$outputPath\NCC\GameModes"
Copy-Item "$NMMPATH\bin\Release\GameModes\FalloutNV.*" "$outputPath\NCC\GameModes"
Copy-Item "$NMMPATH\bin\Release\GameModes\Skyrim.*" "$outputPath\NCC\GameModes"
Copy-Item "$NMMPATH\bin\Release\GameModes\Oblivion.*" "$outputPath\NCC\GameModes"
Copy-Item "$NMMPATH\bin\Release\GameModes\GamebryoBase.dll" "$outputPath\NCC\GameModes"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC\GameModes\data"
# Copy-Item "$NMMPATH\..\bin\Release\BossDummy.dll" "$outputPath\NCC\GameModes\data\boss32.dll"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC\ModFormats"
Copy-Item "$NMMPATH\bin\Release\ModFormats\FOMod.dll" "$outputPath\NCC\ModFormats"
Copy-Item "$NMMPATH\bin\Release\ModFormats\OMod.dll" "$outputPath\NCC\ModFormats"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC\ScriptTypes"
Copy-Item "$NMMPATH\bin\Release\ScriptTypes\Antlr*.dll" "$outputPath\NCC\ScriptTypes"
Copy-Item "$NMMPATH\bin\Release\ScriptTypes\CSharpScript.dll" "$outputPath\NCC\ScriptTypes"
Copy-Item "$NMMPATH\bin\Release\ScriptTypes\ModScript.dll" "$outputPath\NCC\ScriptTypes"
Copy-Item "$NMMPATH\bin\Release\ScriptTypes\XmlScript.dll" "$outputPath\NCC\ScriptTypes"

New-Item -ItemType directory -Force -Path  "$outputPath\NCC\data"
Copy-Item "$NMMPATH\bin\Release\data\7z-32bit.dll" "$outputPath\NCC\data"
Copy-Item "$NMMPATH\bin\Release\data\7z-64bit.dll" "$outputPath\NCC\data"