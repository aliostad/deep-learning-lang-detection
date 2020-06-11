function Show-Member {
    <#
    .Synopsis
        Displays a searchable gridview contaning the members of an object
    .Description
        Displays a searchable gridview containing the members of an object.
        The object can either a variable, cmdlet, or a type with no 
        constructors.
    .Example
        Show-Member
    #>
    param()
    Select-CurrentTextAsType | 
        ForEach-Object {
            if ($_) {
                & ([ScriptBlock]::Create("
                try {
                    New-Object $($_.Fullname) | Get-Member | Out-GridView
                }
                catch {}        
                "))
            }
        }
    Select-CurrentTextAsVariable | 
        ForEach-Object {
            if ($_) {
                & ([ScriptBlock]::Create("`$$($_.Name) | 
                    Get-Member | Out-GridView"))
            }
        }
    Select-CurrentTextAsCommand |
        ForEach-Object {
            if ($_) { 
                & ([ScriptBlock]::Create("$_ | Get-Member | Out-GridView")) 
            }
        }
}