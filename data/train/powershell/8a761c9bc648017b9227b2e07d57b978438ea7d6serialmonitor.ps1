# COMポートを読む
$form = new-object Windows.Forms.Form
$form.text = "comポートの選択"

$form.KeyPreview = $True
$form.Add_KeyDown({
    if ($_.KeyCode -eq "Enter"){
        $comport=$textBox.Text
        $form.Close()
    }
})

$form.Add_KeyDown({
    if ($_.KeyCode -eq "Escape"){
        $form.Close()
    }
})

$textBox = New-Object System.Windows.Forms.TextBox


$form.Controls.Add($textBox) 

$form.Add_Shown($form.Activate())
$form.ShowDialog()

$port = New-Object System.IO.Ports.SerialPort "COM$comport", 9600, None, 8, one
$port.Open()
while(1){echo $port.ReadLine()}