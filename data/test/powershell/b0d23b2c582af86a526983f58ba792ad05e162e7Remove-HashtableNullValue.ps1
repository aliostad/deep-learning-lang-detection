Function Remove-HashtableNullValue
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [Alias("InputObject")]
    [hashtable]$Hash
)
    BEGIN
    {
        $F = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
        [int]$CountNonNull = 0
    }

    PROCESS
    {    
        foreach($key in $Hash.Keys)
        {
            if($Hash.$key -ne $null)
            {
                $CountNonNull ++
            }
        }
        if($CountNonNull -gt 0)
        {
            foreach($KeyValue in $Hash.Clone().GetEnumerator())
            {
                if($KeyValue.Value -eq $null)
                {
                    Write-Verbose -Message "$f -  Key '$($KeyValue.key)' is null, removing it"
                    $Hash.Remove($KeyValue.Key)
                }
            }
            return $hash
        }
        else
        {
            Write-Verbose -Message "$f -  All keys were null"
            return @{}
        }
    }

    END
    {
        Write-Verbose -Message "$f - END"
    }
}