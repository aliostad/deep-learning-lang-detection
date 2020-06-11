function Get-Angle
{
    <#
    .Synopsis
        Calculates an angle
    .Description
        Gets the angle of a given slope, given rise over run
    #>
    param(
    # The rise of the slope
    [Parameter(Mandatory=$true,Position=0)]
    [Double]
    $Rise,

    # The run of the slope
    [Parameter(Mandatory=$true,Position=1)]
    [Double]
    $Run,

    # If set, will show the work
    [Switch]
    $ShowWork
    )

    process {
        if ($run -eq 0) {
            90
        } else {
            Invoke-Equation {
# The tangent of the angle is equal to the opposite (the rise) over the adjacent (the run)
$RiseOverRun = $rise /  $run

# The ArcTan of Rise Over Run provides an angle, in Radians

$AngleInRadians = [Math]::Atan($RiseOverRun)

# To convert to degrees, divide by PI / 180
$angle = $AngleInRadians / ([Math]::PI / 180)
            } -ShowWork:$ShowWork                                
        }
    }
} 
 
