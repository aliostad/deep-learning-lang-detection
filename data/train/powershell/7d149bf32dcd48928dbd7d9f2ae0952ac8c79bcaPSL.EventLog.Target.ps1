PSLTarget 'EventLog' {
    param(
    $Level,
    $DateTime,
    $Message,
    $Context,
    $PSLogger
    )

    try { New-EventLog -LogName $PSLogger.Name -Source $Context -ErrorAction Stop | Out-Null }
    catch {}

    $Message = "{0}: {1}" -f $Level, $Message

    switch($Level) {
        'Error'   { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType FailureAudit -EventId 0 -Message $Message }
        'Warn'    { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType Warning -EventId 0 -Message $Message }
        'Info'    { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType Information -EventId 0 -Message $Message }
        'Fatal'   { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType Error -EventId 0 -Message $Message }
        'Debug'   { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType Information -EventId 0 -Message $Message }
        'Verbose' { Write-EventLog -LogName $PSLogger.Name -Source $Context -EntryType SuccessAudit -EventId 0 -Message $Message }
    }
}