function Show-SampleFunc{
    param()
    #$PSCmdlet.WriteVerbose("Verbose")
    Write-Host "args: $args"
}
function Show-SampleHelpBinding{
    [CmdletBinding()]
    param()
    $PSCmdlet.WriteVerbose("Verbose")
    Write-Host "args: $args"
}
function Show-SampleHelpParameter{
    [Obsolete()]
    param(
        [Parameter()]$p
    )
    Write-Host "args: $args"
    Write-Host "p: $p"
    $PSCmdlet.WriteVerbose("Verbose")
}

{
Show-SampleFunc -?
Show-SampleHelpBinding -?
Show-SampleHelpBinding
Show-SampleHelpBinding -Verbose
Show-SampleHelpParameter -?
Show-SampleHelpParameter -Verbose
Get-Help Show-SampleHelpParameter -Detailed
}