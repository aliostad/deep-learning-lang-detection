[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your name", "Name", "$env:username")
"Your name is $name"

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$result = [Microsoft.VisualBasic.Interaction]::MsgBox( `
  "Do you agree?", 'YesNoCancel,Question', "Respond please")

switch ($result) {
  'Yes'		{ "Ah good" }
  'No'		{ "Sorry to hear that" }
  'Cancel'	{ "Bye..." }
}

# Use popup() from Wscript.shell class to show messagebox/popup with timeout