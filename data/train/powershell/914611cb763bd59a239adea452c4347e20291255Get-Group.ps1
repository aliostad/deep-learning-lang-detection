Function Get-Group
{
[cmdletbinding()]
Param(
    
    [string]$Name
    ,
    [string]$Description
    ,
    [string]$ObjectID
    ,
    [pscredential]$Credential
    ,
    [string]$Uri
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    [string]$ObjectType = "Group"

    $Get_Object = @{
        ObjectType  = $ObjectType
        Credential  = $Credential
        Uri         = $Uri
        ObjectName  = $null
        ObjectValue = $null
    }

    if($Name)
    {
        $Get_Object.ObjectName  = "Name"
        $Get_Object.ObjectValue = "$Name"
    }

    if($Description)
    {
        $Get_Object.ObjectName  = "Description"
        $Get_Object.ObjectValue = "$Description"
    }

    if($ObjectID)
    {
        $Get_Object.ObjectName  = "ObjectID"
        $Get_Object.ObjectValue = "$ObjectID"
    }
    
    Write-Verbose -Message "$f -  Removing null values from hashtable"
    $Get_Object = $Get_Object | Remove-HashtableNullValue

    Write-Verbose -Message "$f -  Getting objects"
    Get-Object @Get_Object

    Write-Verbose -Message "$f - END"
}