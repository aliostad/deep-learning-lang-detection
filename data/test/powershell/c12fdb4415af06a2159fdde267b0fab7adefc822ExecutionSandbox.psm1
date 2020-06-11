$ErrorActionPreference = "Stop"
Import-Module (Resolve-RelativePath Announcers.psm1)

function Invoke-InSandbox( [Parameter(Mandatory=$true)]  $RunPlan,
                           [Parameter(Mandatory=$true)]  $Announcer )
    {
    $befores    = $RunPlan.Befores 
    $afters     = $RunPlan.Afters
    $Context    = $RunPlan.context
    $body       = $RunPlan.Body
    $children   = $RunPlan.Children
    $test       = $RunPlan.Test
    $suite      = $RunPlan.Suite
    $successful = $true
    $mocks = @{}

    function Mock( [Parameter(Mandatory=$true)][string]       $CommandName,
               [Parameter(Mandatory=$true)][scriptblock]  $Action )
        {
        $mocks[ $CommandName ] = $Action
        }
    
    try {
        if ( $befores -ne $null )
                {
                foreach( $before in $befores ) 
                    {
                    . $MyInvocation.MyCommand.Module $before  | Out-Null
                    foreach ( $mock in $mocks.Keys  )
                        {
                        Set-Item -Path function:global:$mock -Value $mocks[$mock]
                        }
                    }
                }
        }
    catch [System.Exception] 
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        return "failure"
        }

    if ( $test -ne $null )
        {
        Show-Progress $Announcer -Test $test 

        try {
            . $MyInvocation.MyCommand.Module $body   | Out-Null 
            Show-Progress $Announcer -Test $test -Result "success"
            }
        catch [System.Exception]
            {
            Write-Host -Foreground Red $_.Exception.Message
            Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
            $successful = $false
            Show-Progress $Announcer -Test $test -Result "failure"
            }
        }
    elseif ( $suite -ne $null )
        {
        Show-Progress $Announcer -Test $suite
        }


    foreach ( $child in $children )
        {
        $successful =  ( Invoke-InSandbox -RunPlan $child -Announcer $Announcer ) -and $successful
        }

    try {
        if ( $afters -ne $null )
                {
                foreach( $after in $afters ) 
                    {
                    . $MyInvocation.MyCommand.Module $after | Out-Null
                    }
                }
        }
    catch [System.Exception] 
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        }

    return $successful
    }

Export-ModuleMember Invoke-InSandbox
