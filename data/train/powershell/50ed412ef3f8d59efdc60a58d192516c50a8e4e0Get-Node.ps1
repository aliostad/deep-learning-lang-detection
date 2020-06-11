function Get-Node
{
[cmdletbinding()]
Param(
    [string]$Name
    ,
    [Parameter(ParameterSetName="ByGUID")]
    [String]$Guid
)
BEGIN
{ 
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
    $Nodes = Get-DSCdata -Type DSCnode
}

PROCESS
{
    if($Nodes)
    {
        if($Guid)
        {
            Write-Verbose -Message "$f -  Searching by GUID"
            $Nodes | where guid -eq $Guid
        }
        else
        {
            if(-not $Name)
            {
                $Name = "*"
            }
            Write-Verbose -Message "$f -  Searching by Name '$Name'"
            $Nodes | where Name -like "$Name"
        }
    }
    else
    { 
        Write-Verbose -Message "$f -  No nodes found"
    }
}

END
{ 
    Write-Verbose -Message "$f - END"
}
}