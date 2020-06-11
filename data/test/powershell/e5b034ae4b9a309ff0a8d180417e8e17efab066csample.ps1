#
# This file uses the Show-GUIXaml module to display the sample.xaml window on the screen.
#

# Import the module
Import-Module .\Show-GUIXaml.psm1

# Create the window from a XAML file
$win1 = Show-GUIXaml -Path .\sample.xaml

# Add event handling
$button1.add_Click({$textbox1.Text += "Hello World!`n"})

# Assign a value to a control
$label1.Text = "This sample shows what is possible with PowerShell and XAML. Press the button to load some content in the text box.`n`nInfinite possibilities abound!"

#Launch the window
$win1.ShowDialog() | out-null
