[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")

# form stuff
$form1 = New-Object System.Windows.Forms.Form
$form1.ClientSize = New-Object System.Drawing.Size(292,266)

# getting it in-scope
$x = 200
for($i=1; $i -le 5; $i++){
   $rb = New-Object System.Windows.Forms.RadioButton
   $x = 10 + (($i-1) * 25)
   $rb.Location = New-Object System.Drawing.Point(15,$x)
   $rb.Text = "button $i"
   $rb.Name = "button $i"
   $rb.Size = New-Object System.Drawing.Size(104,24)
   $form1.Controls.Add($rb)
}
$x = $x + 35

# ok button stuff
$rad = $false
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(15,$x)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({
    $form1.Controls |
      ForEach-Object {
        if ($_.Checked -eq $true) { $rad = $_.Name }
    }
    if ($rad) {
        $form1.Close()
    } else {
        [System.Windows.Forms.MessageBox]::Show("You must make a selection.")
    }
})
$form1.Controls.Add($OKButton)

$form1.ShowDialog()

Write-Output $rad