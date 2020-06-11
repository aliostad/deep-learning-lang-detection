function Get-RectanglePerimeter
{
    <#
    .Synopsis
        Gets the perimeter of a rectangle 
    .Description
        Gets the perimeter of a rectangle, using the simple equation
        
        Permieter = 2a + 2b
    #>
    [CmdletBinding(DefaultParameterSetName='ASideBSide')]
    param(
    # The Length of Side A
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]    
    [Double]
    $LengthOfSideA,
    
    # The Length of Side B
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]
    [Double]
    $LengthOfSideB
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'ASideBSide') {

            Invoke-Equation {
# Total side A
$totalSideA = 2 * $LengthOfSideA 
# Total side B
$totalSideB = 2 * $LengthOfSideB 
# The Perimeter is 2a + 2b
$rectanglePerimeter = $totalSideA + $totalSideB
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
 
