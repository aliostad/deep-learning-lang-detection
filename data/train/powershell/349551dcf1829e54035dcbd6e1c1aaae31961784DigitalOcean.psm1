<#
.SYNOPSIS
A collection of functions to call DigitalOcean's API.

.EXAMPLE


.NOTES
AUTHOR: Aaron P. Miller
REQUIRES: Powershell 3.0

.LINK
Invoke-RESTMethod
#>


Function Set-DODefaultAuthVariables {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey
    )
    
    $Global:PSDefaultParameterValues = @{}

    @('clientID','apiKey') | % {
        $names = Get-Command -Module DigitalOcean -ParameterName $_ | % {$_.Name}
        foreach ($name in $names) {
            $Global:PSDefaultParameterValues[$($name + ':' + $_)] = $(Get-Variable $_).value
        }
    }
}

Function Invoke-DOAPI {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][ValidateSet('droplets','regions','images','ssh_keys','sizes','domains','events')][string]$section,
        [int]$itemID,
        [string]$method,
        [array]$params
    )
    [array]$uri = @()
    $uri += 'https://api.digitalocean.com'
    $uri += $section
    if ($itemID) {$uri += $itemID}
    if ($method) {$uri += $method}
    $uri += "?client_id=$clientID&api_key=$apiKey"
    [string]$uriPath = $uri -join '/'
    if ($params) {
        $uriPath += "`&$($params -join '&')"
    }
    Invoke-RESTMethod -Uri $uriPath | % {$_.$(Get-Member -InputObject $_ -MemberType NoteProperty | ? {$_.Name -ne 'status'} | % {$_.Name})}
}

# Droplets
# Todo / Improve: New - check if privatenetwork is available..nyc2? Before resize we may need to check to make sure it's off
Function Get-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID
}

Function New-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][string]$name,
        [Parameter(Mandatory=$True)][int]$sizeID,
        [Parameter(Mandatory=$True)][int]$imageID,
        [Parameter(Mandatory=$True)][int]$regionID,
        [int[]]$sshKeyIDs,
        [switch]$privateNetwork
    )

    [array]$params = @()
    $params += "name=$name"
    $params += "size_id=$sizeID"
    $params += "image_id=$imageID"
    $params += "region_id=$regionID"
    if ($sshKeyIDs) {
        $params += "ssh_key_ids=$($sshKeyIDs -join ',')"
    }
    if ($privateNetwork) {
        $params += 'private_networking=1'
    }

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -method 'new' -params $params

}

Function Remove-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [switch]$scrubData
    )
    if ($scrubData) {
        [array]$params = @()
         $params += 'scrub_data=1'
    }
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'destroy' -params $params
}

Function Reboot-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'reboot'
}

Function PowerCycle-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'power_cycle'
}

Function Shutdown-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'shutdown'
}

Function PowerOff-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'power_off'
}

Function PowerOn-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'power_on'
}

Function PasswordReset-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'password_reset'
}

Function Resize-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [Parameter(Mandatory=$True)][int]$sizeID
    )
    [array]$params = @()
    $params += "size_id=$sizeID"
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'resize' -params $params
}

Function Snapshot-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [string]$name
    )
    [array]$params = @()
    if ($name) {
        $params += "name=$name"
    }
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'snapshot' -params $params
}

Function Restore-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [Parameter(Mandatory=$True)][int]$imageID
    )
    [array]$params = @()
    $params += "image_id=$imageID"

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'restore' -params $params
}

Function Rebuild-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [Parameter(Mandatory=$True)][int]$imageID
    )
    [array]$params = @()
    $params += "image_id=$imageID"

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'rebuild' -params $params
}

Function EnableBackups-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'enable_backups'
}

Function DisableBackups-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID
    )

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'disable_backups'
}

Function Rename-DODroplet {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$dropletID,
        [Parameter(Mandatory=$True)][string]$name
    )
    [array]$params = @()
    $params += "name=$name"

    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'droplets' -itemID $dropletID -method 'rename' -params $params
}



# Regions
Function Get-DORegions {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'regions'
}

# Images 
# Todo:  Destroy, Transfer
Function Get-DOImage {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [int]$imageID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'images' -itemID $imageID
}

# SSH Keys
# Todo:  New, Edit, Destroy
Function Get-DOSSHKey {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [int]$keyID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'ssh_keys' -itemID $keyID
}

# Sizes
Function Get-DOSizes {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'sizes'
}

# Domains
# Todo: New, Destroy
Function Get-DODomain {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [int]$domainID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'domains' -itemID $domainID
}

# Domain Records
# Todo:  New, Edit, Destroy
Function Get-DODomainRecord {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$domainID,
        [int]$recordID
    )
    if ($recordID) {
        $method = "records/$recordID"
    } else {
         $method = 'records'
    }
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'domains' -itemID $domainID -method $method
}

# Events
Function Get-DOEvent {
    PARAM (
        [Parameter(Mandatory=$True)][string]$clientID,
        [Parameter(Mandatory=$True)][string]$apiKey,
        [Parameter(Mandatory=$True)][int]$eventID
    )
    Invoke-DOAPI -clientID $clientID -apiKey $apiKey -section 'events' -itemID $eventID
}
