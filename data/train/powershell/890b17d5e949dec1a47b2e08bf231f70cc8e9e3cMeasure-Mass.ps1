function Measure-Mass
{
    <#
    .Synopsis
        Calculates the mass of an object.
    .Description
        Calculates the mass of an object, using the equation
        
        Mass = Density * Volume
    #>
    [CmdletBinding(DefaultParameterSetName='ASideBSide')]
    param(
    # The Density of the Object
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]    
    [Double]
    $Density,
    
    # The Volume of the Object
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]
    [Double]
    $Volume
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'ASideBSide') {

            & {
# Mass is Density * Volume
$Mass = $Density * $Volume
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
