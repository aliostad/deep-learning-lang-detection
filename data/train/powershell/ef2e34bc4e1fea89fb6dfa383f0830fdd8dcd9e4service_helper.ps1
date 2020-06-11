#==========================================================================#
# Manage SCVMM Cloud Services (Shutdown / Delete)                          #
#==========================================================================#
#                                                                          #
# Changelog:                                                               #
# 2015-05-28 Huwylerl: created                                             #
#                                                                          #
#==========================================================================#

# Path of the VMM Powershell module
$VmmModulePath = "C:\Program Files\Microsoft System Center 2012 R2\Virtual Machine Manager\bin\psModules\virtualmachinemanager"

# VMM server's name
$VmmServer = "localhost"


#*************************
# functions
#*************************

# Imports the SCVMM Powershell Module
function importModules(){
    Import-Module $VmmModulePath
}

# Sets the Scvmm-Server to use
function setVmmServer(){
    get-scvmmserver localhost > $null
}

# Prints the welcome message
function printHello(){
    write-host "==================================================================="
    write-host "                    VMM Service Manager                            "
    write-host "==================================================================="
    write-host 
    write-host "This script let you shutdown or delete all services in a cloud..."
}

# Prints the finish message ans pauses (window would close immediatly if not)
function printEnd(){
    write-host
    write-host
    write-host -ForegroundColor Cyan "-----> FERTIG :D"
    write-host
    pause
}

# prompts for the Clouds name to use
function inputCloudName(){
    $value = Read-Host "`n`nCloudName"
    return $value
}

# promts for the Action to perform
function inputAction(){
    $value = Read-Host "Type an action to perform...`n(ShutdownServices, StopServices, DeleteServices)"
    return $value
}

# Returns the Cloud object with the given name
function getCloud($cloudname){
    $cloud = Get-SCCloud | Where-Object {$_.Name -eq $cloudname}
    return $cloud
}

# Returns all Service Object in the given cloud object
function getServices($cloud){
    $services = Get-SCService | Where-Object {$_.Cloud -eq $cloud}
    return $services
}

# Prints a list of all selected Services in a readable form
function printServices($services){
    Write-Host
    Write-Host "Your Cloud contains the following services:`n"
    $services | sort name | Format-Table -Property Name
}

# starts a shutdown job for all given Service Objects
function shutdownServices($services){
    ForEach($service in $services){
        write-host -ForegroundColor Yellow ("Starting job for shutting down service " + $service.Name)
        Stop-SCService -Service $service -Shutdown -RunAsynchronously > $null
    }
}

# starts a stop job for all given Service Objects
function stopServices($services){
    ForEach($service in $services){
        write-host -ForegroundColor Yellow ("Starting job for stopping service " + $service.Name)
        Stop-SCService -Service $service -RunAsynchronously > $null
    }
}

# starts a delete job for all given Service Objects
function deleteServices($services){
    ForEach($service in $services){
        write-host -ForegroundColor Yellow ("Starting job for deleting service " + $service.Name)
        Remove-SCService -Service $service -RunAsynchronously > $null
    }
}


#*************************
# main
#*************************

printHello


# Prompt for Cloud to use
do {

    $errorhappend = 0
    $cloudname = inputCloudName
    $cloud = getCloud($cloudname)

    # Error handling
    if (!$cloud)
    {
        write-host -ForegroundColor red "Cloud not found :("
        $errorhappend = 1
    }
    elseif ((($cloud | Measure-Object).Count) -gt 1)
    {
        write-host -ForegroundColor red "More than one Cloud found"
        $errorhappend = 1
    }
    elseif (((getServices($cloud)).Count) -lt 1) 
    {
        write-host -ForegroundColor red "There are no Services in this Cloud"
        $errorhappend = 1
    }

} while ($errorhappend)


$services = getServices($cloud)
printServices($services)


# Prompt for Action to Perform
do {

    $errorhappend = 0
    $action = inputAction

    # Shutdown
    if ($action -eq "ShutdownServices")
    {
        Write-Host -ForegroundColor Yellow "`nYou are about to shutdown ALL services..."
        pause
        Write-Host
        shutdownServices($services)
    }
    # Stop
    elseif ($action -eq "StopServices")
    {
        Write-Host -ForegroundColor Yellow "`nYou are about to stop ALL services..."
        pause
        Write-Host
        stopServices($services)
    }
    # Delete
    elseif ($action -eq "DeleteServices")
    {
        Write-Host -ForegroundColor Yellow "You are about to delete ALL services..."
        pause
        Write-Host -ForegroundColor Red "`nARE YOUR REALLY SURE????"
        pause
        Write-Host
        deleteServices($services)
    }
    else {
        Write-Host -ForegroundColor red "This option is not aviable"
        $errorhappend = 1
    }

} while ($errorhappend)

printEnd
