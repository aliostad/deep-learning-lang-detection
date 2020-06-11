﻿function Get-WSUSSyncEvent {
    <#  
    .SYNOPSIS  
        Retrieves all WSUS synchronization events.
    .DESCRIPTION
        Retrieves all WSUS synchronization events from the WSUS server.  
    .NOTES  
        Name: Get-WSUSSyncEvent 
        Author: Boe Prox
        DateCreated: 24SEPT2010 
               
    .LINK  
        https://learn-powershell.net
    .EXAMPLE
    Get-WSUSSyncEvent 

    Description
    -----------
    This command will show you all of the WSUS events.
           
    #> 
    [cmdletbinding()]  
    Param () 
    Begin {
        $sub = $wsus.GetSubscription()
    }
    Process {
        $sub.GetEventHistory()      
    }
}