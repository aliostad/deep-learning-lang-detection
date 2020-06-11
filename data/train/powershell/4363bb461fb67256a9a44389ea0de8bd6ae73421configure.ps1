param
(
    $configurationName
)

# unload modules if loaded
Get-Module AppVeyor | Remove-Module
Get-Module AppRolla | Remove-Module

# import modules
Import-Module AppRolla
Import-Module AppVeyor

# globals
$isAppveyorEnvironment = $true
$scriptsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$settingsPath = "SOFTWARE\AppVeyor\Deployment"
$azureApps = @{}

function GetAzureApp($name)
{
    $app = $azureApps[$name]
    if($app -eq $null)
    {
        $app = @{}
        $azureApps[$name] = $app
    }
    return $app
}

# is it AppVeyor CI environment?
if(-not $projectName)
{
    Write-Host "Running deployment script interactively"

    # no, the script is being run interactively from command line
    $isAppveyorEnvironment = $false
    
    # load script parameters from the Registry
    $configkey = ([Microsoft.Win32.Registry]::CurrentUser).OpenSubKey($settingsPath)
    if(-not $configkey)
    {
        throw "Cannot read script parameters from Registry key: $settingsPath"
    }

    $variables = @{}
    foreach($name in $configkey.GetValueNames())
    {
        $variables[$name] = $configkey.GetValue($name)
    }

    # load named sub-configuration if specified and found
    if($configurationName)
    {
        $subConfigkey = ([Microsoft.Win32.Registry]::CurrentUser).OpenSubKey("$settingsPath\$configurationName")
        if($subConfigkey)
        {
            # override variables
            foreach($name in $subConfigkey.GetValueNames())
            {
                $variables[$name] = $subConfigkey.GetValue($name)
            }
        }
    }
}

# get script settings
$specificProject = $false
if($variables.Project)
{
    $specificProject = $true
    $projectName = $variables.Project
    $projectVersion = $variables.Version
}
$apiAccessKey = $variables.ApiAccessKey
$apiSecretKey = $variables.ApiSecretKey
$serverUsername = $variables.ServerUsername
$serverPassword = $variables.ServerPassword

if(-not $apiAccessKey -or -not $apiSecretKey)
{
    throw "Specify ApiAccessKey and ApiSecretKey variables"
}

# set API keys
Set-AppveyorConnection $apiAccessKey $apiSecretKey

# this is needed to download artifacts on remote servers
Set-DeploymentConfiguration AppveyorApiKey $apiAccessKey
Set-DeploymentConfiguration AppveyorApiSecret $apiSecretKey

# details of Azure subscription (required by Azure deployment cmdlets)
Set-DeploymentConfiguration AzureSubscriptionID $variables.AzureSubscriptionID
Set-DeploymentConfiguration AzureSubscriptionCertificate $variables.AzureSubscriptionCertificate

# details of Azure cloud storage (required by Azure deployment cmdlets to download CS configuration file)
Set-DeploymentConfiguration AzureStorageAccountName $variables.AzureStorageAccountName
Set-DeploymentConfiguration AzureStorageAccountKey $variables.AzureStorageAccountKey

# add new application
New-Application $projectName

# add applications and roles from artifacts
$projectArtifacts = $null
if($specificProject)
{
    if($projectVersion)
    {
        Write-Host "Fetching version $projectVersion details for project $projectName using AppVeyor API"

        # load specific project version
        $version = Get-AppveyorProjectVersion $projectName $projectVersion

        # get project artifacts
        $projectArtifacts = $version.artifacts
    }
    else
    {
        Write-Host "Fetching last version of project $projectName using AppVeyor API"

        # load last project version
        $project = Get-AppveyorProject -Name $projectName
        $projectVersion = $project.lastVersion.version

        # get project artifacts
        $projectArtifacts = $project.lastVersion.artifacts
    }
}
else
{
    Write-Host "Deploying from build artifacts"
    $projectArtifacts = $artifacts.values
}

Write-Host "Configuring applications for project `"$projectName`" version $projectVersion"

# build AppRolla application from artifacts
Write-Host "Total project artifacts: $($projectArtifacts.Count)"

foreach($artifact in $projectArtifacts)
{
    if($artifact.type -eq "WindowsApplication")
    {
        # Windows service or console application
        Add-ServiceRole $projectName $artifact.name -PackageUrl $artifact.url -DeploymentGroup app
    }
    elseif($artifact.type -eq "WebApplication")
    {
        # Web application
        Add-WebsiteRole $projectName $artifact.name -PackageUrl $artifact.url -DeploymentGroup web
    }
    elseif($artifact.type -eq "AzureCloudService")
    {
        # Azure Cloud Service package
        $app = GetAzureApp $artifact.name
        $app.Name = $artifact.name
        $app.PackageUrl = $artifact.customUrl
    }
    elseif($artifact.type -eq "AzureCloudServiceConfig")
    {
        # Azure Cloud Service configuration
        $appName = $artifact.name.substring(0, $artifact.name.lastIndexOf("-"))
        $app = GetAzureApp $appName
        $app.ConfigUrl = $artifact.customUrl
    }
    else
    {
        Write-Host "$($artifact.type) artifact $($artifact.name) skipped"
    }
}

# add Azure applications if found
foreach($azureApp in $azureApps.Values)
{
    New-AzureApplication -Name $azureApp.Name -PackageUrl $azureApp.PackageUrl -ConfigUrl $azureApp.ConfigUrl
}

# load project specific settings and customizations
Write-Host "Loading project custom settings"
. (Join-Path $scriptsPath "project.ps1")

# set environment credentials
if($serverUsername -and $serverPassword)
{
    Write-Host "Setting environment credentials"
    $securePassword = ConvertTo-SecureString $serverPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $serverUsername, $securePassword

    foreach($environment in (Get-Environment))
    {
        if($environment.Name -ne "local")
        {
            Set-Environment $environment.Name -Credential $credential
        }
    }
}

# output what apps and environments are available
# apps
Write-Host
Write-Host "Configured applications:"
foreach($app in Get-Application)
{
    Write-Host "    $($app.Name)"
}

# environments
Write-Host
Write-Host "Configured environments:"
foreach($environment in Get-Environment)
{
    Write-Host "    $($environment.Name)"
}