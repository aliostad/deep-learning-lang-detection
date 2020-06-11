function Remove-DSCattribute
{
[cmdletbinding()]
Param(
    [Parameter(
        ParameterSetName="ByObject",
        ValueFromPipeline=$true
    )]
    [pscustomobject[]]$Attribute
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
        $Attribute = Get-DSCattribute -Guid $Guid
    }
}

PROCESS
{
    foreach($dscAttrib in $Attribute.GetEnumerator())
    {
        Write-Verbose -Message "$f -  Removing item with name '$($dscAttrib.Name)'"
        Save-DSCdata -Type Attribute -object $dscAttrib -Delete
    }
}

END
{
    Write-Verbose -Message "$f - END"
}
}