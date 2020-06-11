function Get-EllipseArea
{
    <#
    .Synopsis
        Gets the area of an ellipse
    .Description
        Gets the area of an ellipse, using the simple equation
        
        Area = Pi * Radius1 * Radius2        
    #>
    [CmdletBinding(DefaultParameterSetName='Radius')]
    param(
    # The radius
    [Parameter(Mandatory=$true,ParameterSetName='Radius')]    
    [Double]
    $Radius1,
    
    # The diameter
    [Parameter(Mandatory=$true,ParameterSetName='Radius')]    
    [Double]
    $Radius2
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'Radius') {
            Invoke-Equation {
# Multiply the two radii
$radiiMultiplied = $radius1 * $radius2
# Get the value of Pi
$pi = [Math]::PI
# Area is Pi * Radius1 * Radius2
$ellipseArea = $pi * $radiiMultiplied
} -ShowWork:$ShowWork                        
        } 
    }
} 
 
 
