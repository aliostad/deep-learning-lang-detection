function Get-TrapezoidArea
{
    <#
    .Synopsis
        Gets the area of a Trapezoid 
    .Description
        Gets the area of a Trapezoid, using the simple equation
        
        Area = h/2 * (b1 + b2)
    #>
    [CmdletBinding(DefaultParameterSetName='HeightOverTwoTimesBaseTotal')]
    param(
    # The First Trapezoid Base
    [Parameter(Mandatory=$true,ParameterSetName='HeightOverTwoTimesBaseTotal')]    
    [Double]
    $Base1,
    
    # The Second Trapezoid Base
    [Parameter(Mandatory=$true,ParameterSetName='HeightOverTwoTimesBaseTotal')]    
    [Double]
    $Base2,

    # The Trapezoid Height
    [Parameter(Mandatory=$true,ParameterSetName='HeightOverTwoTimesBaseTotal')]
    [Double]
    $Height
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'HeightOverTwoTimesBaseTotal') {

            Invoke-Equation {
# Total the bases
$BaseTotal = $Base1 + $Base2
# Divide the height by 2
$halfHeight = $height / 2
# Area is Half of the Height * The Total of the Bases
$TrapezoidArea = $HalfHeight * $BaseTotal
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
 
 
