param($installPath, $toolsPath, $package, $project)

# NOTE: Shadow copying interferes with DynamicTypeService
[System.AppDomain]::CurrentDomain.ClearShadowCopyPath()

# Load commands
Import-Module (Join-Path $toolsPath EntityFramework.Migrations.Commands.dll)

# Load dependent assemblies
[System.Reflection.Assembly]::LoadFrom((Join-Path $toolsPath EntityFramework.Migrations.dll)) | Out-Null
[System.Reflection.Assembly]::LoadFrom((Join-Path $toolsPath Microsoft.Data.Tools.Schema.Migrations.dll)) | Out-Null
[System.Reflection.Assembly]::LoadFrom((Join-Path $toolsPath Microsoft.Data.Tools.Schema.Sql.dll)) | Out-Null

# Set user-friendly aliases
Set-Alias Migrate Update-Database -Option AllScope -scope Global