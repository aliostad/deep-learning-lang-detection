function Show-SyntaxForCurrentCommand {
    <#
    .Synopsis
        Shows syntax for the currenly selected function or cmdlet
    .Description
        Attempts to convert the selected text to a command and displays the 
        command syntax if the conversion is successful
    .Example
        Show-SyntaxForCurrentCommand
    #>
    param()
    Select-CurrentTextAsCommand | Get-Command -Syntax
}
