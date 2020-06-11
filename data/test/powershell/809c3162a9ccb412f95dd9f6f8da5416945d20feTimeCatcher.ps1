[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic");

$host.ui.RawUI.WindowTitle = “TBM-TimeCatcher”;

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

$objNotifyIcon.Icon = "C:\Users\Daniel\Pictures\N.I.R.M\tbm.ico"
#$objNotifyIcon.BalloonTipIcon = "Success" 
$objNotifyIcon.BalloonTipTitle = "SNAPCHAT"
 





while($true){
$time = get-date | select Hour, Minute;


    if($time.Hour -eq $time.Minute){
        $objNotifyIcon.BalloonTipText = "$time" ;
        $objNotifyIcon.Visible = $True ;
        $objNotifyIcon.ShowBalloonTip(1)
        Start-Sleep -Seconds 70;
    
       }

}
