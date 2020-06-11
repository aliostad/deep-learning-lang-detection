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
# Runs as planed Task to delete old snapshots on schedule
#####

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
$pb_api.Timeout = 500000 # http request timeout in milliseconds
# $pb_api is the Webserice class with all methodes and properties defined in the WSDL

# Days for Snapshots to keep
$DaysToArchive = 5
# Snapshot names to work with beginn with string
$SnapshotNames = "Backup.*"

# timestamp for deletion
$Now = Get-Date
$SnapshotDeleteTime = $now.AddDays($DaysToArchive*-1)

# get All Snapshots
$AllSnapshots = $pb_api.getAllSnapshots()

# get Snapshots to delete
$SnapshotsToDelete = $AllSnapshots | Where-Object {$_.snapshotName -like $SnapshotNames -and $_.creationTimestamp -lt $SnapshotDeleteTime }

# loop throught all snapshots to delete
foreach ($snapshot in $SnapshotsToDelete) {
    $deleteResponse = $pb_api.deleteSnapshot($snapshot.snapshotId)
    Write-Host "Request" $deleteResponse.requestId "Deleted Snapshot" $snapshot.snapshotName "with ID" $snapshot.snapshotId
}
