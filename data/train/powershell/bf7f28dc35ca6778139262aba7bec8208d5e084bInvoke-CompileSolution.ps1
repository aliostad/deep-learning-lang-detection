Function Invoke-CompileSolution {    
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionDirectory = $(Get-SolutionDirectory),

        [ValidateNotNullOrEmpty()]
        [string]
        $Configuration = "Release",

        [ValidateNotNullOrEmpty()]
        [string]
        $Verbosity = "minimal"
    )
    Invoke-MSBuild `
        -SolutionDirectory $SolutionDirectory `
        -Target "ReBuild" `
        -Configuration $Configuration `
        -Verbosity $Verbosity `
        -StartingMessage "Compiling solution..." `
        -ErrorMessage "Error while compiling solution '{SolutionFile}'." `
        -SuccessfulMessage "Successfully compiled solution '{SolutionFile}'." `
}
