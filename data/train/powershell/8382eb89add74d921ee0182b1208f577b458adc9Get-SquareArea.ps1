function Get-SquareArea
{
    <#
    .Synopsis
        Gets the area of a square
    .Description
        Gets the area of a square, using the simple equation
        
        Area = side^2
    #>
    [CmdletBinding(DefaultParameterSetName='ASideBSide')]
    param(
    # The Length of Each Side 
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]    
    [Double]
    $LengthOfEachSide
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'ASideBSide') {

            Invoke-Equation {
# Area is LengthOfEachSide * LengthOfEachSide
$rectangleArea = $LengthOfEachSide * $LengthOfEachSide
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
