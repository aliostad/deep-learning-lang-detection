<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Test-EngineType
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        $Engine,
        $Id,
        $Key,
        $Path,
        $FileName
    )
    
    if ($Engine.engines.fueltype -like "*electric*")
    {
        Write-Output "electric vehicle found"
        $elecVehicle = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$Id`?view=full&fmt=json&api_key=$Key")
        $elecVehicle | ConvertTo-Json | Out-File -FilePath $Path$FileName -Append -Force
    }   
}
