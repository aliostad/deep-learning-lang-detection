########################################################################
# Copyright 2013 Thomas Vogel
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
########################################################################
# Code Repository: https://github.com/th-m-vogel/ProfitBricks-Webservice-PS-Samples
########################################################################
# PowerShell Module: https://github.com/th-m-vogel/ProfitBricks-PS-cmdlet
########################################################################

## Set the URI to the PB-API WSLD
$pb_wsdl = "https://api.profitbricks.com/1.3/wsdl"

## connect the WDSL
$pb_api = New-WebServiceProxy -Uri $pb_wsdl -namespace ProfitbricksApiService -class ProfitbricksApiServiceClass

## use this line for interactive request of user credentials
$creds = Get-Credential -Message "ProfitBricks Account"

## use the following thre code lines for
# file stored credentials. (password as encrypted String)
# to create stored credentials you may use
#   https://github.com/th-m-vogel/ProfitBricks-Webservice-PS-Samples/blob/master/Save-Password-as-encrypted-string.ps1
##
# $_password = Get-Content "$env:HOMEPATH\PB_API.pwd" | ConvertTo-SecureString 
# $_user = "username@domain.top"
# $pb_creds = New-Object System.Management.Automation.PsCredential($_user,$_password)
# end import password from file 

## add the credentials for api access (common)
$pb_api.Credentials = $creds

################
## create a function to wait for datacenter state
################
function CheckProvisioningState { 
    param (
        [Parameter( Mandatory=$true, Position=0 )]
        [String]
        $_DataCenterID
        ,
        [Parameter( Mandatory=$true, Position=1 )]
        [Int]
        $_Delay
        ,
        [Parameter( Mandatory=$true, Position=2 )]
        [String]
        $_Status
    )

    $_waittime = 0
    do {
        start-sleep -s $_Delay
        $_waittime += $_Delay
        Write-Host -NoNewline "." 
        $_DC = $pb_api.getDataCenter($_DataCenterID)
    } while ($_DC.provisioningStateSpecified -and ($_DC.provisioningState -ne $_Status))
    Write-Host -NoNewline " $_waittime Seconds for datacenterstate $_Status "

}

################
## Loop all Datacenters
################
foreach ($DC in $pb_api.getAllDataCenters()) {
Write-Host "Found Datacenter" $DC.dataCenterName
    ################
    # loop for all servers in DC
    ################
    # continue only if the datacenter in AVAILABLE
    Write-Host -NoNewline "Check Datacenter status "
    CheckProvisioningState $DC.dataCenterId 5 AVAILABLE
    Write-Host "... start to Power Off Servers"

    foreach ($server in ($pb_api.getDataCenter($DC.dataCenterId)).servers) {
        Write-Host "    Found Server" $server.serverName "in state" $server.virtualMachineState "and Privisioningstate is" $server.provisioningState
        if ($server.virtualMachineState -eq "SHUTOFF" -and $server.provisioningState -eq "AVAILABLE") {
            Write-Host -NoNewline "        request Power OFF "
            Write-Eventlog  -Logname 'Application' -Source 'Application' -EventID 1000 -EntryType Information -Message ("Shutt off Server " + $server.serverName + " in Datacenter " + $DC.dataCenterName)
            $response = $pb_api.stopServer($server.serverId)
            # wait for request to finish
            CheckProvisioningState $DC.dataCenterId 5 AVAILABLE
            Write-Host " done!"
        } 
    }
}