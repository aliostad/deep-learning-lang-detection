#
# Using ShowUI
#
#

Import-Module ShowUI
. .\Select-ViaAST.ps1

New-Window -Show -WindowStartupLocation CenterScreen -FontSize 20 -On_Loaded `
    { $Results.ItemsSource = Select-ViaAST -Fullname .\test.ps1 } `
    {
        New-ListView -Name Results -View  {
            New-GridView {            
                New-GridViewColumn LineNumber -DisplayMemberBinding StartLineNumber
                New-GridViewColumn Type
                New-GridViewColumn Name
                New-GridViewColumn FileName
            }
    }
}