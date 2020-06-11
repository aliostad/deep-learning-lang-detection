Write-Output $OctopusParameters

. (Join-Path $PSScriptRoot "Deploy-Environment.ps1") `
    -SubscriptionId $OctopusParameters["SubscriptionId"]`
    -TenantId $OctopusParameters["TenantId"]`
    -ClientId $OctopusParameters["ClientId"]`
    -Password $OctopusParameters["Password"]`
    -Location $OctopusParameters["Location"]`
    -AppName $OctopusParameters["AppName"]`
    -AppEnvironment $OctopusParameters["Octopus.Environment.Name"]`
    -adminUsername $OctopusParameters["adminUsername"]`
    -adminPassword $OctopusParameters["adminPassword"]`
    -sqlServerAdminPassword $OctopusParameters["sqlServerAdminPassword"]`
    -SqlPerformanceLevel $OctopusParameters["SqlPerformanceLevel"]`
    -vmStorageAccountType $OctopusParameters["vmStorageAccountType"]`
    -vmSize $OctopusParameters["vmSize"]`
    -octopusApiKey $OctopusParameters["octopusApiKey"]`
    -octopusServerUrl $OctopusParameters["octopusServerUrl"]
