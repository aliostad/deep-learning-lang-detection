#Required to load the XAML form and create the PowerShell Variables

#.\loadDialog.ps1 -XamlPath 'CBMForm.xaml'
#.\loadDialog.ps1 -XamlPath 'titleForm.xaml'
.\loadDialog.ps1 -XamlPath 'C:\galibier\forms\mainform.xaml'

#EVENT Handler
<# $bt_CBM.add_Click({ $logo_TITLE.Content = .\other_script\callTask.ps1 })
$bt_VERIFY.add_Click({ $logo_TITLE.Content = "OPTION 2" })
$bt_VIEW.add_Click({ $logo_TITLE.Content = "OPTION 3" }) #>
#$bt_VIEW.add_Click({ $logo_TITLE.Content = "ID is $($ID)" })

#Launch the window
$xamGUI.ShowDialog() | out-null