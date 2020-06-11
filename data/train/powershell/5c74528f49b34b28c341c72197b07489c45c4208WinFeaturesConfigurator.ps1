import-module ServerManager

function ApplyFeatures($featuresConfiguration) {
    GuardAgainstNull $featuresConfiguration "No features configuration passed to ApplyFeatures"
    foreach($featureConfig in $featuresConfiguration) {
        EnsureFeatureActive $featureConfig.Name
    }
}

function EnsureFeatureActive($winFeatureName) {
    GuardAgainstNull $winFeatureName "windows feature name must be specified"
    if(-Not (IsWinFeatureActive $winFeatureName)) {
        Add-WindowsFeature $winFeatureName 
    }
    else {
        Write-Host "windows feature: '$winFeatureName' already installed"
    }
}

function IsWinFeatureActive($winFeatureName) {
    GuardAgainstNull $winFeatureName "windows feature name must be specified"
    $feature = Get-WindowsFeature $winFeatureName
    GuardAgainstNull $feature "No feature with name {0} found to check weather it's active." -f $winFeatureName
    return $feature.Installed
}

function Write-Info ($message) {
    Write-Host "Info:" $message
}

function Write-Error ($message) {
    Write-Host "Error:" $message
}

function GuardAgainstNull($value, $message) {
    if($value -eq $null) {
        Write-Error $message
        exit 1
    }    
}