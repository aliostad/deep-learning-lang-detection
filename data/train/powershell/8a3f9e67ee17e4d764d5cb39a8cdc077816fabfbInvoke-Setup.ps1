# Variables
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$config = (Get-Content (Join-Path $scriptPath "config.json") | Out-String | ConvertFrom-Json)
foreach($var in $config.variables) {
    iex "`$$($var.name) = '$($ExecutionContext.InvokeCommand.ExpandString($var.value))'"
}

# Load Scripts
ls $scriptPath -Recurse -Filter "Import*.ps1" | % { . $_.FullName }

# Install Chocolatey
Install-Chocolatey -ProgressBegin 0 -ProgressEnd 20
Install-ChocolateyPackages -ProgressBegin 20 -ProgressEnd 50

# Install hard links
Install-Links -ProgressBegin 50 -ProgressEnd 100