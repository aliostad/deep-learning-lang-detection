param($rootPath, $toolsPath, $package, $project)

# Unidiomatic compared to Add-Type, but this allows the dll to be deleted when the package is uninstalled
$providerAssemblyPath = Join-Path $rootPath "resources\AjaxGridScaffolderProvider.dll"
$bytes = [System.IO.File]::ReadAllBytes($providerAssemblyPath)
[System.Reflection.Assembly]::Load($bytes)
[AjaxGridScaffolderProvider.AjaxGridScaffolderProvider]::DefaultTemplateFolder = Join-Path $rootPath "resources\Templates"
[AjaxGridScaffolderProvider.AjaxGridScaffolderProvider]::Initialize()
