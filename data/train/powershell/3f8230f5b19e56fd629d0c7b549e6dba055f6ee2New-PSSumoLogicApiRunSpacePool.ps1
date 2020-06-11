#Requires -Version 3.0

# # -- Async cmdlets -- # #

function New-PSSumoLogicApiRunSpacePool
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $minRunSpacePoolSize = $PSSumoLogicAPI.runSpacePool.minPoolSize,

        [parameter(
            position = 0,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $maxRunSpacePoolSize = $PSSumoLogicAPI.runSpacePool.maxPoolSize
    )

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference

    try
    {
        # create Runspace
        Write-Debug ("creating runspace for powershell")
        $private:sessionstate = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
        $private:runspacePool = [runspacefactory]::CreateRunspacePool($minRunSpacePoolSize, $maxRunSpacePoolSize,  $sessionstate, $Host) # create Runspace Pool
        $runspacePool.ApartmentState = "STA" # only STA mode supports
        return $runspacePool
    }
    catch
    {
        throw $_
    }
}