function Get-RectangleArea
{
    <#
    .Synopsis
        Gets the area of a rectangle 
    .Description
        Gets the area of a rectangle, using the simple equation
        
        Area = ab
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
# Area is SideA * SideB
$rectangleArea = $LengthOfSideA * $LengthOfSideB
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
