function Get-TriangleSide
{
    <#
    .Synopsis
        Gets the sides of a triangle
    .Description
        Gets the sides of a triangle, using the law of Pythagoras:
        
        a^2 + b^2 = c^2
    #>
    [CmdletBinding(DefaultParameterSetName='ASideBSide')]
    param(
    # The Length of Side A
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]
    [Parameter(Mandatory=$true,ParameterSetName='ASideCSide')]
    [Double]
    $LengthOfSideA,
    
    # The Length of Side B
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]
    [Parameter(Mandatory=$true,ParameterSetName='BSideCSide')]
    [Double]
    $LengthOfSideB,
    
    # The Length of Side C
    [Parameter(Mandatory=$true,ParameterSetName='ASideCSide')]
    [Parameter(Mandatory=$true,ParameterSetName='BSideCSide')]
    [Double]
    $LengthOfSideC            
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'ASideBSide') {

            Invoke-Equation {
# Square A
$aSquared = $LengthOfSideA * $LengthOfSideA
# Square B
$bSquared = $LengthOfSideB * $LengthOfSideB
# Get the square root of the values
[Math]::Sqrt($aSquared  + $bSquared)   

} -ShowWork:$ShowWork
            
            
        } elseif ($psCmdlet.ParameterSetName -eq 'BSideCSide') {
            Invoke-Equation {
# Square C
$cSquared = $LengthOfSideC * $LengthOfSideC
# Square B
$bSquared = $LengthOfSideB * $LengthOfSideB
# Get the square root of the values
[Math]::Sqrt($cSquared  + $bSquared)   

} -ShowWork:$ShowWork
        } elseif ($psCmdlet.ParameterSetName -eq 'ASideCSide') {
            Invoke-Equation {
# Square A
$aSquared = $LengthOfSideA * $LengthOfSideA
# Square C
$cSquared = $LengthOfSideC * $LengthOfSideC
# Get the square root of the values
[Math]::Sqrt($aSquared  + $cSquared)   

} -ShowWork:$ShowWork
        }
    }
}