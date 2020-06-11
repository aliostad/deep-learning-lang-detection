workflow Wait-VMMJob {

    [OutputType([PSCustomObject])]

    param (
        [Parameter(Mandatory)]
        [String]$VMMJobId,

        [Parameter(Mandatory)]
        [String]$VMMServer,

        [Parameter(Mandatory)]
        [PSCredential]$VMMCreds
    )

    $OutputObj = [PSCustomObject] @{}

    Write-Verbose -Message 'Running Runbook: Wait-VMMJob'
    Write-Verbose -Message "VMMJobId: $VMMJobId"
    Write-Verbose -Message "VMMServer: $VMMServer"
    Write-Verbose -Message "VMMCreds: $($VMMCreds.UserName)"

    try {
        $Result = InlineScript {
            $ErrorActionPreference = 'Stop'
            $VerbosePreference=[System.Management.Automation.ActionPreference]$Using:VerbosePreference
            $DebugPreference=[System.Management.Automation.ActionPreference]$Using:DebugPreference 

            Write-Verbose -Message 'Loading VMM Environmental data'
            Get-SCVMMServer -ComputerName $Using:VMMServer -ErrorAction Stop | Out-Null

            Write-Verbose -Message 'Start Monitoring VMM Job'
            while ((Get-SCJob -ID $using:VMMJobId).Status -eq 'Running') {
                Write-Debug -Message 'Waiting for job to stop Running, sleeping for 3 seconds'
                Start-Sleep -Seconds 3
            }
            $status = [String](Get-SCJob -ID $using:VMMJobId).StatusString
            return $status
        } -PSComputerName $VMMServer -PSCredential $VMMCreds -PSRequiredModules VirtualMachineManager
        Add-Member -InputObject $OutputObj -MemberType NoteProperty -Name 'Status' -Value $Result
    }
    catch {
        Add-Member -InputObject $OutputObj -MemberType NoteProperty -Name 'error' -Value $_.message
    }
    return $OutputObj
}