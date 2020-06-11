#
# Script.ps1
#

function GetUri ($partialUri)
{
    $gitApiUri = "https://api.github.com"
    return $gitApiUri + $partialUri
}

function ConvertTo-Type
{
    param(
        [Parameter(Mandatory=$true, Position=0,ValueFromPipeline=$true)]
        [PSObject]$Object,

        [Parameter(Mandatory=$true, Position=1)]
        [string]$TypeName
    )
process
{
    $Object.psobject.TypeNames.Clear()
	$Object.psobject.TypeNames.Add($TypeName)
    $Object
}
}

function ConvertTo-Enumerable
{
process
{
	$_.GetEnumerator()
}
}
