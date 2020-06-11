function Get-TrianglePerimeter
{
    <#
    .Synopsis
        Gets the perimeter of a triangle
    .Description
        Gets the perimeter of a triangle, using the simple equation:
        
        P = a + b + c
    #>
    param(
    # The Length of Side A
    [Parameter(Mandatory=$true)]
    [Double]
    $LengthOfSideA,
    
    # The Length of Side B
    [Parameter(Mandatory=$true)]   
    [Double]
    $LengthOfSideB,
    
    # The Length of Side C
    [Parameter(Mandatory=$true)]    
    [Double]
    $LengthOfSideC
    )
    
    process {
        Invoke-Equation {
# P = a + b +c
$trianglePerimeter = $LengthOfSideA + $LengthOfSideB + $LengthOfSideC
} -ShowWork:$ShowWork

    }
}