function Show-HelpForCurrentSelection {
    <#
    .Synopsis
        Shows help for the currently selected text
    .Description
        Shows helps for the currently selected text
    .Example
        Show-HelpForCurrentSelection
    #>
    param()
    Select-CurrentText | ForEach-Object {
        if (-not $_) { return }
        Get-Help $_ -ErrorAction SilentlyContinue -Full
    }
}
