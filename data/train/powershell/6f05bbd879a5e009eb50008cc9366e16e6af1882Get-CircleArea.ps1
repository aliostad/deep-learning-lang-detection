function Get-CircleArea
{
    <#
    .Synopsis
        Gets the area of a circle
    .Description
        Gets the area of a circle, using the simple equation
        
        Area = Pi * Radius^2        
    #>
    [CmdletBinding(DefaultParameterSetName='Radius')]
    param(
    # The radius
    [Parameter(Mandatory=$true,ParameterSetName='Radius')]    
    [Double]
    $Radius,
    
    # The diameter
    [Parameter(Mandatory=$true,ParameterSetName='Diameter')]    
    [Double]
    $Diameter
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'Radius') {
            Invoke-Equation {
# Square the radius
$radiusSquared = $radius * $radius
# Get the value of Pi
$pi = [Math]::PI
# Area is Pi * radius Squared
$circleArea = $pi * $radiusSquared
} -ShowWork:$ShowWork                        
        } elseif ($psCmdlet.ParameterSetName -eq 'Diameter') {
            Invoke-Equation {
# The radius is half of the diameter
$radius = $diameter / 2
# Square the radius
$radiusSquared = $radius * $radius
# Get the value of Pi
$pi = [Math]::PI
# Area is pi * radius squared
$circleArea = $pi * $radiusSquared
} -ShowWork:$ShowWork                        
        
        }
    }
} 
 
