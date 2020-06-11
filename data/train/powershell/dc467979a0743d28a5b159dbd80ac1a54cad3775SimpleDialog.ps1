Import-Module .\WPK-Examples\modules\WPK
New-Grid -Rows 4 {
    New-Label "Please Enter Your Name" -Margin 4
    New-TextBox -Name YourName -Row 1 -Margin 4 -On_PreviewKeyDown {
        if ($_.Key -eq "Enter") {
            $_.Handled = $true
            Invoke-ControlEvent -parent $window -control "Done" -event "Click"
        }
    }

    New-StackPanel -Row 2 {
        New-RadioButton -Content "Male" -IsChecked $true -GroupName Sex -Margin 4
        New-RadioButton -Content "Female" -Column 1 -GroupName Sex -Margin 4
    }

    New-Button -Name Done "Done" -Row 3 -Margin 4 -On_Click {
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
            return
        }

        $this.Parent.Tag = New-Object PSObject -Property @{
            Name = $yourName.Text
            Sex  = $sex
        }

        $window.Close()
    }
} -show