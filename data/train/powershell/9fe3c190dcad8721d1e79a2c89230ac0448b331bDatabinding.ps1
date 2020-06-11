Import-Module .\WPK-Examples\modules\WPK

Function Show-List ($Title="Get Process", $global:list=(Get-Process), $global:memberPath="Name")  {
    New-Window -Title $Title  -WindowStartupLocation CenterScreen -Width 400 -Height 300 -Show -DataContext { $list } {
        New-Grid -Columns 200* -Margin 4 {
            New-GroupBox -Column 0 -Header " List " -Margin 4 {
ise                New-ListBox -Margin 4 -DisplayMemberPath $memberPath -DataBinding @{ ItemsSource = New-Binding }
            }
        }
    }
}

Show-List
Show-List "Get Service" (Get-Service) Name
Show-List "List Directory" (dir C:\PoShScripts\geekSpeak\demo\WPK-Examples *.ps1) FullName