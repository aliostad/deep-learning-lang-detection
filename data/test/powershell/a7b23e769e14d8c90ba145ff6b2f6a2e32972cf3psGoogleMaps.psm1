#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }


# Get Configuration
$script:company = "45413"
$script:moduleName = (Get-ChildItem $PSCommandPath).BaseName
$script:moduleSettings = "$env:LOCALAPPDATA\$($script:company)\$($script:moduleName)\settings.json"
$script:settings = Get-psGoogleMapsSettings

if ($script:settings) { 
    # Settings were retrieved
    Write-Verbose "Using apiKey: $script:settings.apiKey"
} else {
    # First run, prompt user for apiKey
    # Settings were retrieved
    Write-Verbose "No Settings file found. Prompting user for required settings."
    #Prompt for API Key and save to config file
    $script:settings = @{}
    $script:settings.apiKey = Read-Host -Prompt "Google Maps API Key"

    Set-psGoogleMapsSettings $script:settings
}

# Export all public functions/cmdlets
Export-ModuleMember -Function $Public.Basename