### Start main program

###Load Windows Form Assemblies
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles();

$msg = [System.Windows.Forms.MessageBox]	# Standard message box form

### Set up basic form
$title = "NetSh GUI"
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = $title
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "Fixed3D"
$mainForm.TopMost = $false

$mainForm.Add_Shown({$mainForm.Activate()})
$mainForm.ShowDialog() #Show Generated Form
$mainForm.BringToFront()	#Bring form to front
