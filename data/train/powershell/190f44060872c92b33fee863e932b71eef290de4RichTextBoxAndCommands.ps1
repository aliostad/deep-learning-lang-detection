New-DockPanel -Width 400 {
    New-Menu -Dock Top {
        New-MenuItem "_File" {
            New-MenuItem -Name Foo -Command Open -CommandBindings {
                New-CommandBinding -Command { Get-ApplicationCommand -Open } -On_Executed {
                    $rtb = Get-Resource "RichTextBox"        
                    $ofd = New-OpenFileDialog
                    if ($ofd.ShowDialog()) {
                        $text = [IO.File]::ReadAllText($ofd.FileName).Split([Environment]::NewLine, 
                            [StringSplitOptions]"RemoveEmptyEntries")
                        $rtb.Document.Blocks.Clear()
                        $rtb.Document.Blocks.Add((
                            New-Paragraph {
                                foreach ($t in $text) {
                                    New-Span $t
                                    New-LineBreak
                                }
                            }))
                    }
                }
            }
        }

        New-MenuItem "_Edit" {
            New-MenuItem -Command Undo
            New-MenuItem -Command Redo
            
            New-Separator

            New-MenuItem -Command Cut
            New-MenuItem -Command Copy
            New-MenuItem -Command Paste
            
            New-Separator 
            
            New-MenuItem -Command SelectAll
        }

    }
    New-RichTextBox -Dock Top -On_Loaded {
        Set-Resource "RichTextBox" $this -1
        $this.SpellCheck.IsEnabled=  $true
    }
} -Show
