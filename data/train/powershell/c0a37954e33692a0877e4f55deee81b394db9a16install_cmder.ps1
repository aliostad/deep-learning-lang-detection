Import-Module $PSScriptRoot\.ps_modules\install.psm1

$githubRepo = "cmderdev/cmder"
$apiUrl = "https://api.github.com/repos/${githubRepo}/releases/latest"

# download zip
$response = Invoke-RestMethod -Method Get -Uri $apiUrl
$tag = $response.tag_name

$zipUrl = "https://github.com/${githubRepo}/releases/download/${tag}/cmder_mini.zip"

$installDir = Join-Path ${env:ProgramFiles(x86)} "cmder_mini"

Install-ZipURL -Url $zipUrl -InstallDir $installDir -Force

# create shortcut in start menu
$linkPath = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\Cmder.lnk"

$shell = New-Object -ComObject WScript.Shell


$shortcut = $shell.CreateShortcut($linkPath)
$shortcut.TargetPath = Join-Path $installDir "Cmder.exe"
$shortcut.Save()