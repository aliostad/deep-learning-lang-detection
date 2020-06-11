function Get-SquarePerimeter
{
    <#
    .Synopsis
        Gets the Perimeter of a square
    .Description
        Gets the Perimeter of a square, using the simple equation
        
        Perimeter = side*4
    #>
    [CmdletBinding(DefaultParameterSetName='LengthOfEachSide')]
    param(
    # The Length of Each Side 
    [Parameter(Mandatory=$true,ParameterSetName='LengthOfEachSide')]    
    [Double]
    $LengthOfEachSide
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'LengthOfEachSide') {

            Invoke-Equation {
# The perimeter is the LengthOfEachSide * 4
$SquarePerimeter = $LengthOfEachSide * 4
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
 
