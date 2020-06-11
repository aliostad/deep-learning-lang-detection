Try
{
    Start-Transcript -Path 'C:\Temp\SSM_windows_task.log' -Append
    $datetime = Get-Date
    Write-Output "SSM windows task starting at $datetime"
    import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
    Set-AWSProxy -Hostname Proxy -Port 8080

    $AZ = (Invoke-RestMethod http://169.254.169.254/latest/meta-data/placement/availability-zone)
    $region = [regex]::match($AZ,'[a-z]*\-[a-z]*\-[1-9]').Groups[0].Value

    Set-DefaultAWSRegion $region

    $InstanceId = Invoke-RestMethod http://169.254.169.254/latest/meta-data/instance-id

    $SSMfilter = New-Object Amazon.SimpleSystemsManagement.Model.AssociationFilter `
                                   -Property @{key = "InstanceId"; Value = $InstanceId}

    $AssociatedSSMDoc = (Get-SSMAssociationList -AssociationFilterList $SSMfilter -MaxResult 1).Name

    $Association = Get-SSMAssociation -Name $AssociatedSSMDoc -InstanceID $instanceid
    If ($Association -and ($Association.Status.Name -eq 'Associated'))
    {
        Write-Output "SSM status is associated"
        $SSMDoc = (Get-SSMDocument -Name $AssociatedSSMDoc)
        $commands = (ConvertFrom-Json $SSMDoc.Content).runtimeConfig.'aws:psModule'.properties.runCommand
        if ( $commands -like '*Add-Computer*' ) { Exit }
        $datetime = Get-Date
        Update-SSMAssociationStatus -InstanceId $InstanceId `
                                    -Name $AssociatedSSMDoc `
                                    -AssociationStatus_Date $datetime `
                                    -AssociationStatus_Name "Pending" `
                                    -AssociationStatus_Message "Execution of the commands have started"
        $SSM_Message = ""
        $cmd_count = 0
        Foreach ($cmd in $commands)
        {
            $cmd_count++
            Invoke-Expression $cmd -ErrorVariable err -WarningVariable warn -OutVariable out
            if ($err) { $SSM_Message+= "Error($cmd_count)- $err" }
            if ($warn ) { $SSM_Message+= "Warn($cmd_count)- $warn" }
            if ($out ) { $SSM_Message+= "Command_Output($cmd_count)- $out" }
        }
        $datetime = Get-Date
        $nonAlphaNumeric = '[^a-zA-Z0-9 ]'
        $SSM_Message = $SSM_Message -replace $nonAlphaNumeric, ''
        if ( $SSM_Message -like '*Error*' ) {
            Write-Output "SSM task failed"
            Update-SSMAssociationStatus -InstanceId $InstanceId `
                                    -Name $AssociatedSSMDoc `
                                    -AssociationStatus_Date $datetime `
                                    -AssociationStatus_Name "Failed" `
                                    -AssociationStatus_Message "$SSM_Message" 
        }
        Else {
            Write-Output "SSM task succeeded"
            Update-SSMAssociationStatus -InstanceId $InstanceId `
                                    -Name $AssociatedSSMDoc `
                                    -AssociationStatus_Date $datetime `
                                    -AssociationStatus_Name "Success" `
                                    -AssociationStatus_Message "$SSM_Message"
        }
    }
}
Catch
{
    Write-Output $_
}
Finally
{
    Stop-Transcript
}
