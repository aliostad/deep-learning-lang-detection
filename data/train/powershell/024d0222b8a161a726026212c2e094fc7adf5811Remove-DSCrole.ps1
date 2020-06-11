function Remove-DSCrole
{
[cmdletbinding()]
Param(
    [Parameter(
        ParameterSetName="ByObject",
        ValueFromPipeline=$true
    )]
    [pscustomobject[]]$Role
    ,
    [Parameter(ParameterSetName="ByName")]
    [string]$Name
    ,
    [Parameter(ParameterSetName="ByGUID")]
    [string]$guid
)

BEGIN
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$F - START"

    if ($Guid)
    {         
        $Role = Get-DSCrole -Guid $Guid
    }
}

PROCESS
{
    foreach($dscrole in $role.GetEnumerator())
    {
        Write-Verbose -Message "$f -  Removing item with name '$($dscrole.Name)'"
        Save-DSCdata -Type Role -object $dscrole -Delete
    }
}

END
{
    Write-Verbose -Message "$f - END"
}
}