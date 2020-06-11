function Show-TypeConstructorForCurrentType {
    <#
    .Synopsis
        Shows type constructors for the currently selected type
    .Description
        Attempts to convert the selected text to a type and dislay the constructors
    .Example
        Show-TypeConstructorForCurrentType
    #>
    param()
    Select-CurrentTextAsType| Show-TypeConstructor 
}
