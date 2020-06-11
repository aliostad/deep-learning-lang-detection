function isInValid( [bool]$isValid )
{
    if ($isValid) { return $LASTEXITCODE -ne 0 }
    else { return $LASTEXITCODE -eq 0 }
}

function performTestSuite( [string]$where, [bool]$isValid, [string]$command, [bool]$showAll )
{
    if ( $isValid ) { $testPath = $where + "\valid\" }
    else { $testPath = $where + "\invalid\" }

    $toSearch = $testPath + "*.txt"

    ls $($toSearch) | % {
        write-host -nonewline "."
        $filename = $testPath + $_.name
        $rez = ../eq $command -f $filename
        if ( $showAll ) {
            echo "`n==========================================================="
            echo $filename
            cat $_
            $rez
        }

        if (isInvalid $isValid)
        {
            if ( -not $showAll ) {
                echo "`n==========================================================="
                cat $_
            }
            $rez
            echo $filename
            echo "FAILURE OF TEST##########"
        }
    }
}

function performValidTest( $where, $command, $showAll )
    { performTestSuite $where $true $command $showAll }
function performInvalidTest( $where, $command, $showAll )
    { performTestSuite $where $false $command $showAll }

function performFullTest( $where, $command, $showAll )
{
    performValidTest $where $command $showAll
    performInvalidTest $where $command $showAll
}

$toShowAll = $false
if ($args[0] -eq "-showAll") { $toShowAll = $true }

performFullTest "eval" "eval" $toShowAll
performFullTest "derivate" "eval" $toShowAll
performFullTest "programm" "eval" $toShowAll
