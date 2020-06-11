# To run this file, you might need change the default execution policy
# An example how to run:
# powershell  -ExecutionPolicy ByPass -File install-glloadgen-windows.ps1

# Note: Lua 5.1 is need for running

$path="$PSScriptRoot"
$url="https://bitbucket.org/alfonse/glloadgen/downloads/glLoadGen_2_0_2.7z"
$file="$path/glLoadGen_2_0_2.7z"
$folder="$path/glLoadGen_2_0_2"
$target="$path/gl"

if (!(Test-Path "$folder")) {
    echo "Downloading glloadgen"
    Invoke-WebRequest "$url" -OutFile "$file" -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
    7z x "$file" -o"$path"
}

rm  -Recurse -Force "$target" -ea SilentlyContinue
cd "$folder"
mkdir -Force "$target"
lua5.1 LoadGen.lua "-spec=gl" "-version=3.2" $target/stb

echo "Gl installation done to $target"
