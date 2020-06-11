
$promptOptions = [psobject]@{
    ShowUserName     = $true
    ShowComputerName = $true
    ShowTime         = $true
    TimeFormat       = 'HHmm'
    ShowArchitecture = $true
    ShowGitBranch    = $true
    ShowPath         = $true
    PathOnNewLine    = $true
    ShowAdmin        = $true
    ShortenPath      = $false
}

$promptColors = [psobject]@{
    TextForeground = 'Gray'
    TextBackground = 'Black'
    UserName       = 'Magenta'
    ComputerName   = 'Green'
    ComputerDelim  = 'White'
    Time           = 'White'
    TimeDelim      = 'Green'
    Architecture   = 'Red'
    GitBranch      = 'Yellow'
    GitBranchDelim = 'Yellow'
    Path           = 'Cyan'
    Admin          = 'Red'
    NonAdmin       = 'White'
}

$PsPrompt = [psobject]@{
    Options = $promptOptions
    Colors  = $promptColors
}

Get-Command git.exe -ErrorAction SilentlyContinue
if (!$?)
{
    Set-PromptOption -ShowGitBranch $false
}

### Exports
Export-ModuleMember -Variable PSPrompt
Export-ModuleMember -Function Write-Prompt
Export-ModuleMember -Function Set-PromptOption
Export-ModuleMember -Function Set-PromptColor
Export-ModuleMember -Function Write-PromptSegment
New-Alias -Name prompt -Value Write-Prompt
Export-ModuleMember -Alias prompt
