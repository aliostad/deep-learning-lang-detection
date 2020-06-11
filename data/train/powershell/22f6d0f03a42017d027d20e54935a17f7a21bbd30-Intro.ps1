$size = "800,800"
$font = "Consolas, 36pt"

function GenerateForm {
[void][reflection.assembly]::loadwithpartialname("System.Windows.Forms") 

$form1 = New-Object System.Windows.Forms.Form
$form1.Text = "Primal Form"
$form1.StartPosition = 4
$form1.ClientSize = $size

$label = New-Object System.Windows.Forms.Label
$label.Text = @"
Tim Rayburn
tim@timrayburn.net
http://TimRayburn.net
817-760-0002

Resumes Always Welcome
Now, on with the show
"@
$label.Font = $font
$label.Size = $size
$form1.Controls.Add($label)

$form1.ShowDialog()
} 

GenerateForm