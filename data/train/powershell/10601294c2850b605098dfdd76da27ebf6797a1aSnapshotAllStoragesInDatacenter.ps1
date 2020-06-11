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
#####

# Credentials
$_password = Get-Content "$env:HOMEPATH\PB_API.pwd" | ConvertTo-SecureString
$_user = "thomas.vogel@profitbricks.com"
$pb_creds = New-Object System.Management.Automation.PsCredential($_user,$_password)

# API WSDL and Endpoint
$pb_wsdl = "https://api.profitbricks.com/1.2/wsdl"
$PBEndpoint = "https://api.profitbricks.com/1.2/"

# connect Webservice
$pb_api = New-WebServiceProxy -Uri $pb_wsdl -namespace ProfitBricksApiService -class ProfitBricksApiServiceClass -Credential $pb_creds

# configure Webservice
$pb_api.Url = $PBEndpoint
$pb_api.PreAuthenticate = $true
$pb_api.Credentials = $pb_creds
$pb_api.Timeout = 500000 # http request timeout in milliseconds
# $pb_api is the Webserice class with all methodes and properties defined in the WSDL

# Datacenter to use
$DatacenterId = "400784cf-33bb-4f17-90de-928de1ff03a1"

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
    $snapshotResponse = $pb_api.createSnapshot($snapshotRequest)
    Write-Host "Created Snapshot from Storage" $storage.storageName "using ID" $storage.storageId "in Snapshot" $snapshotResponse.snapshotId
}
