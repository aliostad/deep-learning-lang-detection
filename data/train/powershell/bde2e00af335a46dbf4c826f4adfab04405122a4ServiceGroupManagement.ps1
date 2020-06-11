<#
The MIT License (MIT)

Copyright (c) 2015 Tintri, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

<#

A Service Group is a logical collection of VMs in a Tintri Global Center (TGC). 
Administrators can use service groups to manage a group of VMs 
(apply protection policies and other settings) as they would manage a single VM.

The following code snippet shows how to manage TGC service groups
using the Tintri Automation Toolkit 2.0.0.1.

Specifically:
- View service groups
- Create, update and delete service groups
- Manage service group membership rules
- Apply snapshot schedules to service groups
- Setup replication for service groups

#>

Param(
    [string] $tintriServer,
    [string] $serviceGroupName,
    [string] $vmNameToAdd    
)

# Connect to the TGC, will prompt for credentials
Write-Host "Connecting to the Tintri Global Center $tintriServer"
$ts = Connect-TintriServer -Server $tintriServer

if ($ts -eq $null)
{
    Write-Host "Could not connect to $tintriServer"
    return
}

# List all the service groups on the TGC
Write-Host "Fetching all the service groups on $tintriServer"
Get-TintriServiceGroup

# Create a new service group
Write-Host "Creating a new service group: $serviceGroupName"
$serviceGroup = New-TintriServiceGroup -Name $serviceGroupName -Description "Created from the example script"

Write-Host "Updating the service group's description"
$serviceGroup | Set-TintriServiceGroup -Description "VMs whose name contains tintri"

# Specifying a membership rule for the service group
Write-Host "Adding a new membership rule to the service group: VM name contains 'tintri'"
$rule = $serviceGroup | New-TintriServiceGroupRule -VMNameMatches *tintri*

Write-Host "Removing the membership rule just created"
$rule | Remove-TintriServiceGroupRule

# Adding a VM statically to the service group
$vm = Get-TintriVM -Name $vmNameToAdd

Write-Host "Adding the VM $vmNameToAdd to the service group"
$vm | Add-TintriServiceGroupMember -ServiceGroup $serviceGroup

Write-Host "Removing the statically added VM $vmNameToAdd from the service group"
$vm | Remove-TintriServiceGroupMember -ServiceGroup $serviceGroup


# Assigning a snapshot schedules
Write-Host "Assign a 'Weekly' snapshot schedule to the service group (will be applied to the VMs)"
$schedule = New-TintriVMSnapshotSchedule -SnapshotScheduleType Weekly
Set-TintriVMSnapshotSchedule -ServiceGroup $serviceGroup -SnapshotSchedule $schedule

# Setup replication for the service group. Using an arbitrary repl path for example 
Write-Host "Setup replication for VMs in the service group"
$replPaths = Get-TintriDatastoreReplPath
New-TintriVMReplConfiguration -ServiceGroup $serviceGroup -DatastoreReplPath $replPaths[0]

Write-Host "Clearing the replication configurations of the service group"
Remove-TintriVMReplConfiguration -ServiceGroup $serviceGroup

Write-Host "Clearing the 'Weekly' snapshot schedule for the service group"
Clear-TintriVMSnapshotSchedule -VM $vm -SnapshotScheduleType Weekly

# Delete the service group (using the -Force switch to suppress a confirm dialog)
Write-Host "Deleting the service group $serviceGroupName from the TGC."
$serviceGroup | Remove-TintriServiceGroup -Force

# Disconnecting from all the Tintri servers
Disconnect-TintriServer -All