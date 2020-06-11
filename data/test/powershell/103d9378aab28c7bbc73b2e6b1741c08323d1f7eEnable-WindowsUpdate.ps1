function Enable-WindowsUpdate
{
    <#
    .Synopsis
        Enables automatic updates    
    .Description
        Enables automatic updates on the current machine
    .Link
        Disable-WindowsUpdate
    #>
    
    $AUSettigns = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
    $AUSettigns.NotificationLevel = 4
    $AUSettigns.Save()    
} 
