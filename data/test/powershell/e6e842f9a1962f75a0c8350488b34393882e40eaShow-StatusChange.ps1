function Show-StateChange()
{
    
    Param( [Alias("DNSHostName")]
           [Alias("Name")]
           [Alias("MachineName")]
           [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$ComputerName
          ,[Parameter(Mandatory=$false)][int32]$MaxRunTime
    )

    Begin
    {
        $loop = $true
        $CurrentState = @{"ComputerName"=$ComputerName;"Status"="";"DateTime"=(Get-Date)}
        $SetDateTime = (Get-Date)
    }
    Process
    {
        while($loop -eq $true)
        {
            if(!(Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue))
            {
                $NewState = @{"ComputerName"=$ComputerName;"Status"="offline";"DateTime"=(Get-Date)}
            }
            else
            {
                $NewState = @{"ComputerName"=$ComputerName;"Status"="online";"DateTime"=(Get-Date)}
            }
            
            if($NewState.Status -ne $CurrentState.Status)
            {
                #$NewState | Format-Table *
                Write-Host ($NewState["ComputerName"] + " " + $NewState["Status"] + " " + $NewState["DateTime"])
                $CurrentState = $NewState
            }

            Start-Sleep -Seconds 1
        }
    }
    End
    {
        [DateTime]::Compare($SetDateTime,(Get-Date))
    }
}

Show-StateChange "QNAP"

