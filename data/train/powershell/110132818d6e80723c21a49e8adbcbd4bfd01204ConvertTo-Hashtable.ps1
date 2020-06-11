#Requires -Version 4.0
function ConvertTo-Hashtable
{
<#
.SYNOPSIS
    Converts a PScustomobject to a hashtable

.DESCRIPTION
    Converts a PScustomobject to a hashtable

.PARAMETER InputObject
    The PSCustomObject you want to convert to a hashtable

.EXAMPLE
    $obj = [PSCustomobject]@{
        Name = "Tore"
        Value = "Test"
    }

    $obj | ConvertTo-Hashtable

    This will create a hashtable with keys matching the properties of the object.

.INPUTS
    PSCustomObject

.OUTPUTS
    System.Collections.Specialized.OrderedDictionary

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param (
    [Parameter(ValueFromPipeline)]
    [PSCustomObject]$InputObject
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process
{   
    Write-Verbose -Message "$F -  Processing [$($inputobject.GetType().Name)]" 
    if ($InputObject -is [array])
    {
        Write-Verbose -Message "Is array object"
        foreach ($item in $value)
        {            
            $item | ConvertTo-Hash
        }        
    }

    if ($InputObject -is [hashtable] -or $InputObject -is [System.Collections.Specialized.OrderedDictionary])
    {
        return $InputObject
    }

    $hash = [ordered]@{}

    if ($InputObject -is [System.Management.Automation.PSCustomObject])
    {
        Write-Verbose -Message "$f -  Processing [pscustomobject]"

        foreach ($prop in $InputObject.psobject.Properties)
        {
            $name = $prop.Name
            $value = $prop.Value
            Write-Verbose -Message "$f - Property [$name]"
            

            if ($value -is [System.Management.Automation.PSCustomObject])
            {
                Write-Verbose -Message "$f -  Value is PScustomobject"
                $value = $value | ConvertTo-Hash                    
            }

            if ($value -is [array])
            {
                Write-Verbose -Message "$f -  Value is array"
                $hashValue = @()
                if ($value[0] -is [hashtable] -or $value[0] -is [System.Collections.Specialized.OrderedDictionary] -or $value[0] -is [PSCustomObject])
                {
                    foreach ($item in $value)
                    {            
                        $hashValue += ($item | ConvertTo-Hash)
                    }
                }
                else 
                {
                    $hashValue = $value
                }                               
                $value = $hashValue
            }
            $hash.Add($name,$value)
        }
    }
    $hash
}

End 
{
    Write-Verbose -Message "$f - END"
}
}