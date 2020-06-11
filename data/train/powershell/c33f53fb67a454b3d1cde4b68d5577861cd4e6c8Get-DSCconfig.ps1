function Get-DSCconfig
{
[cmdletbinding()]
Param(
    [string]$Name
    ,
    [Parameter(ParameterSetName="ByGUID")]
    [String]$GUID
    ,

    [String]$NodeName
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$F - START"

    $configs = $null
    $configs = Get-DSCdata -Type Configuration

    if ($configs)
    { 
        if ($Guid)
        {
            Write-Verbose -Message "$f -  Searching by GUID"
            $configs | where GUID -eq $Guid
        }
        else
        {
            Write-Verbose -Message "$f -  Searching by Name"
            if(-not $Name)
            {
                $Name = "*"
            }
            $configs | where Name -like "$Name"
        } 
    }
}