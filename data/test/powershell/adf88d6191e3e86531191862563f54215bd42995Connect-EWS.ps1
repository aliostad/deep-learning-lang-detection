function Connect-EWS{
    param(
        [Parameter(Mandatory=$true)][ExchVer]$ExchVer,
        [Parameter(Mandatory=$true)][string]$AccountWithImpersonationRights,
        [Parameter(Mandatory=$true)][string]$ImpersonationAccountPassword,
        [Parameter(Mandatory=$true)][string]$MailboxToImpersonate
    )
    try {
        $EWS = [EWS]::new($ExchVer, $AccountWithImpersonationRights, $ImpersonationAccountPassword, $MailboxToImpersonate)
        return $EWS
    }
    catch {
        $MSG = "{0}`n{1}" -f $_.Exception.Message,$_.InvocationInfo.PositionMessage
        Write-EventLog -LogName "BackupReportMonitor" -Source "Public" -EventId 201 -Category 2 -EntryType "Error" -Message $MSG
        break
    }
}