#Need to load the entire module as this requires the start-log function which is in a different ps1 file.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$here\..\PSAX.psm1"

Describe "Write-Log" {
    BeforeEach{
        # Need to start the log first as this creates the log file. Write log does not create the file so it'll fail if you try to unit test it by itself
        $Log = Start-Log -Path "${TestDrive}" -Name "example"
    }

    Context "Write default log" {
        It "Creates a line entry in example.log with default"{
            Write-Log -Log $Log -LogData 'Test Message Default'
            $Log.LogPath | Should Contain '"logData":"Test Message Default".*"severity":"Information"'
        }
    }

    Context "Write error log" {
        It "Creates a line entry in example.log with error"{
            Write-Log -Log $Log -LogData 'Test Message Error' -Severity 'Error'
            $Log.LogPath | Should Contain '"logData":"Test Message Error".*"severity":"Error"'
        }
    }

    Context "Write warning log" {
        It "Creates a line entry in example.log with warning"{
            Write-Log -Log $Log -LogData 'Test Message warning' -Severity 'Warning'
            $Log.LogPath | Should Contain '"logData":"Test Message warning".*"severity":"Warning"'
        }
    }

    Context "Write Debug log" {
        It "Creates a line entry in example.log with debug"{
            Write-Log -Log $Log -LogData 'Test Message Debug' -Severity 'Debug'
            $Log.LogPath | Should Contain '"logData":"Test Message Debug".*"severity":"Debug"'
        }
    }

    Context "Write Information log" {
        It "Creates a line entry in example.log with info"{
            Write-Log -Log $Log -LogData 'Test Message Information'
            $Log.LogPath | Should Contain '"logData":"Test Message Information".*"severity":"Information"'
        }
    }

    Context "Unknown severity type" {
        It "Throw unknown Severity Type" {
            { Write-Log -Log $Log -LogData 'Test Message Information' -Severity 'ASDjklSDFIOU' } | Should Throw
        }
    }
}
