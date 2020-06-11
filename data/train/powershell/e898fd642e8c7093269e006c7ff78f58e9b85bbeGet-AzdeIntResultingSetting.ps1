Function Get-AzdeIntResultingSetting
{
    Param (
        $settingsAttribute,
        $SettingsType,
        $TargetObject,
        $ProjectName,
        $vmname
    )

    $ThisVerboseLevel = 3

    #DeploymentSetting
    Write-enhancedVerbose -MinimumVerboseLevel $ThisVerboseLevel -Message "Getting settings for attribute: $settingsattribute"
    Write-enhancedVerbose -MinimumVerboseLevel $ThisVerboseLevel -Message "Settingstype: $SettingsType"
    Write-enhancedVerbose -MinimumVerboseLevel $ThisVerboseLevel -Message "TargetObject: $TargetObject"
    Write-enhancedVerbose -MinimumVerboseLevel $ThisVerboseLevel -Message "ProjectName: $ProjectName"
    
    $Setting = $project.$SettingsType.$settingsAttribute
    
    Write-enhancedVerbose -MinimumVerboseLevel $ThisVerboseLevel -Message "Project Level: $Setting"


    if ($TargetObject -ne "Project")
    {
        #At this point, the target could be vm
        $vm = $project.Vms | where {$_.VMName -eq $VMName}
        $TestSetting = $vm.$SettingsType.$settingsAttribute
        if ($TestSetting) {$Setting =$TestSetting}
    }

    $Setting


}