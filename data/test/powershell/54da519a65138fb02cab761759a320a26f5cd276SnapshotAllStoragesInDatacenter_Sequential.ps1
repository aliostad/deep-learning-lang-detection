########################################################################
# Copyright 2014 Thomas Vogel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#########################################################################
# Code Repository: https://github.com/th-m-vogel/ProfitBricks-Webservice-PS-Samples
#########################################################################

#####
# Runs as planed Task to create snapshots from all Stoarges a Datacenter on schedule
# Snepshots are create One by One. 1st snaphost has to be created 
# before the next snapshot request is started.
#####

# Datacenter to use
$DatacenterId = "c894dfac-3524-49fd-8691-56f112c2c5de"


$ErrorActionPreference="Stop"

# Credentials
$_password = Get-Content "$env:HOMEPATH\PB_API.pwd" | ConvertTo-SecureString
$_user = "thomas.vogel@profitbricks.com"
$pb_creds = New-Object System.Management.Automation.PsCredential($_user,$_password)

# API WSDL and Endpoint
$pb_wsdl = "https://api.profitbricks.com/1.3/wsdl"
$PBEndpoint = "https://api.profitbricks.com/1.3/"

# connect Webservice
$pb_api = New-WebServiceProxy -Uri $pb_wsdl -namespace ProfitBricksApiService -class ProfitBricksApiServiceClass -Credential $pb_creds

# configure Webservice
$pb_api.Url = $PBEndpoint
$pb_api.PreAuthenticate = $true
$pb_api.Credentials = $pb_creds
$pb_api.Timeout = 120000 # http request timeout in milliseconds
# $pb_api is the Webserice class with all methodes and properties defined in the WSDL

# get Datacenter structure
$Datacenter = $pb_api.getDataCenter($DatacenterId)

# loop throught all storages
foreach ($storage in $Datacenter.storages) {
    # define snapshot parameters
    $snapshotRequest = New-Object ProfitBricksApiService.createSnapshotRequest
    $snapshotRequest.storageId = $storage.storageId
    $snapshotRequest.snapshotName = "Backup." + $storage.storageName +"." + $storage.storageId
    $snapshotRequest.description = "Auto created backup snapshot from " + $storage.storageName + " at " + (Get-Date).ToString()
    # execute snapshot
    Write-Host "Requesting Snapshot from Storage" $storage.storageName "using ID" $storage.storageId "at" $([System.DateTime]::Now)
    $snapshotResponse = New-Object ProfitBricksApiService.createSnapshotResponse 
    try {
        $snapshotResponse = $pb_api.createSnapshot($snapshotRequest) 
    }
    catch {
        Write-Host "### ERROR ### Requesting Snapshot from Storage" $storage.storageName "using ID" $storage.storageId "failed at" $([System.DateTime]::Now)
        Write-Host "              Message: $($_.Exception.Message)"
        Write-Host "              Item failed: $($_.Exception.ItemName)"
    }
    Write-Host "Requested Snapshot from Storage" $storage.storageName "using ID" $storage.storageId "in Snapshot" $snapshotResponse.snapshotId "at" $([System.DateTime]::Now)
    Write-Host -NoNewline "Wait for Snapshots to be available, check every 60 seconds "
    $_snapTime = 0
    do {
        Sleep 60
        $_snapTime += 60
        $_SnapStatus = $pb_api.getSnapshot($snapshotResponse.snapshotId)
        Write-Host -NoNewline "."
    } while ($_SnapStatus.provisioningState -ne "AVAILABLE")
    Write-Host " done! in $_snapTime Seconds"
}
