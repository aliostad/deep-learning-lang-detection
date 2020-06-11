function Get-ParallelogramArea
{
    <#
    .Synopsis
        Gets the area of a Parallelogram 
    .Description
        Gets the area of a Parallelogram, using the simple equation
        
        Area = bh
    #>
    [CmdletBinding(DefaultParameterSetName='ASideBSide')]
    param(
    # The Parallelogram Base
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]    
    [Double]
    $Base,
    
    # The Parallelogram Height
    [Parameter(Mandatory=$true,ParameterSetName='ASideBSide')]
    [Double]
    $Height
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq 'ASideBSide') {

            Invoke-Equation {
# Area is Base * Height
$ParallelogramArea = $Base * $Height
} -ShowWork:$ShowWork
            
            
        } 
    }
} 
 
