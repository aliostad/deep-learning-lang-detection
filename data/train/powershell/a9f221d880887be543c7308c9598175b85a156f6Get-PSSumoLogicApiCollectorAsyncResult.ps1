#Requires -Version 3.0

# # -- Async cmdlets -- # #

function Get-PSSumoLogicApiCollectorAsyncResult
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 1)]
        [ValidateNotNullOrEmpty()]
        [array]
        $runspaceCollection
    )

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference

    # get Async result and end powershell session
    Write-Debug "obtain process result"
    foreach ($runspace in $runspaceCollection)
    {
        # obtain Asynchronous command result
        $private:task = $runspace.powershell.EndInvoke($runspace.Runspace)
        
        $property = if ((($task |measure).count -ne 0)){ ($task | Get-Member -MemberType NoteProperty).Name}
            
        # show result
        $task.$property
            
        # Dispose pipeline
        $runspace.powershell.Dispose()
    }
}
