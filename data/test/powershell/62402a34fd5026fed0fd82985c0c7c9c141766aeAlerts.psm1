#
# Description:                 This function shows a windows alert on the bottom right
# 
function WindowsAlert()
{
    try
    {
        # Loading the Windows forms assembly
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
        # Creatting new NotifyIcon object
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon;
        # Setting NotifyIcon
        $objNotifyIcon.Icon = "C:\Users\jtoledo\Pictures\icons\PortableComputer.ico"
        $objNotifyIcon.BalloonTipIcon = "Warning" 
        $objNotifyIcon.BalloonTipText = "Based on the Coffee maigos calendar, today is your turn to make coffee for all the members." 
        $objNotifyIcon.BalloonTipTitle = "Coffee time!!" 
        $objNotifyIcon.Visible = $True 
        $objNotifyIcon.ShowBalloonTip(30000)
        $objNotifyIcon.Visible = $false;
    }
    catch
    {
        Write-Host -ForegroundColor Red $_;
    }
}

#
# Description:                 This function shows a Popup alert
#
function PopupAlert()
{
    try
    {
        # Load the Assembly.
        $load = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
        # Show Popup
        $result = [Windows.Forms.MessageBox]::Show("Based on the Coffee maigos calendar, today is your turn to make coffee for all the members.", “Coffee Time!!”, [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Warning)
    }
    catch
    {
        Write-Host -ForegroundColor Red $_;
    }
}


Export-ModuleMember -Function "WindowsAlert";
Export-ModuleMember -Function "PopupAlert";