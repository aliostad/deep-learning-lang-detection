function Add-DSCattribute
{ 
[cmdletbinding()]
Param(
    [string]$Name
    ,
    $Value
    ,
    [String]$Type
    ,
    [String]$Description
)
    $guid = [guid]::NewGuid().Guid

    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$F - START"

    $attrib = $null
    $attrib = Get-DSCattribute -Name $Name

    if($attrib)
    { 
        throw "Attribute with name '$Name' already exists"
    }

    $newAttribute = [pscustomobject]@{ 
        Name = $Name
        Value = $Value
        Type = $Type
        Guid = $guid
        Description = $Description
    }

    Save-DSCdata -Type Attribute -object $newAttribute

    return $newAttribute
}