function Show-TypeConstructor {
    <#
    .Synopsis
        Shows the constructors for a given type
    .Description
        Calls the toString method on each constructor on a given type, 
        which gives a (moderately) human readable output of how to create
        the type
    .Example
        [string], [int] | Show-TypeConstructor
    #>
    param(
    # The type to show constructors from
    [Parameter(ValueFromPipeline=$true)]
    [Type]$type
    )
    process {
        if (-not $type) { return } 
        $type.GetConstructors() | 
            ForEach-Object { "$_" }
    }
}