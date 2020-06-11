function Stop-ProcessList {
    [CmdletBinding()]
    param([string[]]$List)

    foreach ($item in $List) {

        $isRunning = Get-Process $item -ErrorAction SilentlyContinue

        if ($isRunning) {
            Write-Verbose -Message "Stopping $item..."
            Stop-Process -Name $item
            Write-Verbose -Message "$item stopped."
        }
        else {
            Write-Verbose -Message "No such program named $item.  Moving on."
        }

    }

}

function Restart-ServiceList {
    [CmdletBinding()]
    param([string[]]$List)

    foreach ($item in $List) {

        $isRunning = Get-Service $item -ErrorAction SilentlyContinue

        if ($isRunning) {
            Write-Verbose -Message "Restarting $item..."
            Restart-Service -Name $item
            Write-Verbose -Message "$item restarted."
        }
        else {
            Write-Verbose -Message "No such service named $item.  Moving on."
        }

    }

}

function Restart-Spooler {
    [CmdletBinding()]
    param()

    Write-Verbose -Message "Stopping the print spooler."
    Stop-Service -Name Spooler -Force
    Write-Verbose -Message "Done."

    Write-Verbose "Clearing the print queue of all jobs..."
    Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Recurse
    Write-Verbose -Message "Done."

    Write-Verbose -Message "Restarting the print spooler..."
    Start-Service -Name Spooler
    Write-Verbose -Message "Done."

}

function Invoke-PrinterTestPage {
    [CmdletBinding()]
    Param([string]$PrinterName)
    
    Write-Verbose -Message "Sending a test page to confirm printer is working."

    $printer = Get-WmiObject -Class Win32_Printer | Where-Object {$_.name -eq "$Name"}
    $printer.PrintTestPage()

}