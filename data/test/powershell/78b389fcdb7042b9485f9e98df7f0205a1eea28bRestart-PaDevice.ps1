function Restart-PaDevice {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$False)]
        [switch]$Quiet,

        [Parameter(Mandatory=$False)]
        [switch]$ShowProgress,
        
        [Parameter(Mandatory=$False)]
        [switch]$WaitForCompletion
    )

    $CmdletName = $MyInvocation.MyCommand.Name

    $Device = $global:PaDeviceObject.Device
    $ApiKey = $global:PaDeviceObject.ApiKey

    $TimerStart = Get-Date

    HelperWriteCustomVerbose $CmdletName "Issuing restart command"
    $Command      = "<request><restart><system></system></restart></request>"
    $ResponseData = Invoke-PaOperation $Command
    HelperWriteCustomVerbose $CmdletName "Restart command issued"
    
    $global:PaDeviceObject = $null

    $ProgressParams = @{'Activity'         = "Waiting for device to reboot"
                        'CurrentOperation' = "Checking status in $CheckInterval seconds..."}
    
    $JobParams = @{ 'Id' = 1
                    'CheckInterval' = 5 }

    if ($ShowProgress) {
        $JobParams         += @{ 'ShowProgress' = $true } 
        $WaitForCompletion  = $true
    }

    if ($WaitForCompletion) {
        $JobParams += @{ 'WaitForCompletion' = $true }

        $CheckInterval   = 15
        $InitialInterval = 60
        $i = 0

        while ($i -lt ($InitialInterval - $CheckInterval)) {
            Start-Sleep -s 1
            $i ++
            if ($ShowProgress) {
                $ProgressParams.Set_Item("CurrentOperation","Checking Status in $($InitialInterval - $i) seconds...")
                Write-Progress @ProgressParams
            }
        }

        if ($ShowProgress) {
            $ProgressParams.Set_Item("CurrentOperation","Trying to reconnect...")
            Write-Progress @ProgressParams
        }
    

        $IsUp = $False
        HelperWriteCustomVerbose $CmdletName "Starting check loop"
        while (!($IsUp)) {
            try {
                $i = 0
                while ($i -lt $CheckInterval) {
                    Start-Sleep -s 1
                    $i ++
                    if ($ShowProgress) {
                        $ProgressParams.Set_Item("CurrentOperation","Checking Status in $($CheckInterval - $i) seconds...")
                        Write-Progress @ProgressParams
                    }
                }

                if ($ShowProgress) {
                    $ProgressParams.Set_Item("CurrentOperation","Trying to reconnect...")
                    Write-Progress @ProgressParams
                }
                $TimerStop     = Get-Date
                $ExecutionTime = [math]::Truncate(($TimerStop - $TimerStart).TotalSeconds)
                HelperWriteCustomVerbose $CmdletName "$ExecutionTime seconds elapsed, trying to connect"

                $Reconnect = Get-PaDevice -Device $Device -ApiKey $ApiKey
            
                HelperWriteCustomVerbose $CmdletName "Connection succeeeded"
                $IsUp = $true
            } catch {
                $IsUp = $False
                switch ($_.Exception.Message) {
                    {$_ -match 'System.Web.HttpException'} {
                        HelperWriteCustomVerbose $CmdletName "Device is not up yet"
                    }
                    default {
                        Throw $_.Exception.Message
                    }
                }
            }
        }

        $ProgressParams.Set_Item("Completed",$true)
        Write-Progress @ProgressParams
    
        #####################################################################################
        # Wait for autocommit job to complete



        $JobStatus = Get-PaJob @JobParams
        if ($JobStatus.NextJob) {
            $JobParams.Set_Item('Id',$JobStatus.NextJob)
            $JobStatus = Get-PaJob @JobParams
        }
        $global:test2 = $JobStatus
        if ($JobStatus.Result -eq 'Fail') {
            Throw $JobStatus.Details
        }
    }
}
