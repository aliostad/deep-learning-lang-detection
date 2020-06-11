Function Load-Form 
{
    $Form.Controls.Add($LBMessage)
    $Form.Controls.Add($ButtonOK)
    $Form.Add_Shown({$Form.Activate()})
    $Form.Add_Load({Get-BatteryStatus})
    [void] $Form.ShowDialog()
}
 
Function Get-BatteryStatus
{
    $ErrorProvider.Clear()

    $Battery = Get-CimInstance -ClassName Win32_Battery

    if ($Battery.BatteryStatus -ne 2 -or $Battery.EstimatedChargeRemaining -le 90)
    {
        $ErrorProvider.SetError($LBMessage, "Please provide the computer with AC Power.")
    }

    else 
    {
        $Form.Close()
    }
}
 
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 
$Global:ErrorProvider = New-Object System.Windows.Forms.ErrorProvider
 
$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(285,140)  
$Form.MinimumSize = New-Object System.Drawing.Size(300,140)
$Form.MaximumSize = New-Object System.Drawing.Size(300,140)
$Form.StartPosition = "CenterScreen"
$Form.SizeGripStyle = "Hide"
$Form.Text = "Provide AC Power"
$Form.ControlBox = $false
$Form.TopMost = $true
 
$LBMessage = New-Object System.Windows.Forms.Label
$LBMessage.Location = New-Object System.Drawing.Size(10,30)
$LBMessage.Size = New-Object System.Drawing.Size(230,20)
$LBMessage.TabIndex = "1"
$LBMessage.Text = "Please provide the computer with AC Power."
 
$ButtonOK = New-Object System.Windows.Forms.Button
$ButtonOK.Location = New-Object System.Drawing.Size(200,65)
$ButtonOK.Size = New-Object System.Drawing.Size(70,25)
$ButtonOK.Text = "OK"
$ButtonOK.TabIndex = "2"
$ButtonOK.Add_Click({Get-BatteryStatus})

$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){Get-BatteryStatus}})

Load-Form