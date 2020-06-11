
Function CreateHeading([string] $test, [string] $title)
{
    Write-Host '################################################################################' -NoNewline
    Write-Host "Test ID = $test"
    Write-Host "Test Title = $title"
}

Function ShowValues($expected, $received)
{
    Write-Host "Expected Value = $expected"
    Write-Host "Received Value = $received"
    if ($expected -eq $received)
        { Write-Host 'Test Passed' -BackgroundColor Green }
    else
        { Write-Host 'Test Failed' -BackgroundColor Red}
}

Function CreateFooter
{
    Write-Host '################################################################################'
}
