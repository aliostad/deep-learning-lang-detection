$Path = "C:\deploy_result.txt"
$MyEmail = "abhijajo@cisco.com"
$SMTP = "outbound.cisco.com"
$To = "abhijajo@cisco.com"
$Subject = "Dev-int2 deployment notification"
$Body = (Get-Content C:\deploy_result.txt | out-string)

Start-Sleep 2
# add the required .NET assembly:
Add-Type -AssemblyName System.Windows.Forms

# show the MsgBox:
[System.Windows.Forms.MessageBox]::Show('Deployment is completed')

Send-MailMessage -To $To -From $MyEmail -Subject $Subject -Body $Body -SmtpServer $SMTP  -DeliveryNotificationOption never

