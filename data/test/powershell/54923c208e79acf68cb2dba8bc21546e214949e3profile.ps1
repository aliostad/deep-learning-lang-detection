#requires -modules posh-git, OpenWeatherMap, BetterCredentials

Import-Module BetterCredentials
Import-Module posh-git
Import-Module OpenWeatherMap

$WeatherApiKey = $null
$ContribDir = "C:\Development\Contrib"
$JunkDir = "C:\Development\Junk"

Function Write-LocalWeatherCurrent([switch]$Inline) {
    # Replace city and API key
    Write-WeatherCurrent -City Minneapolis -ApiKey $WeatherApiKey -Inline:$Inline
}

Function Write-LocalWeatherForecast($Days = 1) {
    # Replace city and API key
    Write-WeatherForecast -City Minneapolis -ApiKey $WeatherApiKey -Days $Days
}

Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-LocalWeatherCurrent

# Type `weather` in the prompt to see current weather
Set-Alias weather Write-LocalWeatherCurrent
# Type `forecast` or `forecast -d 2` to get the current forecast
Set-Alias forecast Write-LocalWeatherForecast

# Customize prompt
function Prompt() {
    # Print working dir
    Write-Host ($PWD) -NoNewline -foregroundcolor Red
    # Write inline weather
    Write-LocalWeatherCurrent -Inline
    Write-VcsStatus #Disable VCS for perf right now
    Write-Host ""
    Write-Host "›" -NoNewline -ForegroundColor Gray    

    return " "
}

#
# Aliases
#

function Contrib() {
    cd $ContribDir
}

function Junk() {
    cd $JunkDir
}

function gcr() {
  return Get-Credential -Inline @args
}

Set-Alias which Get-Command
Set-Alias of Out-File

# Custom helpers
function grep($match, $file) {
    if (!$file) {
        gci -r -File | % {
            $matches = $_ | gc | ? { $_ -match $match }
            if ($matches) {
                [pscustomobject]@{ File = $_.FullName; Matches = $matches }
            }
        }
    } else {
        gc $file | ? { $_ -match $match }
    }
}