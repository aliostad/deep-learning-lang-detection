function Remove-Node
{
[cmdletbinding()]
Param(
    [Parameter(
        ParameterSetName="ByObject",
        ValueFromPipeline=$true
    )]
    [pscustomobject[]]$Node
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
        $Node = Get-Node -Guid $Guid
    }
}

PROCESS
{
    foreach($dscNode in $Node.GetEnumerator())
    {
        Write-Verbose -Message "$f -  Removing item with name '$($dscNode.Name)'"
        Save-DSCdata -Type DSCnode -object $node -Delete
    }
}

END
{
    Write-Verbose -Message "$f - END"
}
}