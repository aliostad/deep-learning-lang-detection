Function Invoke-CleanSolution {
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
        -Target "Clean" `
        -Configuration $Configuration `
        -Verbosity $Verbosity `
        -StartingMessage "Cleaning solution..." `
        -ErrorMessage "Error while cleaning solution '{SolutionFile}'." `
        -SuccessfulMessage "Successfully cleaned solution '{SolutionFile}'."
}