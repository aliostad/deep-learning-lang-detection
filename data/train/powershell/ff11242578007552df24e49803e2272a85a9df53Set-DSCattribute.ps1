function Set-DSCattribute
{ 
[cmdletbinding()]
Param(
    [Parameter(
        ParameterSetName="ByObject",
        ValueFromPipeline=$true
    )]
    [pscustomobject[]]$Attribute
    ,
    [Parameter(ParameterSetName="ByGUID")]
    [String]$Guid
    ,
    [String]$Type
    ,
    [String]$Description
)
BEGIN
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
    if ($Guid)
    { 
        $Attribute = Get-DSCattribute -Guid $Guid
    }
}

PROCESS
{
    foreach($Attrib in $Attribute)
    {
        Write-Verbose -Message "$f -  Processing item $($Attrib.Name)"
        if($Type)
        {
            $Attrib.Type = $Type
        }

        if($Description)
        {
            $Attrib.Description = $Description
        }
        Save-DSCdata -Type Attribute -Update -object $Attrib
    }
}

END
{
    Write-Verbose -Message "$f - END"
}
}