# example of using management APIs to manualy trigger an auto update check. 
    
    #load the needed dlls
    $dllsToLoad = @("\Sage.Connector.Management.dll", 
                    "\Sage.Connector.Data.dll",
                    "\Sage.Connector.Common.dll",
                    "\Sage.Connector.Logging.dll",
                    "\Sage.Connector.DispatchService.Proxy.dll",
                    "\Sage.Connector.DispatchService.Interfaces.dll"
                    
                    )
    
    $loc = Get-Location
    foreach($dll in $dllsToLoad)
    {
        $fullDllName = $loc.Path + $dll
        [Reflection.Assembly]::LoadFile($fullDllName) | out-null
    }
    


    #Now actualy trigger an update check. Note that currently updates are not applied until the next domain mediation message flows thru the system.
   [Sage.Connector.Management.ConfigurationHelpers]::CheckForAutoUpdates()


    
