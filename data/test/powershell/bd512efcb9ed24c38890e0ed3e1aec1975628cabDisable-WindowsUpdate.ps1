function Disable-WindowsUpdate
{
    <#
    .Synopsis
        Disables automatic updates
    .Description
        Disables automatic updates on the current machine
    .Link
        Enable-WindowsUpdate
    #>
    
    $AUSettigns = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
    $AUSettigns.NotificationLevel = 1
    $AUSettigns.Save()    
} 
