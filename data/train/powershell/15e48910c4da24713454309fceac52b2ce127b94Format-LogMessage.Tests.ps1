. "$PSScriptRoot\..\src\PsLogging\private\Format-LogMessage.ps1"

Describe Format-LogMessage {
    Context "Format an message" {
        $result = Format-LogMessage -Message "message"

        It "should return the message" {
            $result | Should Be "message"
        }
    }

    Context "Format a message with an error" {
        $error = $null
        try { $x = 1/0 } catch { $error = $_ }
        $result = Format-LogMessage -Message "message" -Error $error

        It "should return the message" {
            $result | Should BeLike "message*"
            $result | Should BeLike "*RuntimeException*"
        }
    }

}