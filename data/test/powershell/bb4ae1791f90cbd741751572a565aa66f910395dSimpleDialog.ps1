New-Grid -Rows 4 {    
    New-Label "Please Enter Your Name" 
    New-TextBox -Name YourName -Row 1 -On_PreviewKeyDown {        
        if ($_.Key -eq "Enter") {
            $_.Handled = $true
            Invoke-ControlEvent -parent $window -control "Done" -event "Click"
        }
    }
    New-StackPanel -Row 2 {
        New-RadioButton -Content "Male" -IsChecked $true -GroupName Sex
        New-RadioButton -Content "Female" -Column 1 -GroupName Sex
    }
    New-Button -Name Done "Done" -Row 3 -On_Click { 
        $yourName = $window | Get-ChildControl YourName 
        $sex = $window | 
            Get-ChildControl | 
            Where-Object {
               $_.GroupName -eq "Sex" -and $_.IsChecked                            
            } | 
            Foreach-Object {
                $_.Content
            }
        if (-not $yourName.Text) {
            [Windows.Messagebox]::show("Who are you?")
        }
        $this.Parent.Tag = New-Object PSObject |
            Add-Member NoteProperty Name $yourName.Text -PassThru |
            Add-Member NoteProperty Sex $sex -PassThru        
        $window.Close()
    }
} -show
#a