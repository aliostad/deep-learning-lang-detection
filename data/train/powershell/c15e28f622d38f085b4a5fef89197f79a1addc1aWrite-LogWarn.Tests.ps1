. "$PSScriptRoot\..\src\PsLogging\private\Write-LogMessage.ps1"
. "$PSScriptRoot\..\src\PsLogging\private\Format-LogMessage.ps1"
. "$PSScriptRoot\..\src\PsLogging\public\Write-LogWarn.ps1"

Describe Write-LogWarn {
    Mock Get-PSCallStack -MockWith { @(@{ Command = "current" }; @{ Command = "caller"}) }
    Mock Format-LogMessage -MockWith { $Message }
    Mock Write-LogMessage

    Context "Write an warn log message" {
        Write-LogWarn -Message "message"

        It "should write a log message" {
            Assert-MockCalled Write-LogMessage -Exactly 1

            Assert-MockCalled Write-LogMessage -ParameterFilter {
                $Level -eq "Warn" -And
                $Message -eq "message" -And
                $LoggerName -eq "caller"
            }
        }
    }
}