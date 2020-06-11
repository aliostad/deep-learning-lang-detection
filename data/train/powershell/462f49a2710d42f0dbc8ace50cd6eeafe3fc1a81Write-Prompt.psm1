#requires -Version 2
Set-StrictMode -Version Latest

##################################################
## Prompt Function File
##################################################


##################################################
## Functions
##################################################

Function Write-PromptUserComputer()
{
    if ($PsPrompt.Options.ShowUserName)
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.UserName `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
    }

    if ($PsPrompt.Options.ShowUserName -and $PsPrompt.Options.ShowComputerName)
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.ComputerDelim `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object '@'
    }

    if ($PsPrompt.Options.ShowComputerName)
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.ComputerName `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object ([net.dns]::GetHostName())
    }
}

Function Write-PromptTime
{
    if ($PsPrompt.Options.ShowTime)
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.TimeDelim `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object '['

        Write-Host -ForegroundColor $PsPrompt.Colors.Time `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object (Get-Date -Format $PsPrompt.Options.TimeFormat)

        Write-Host -ForegroundColor $PsPrompt.Colors.TimeDelim `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object ']'
    }
}

function Write-ConsoleTitle 
{
    $dir = (Split-Path -Leaf -Path $PWD)
    $title = "PS> $dir"
    $Host.UI.RawUI.WindowTitle = $title
} 

Function Write-PromptArchitecture
{
    if ($PsPrompt.Options.ShowArchitecture)
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.Architecture `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object $env:PROCESSOR_ARCHITECTURE
    }
}

Function Write-PromptGitBranch
{
    if ($PsPrompt.Options.ShowGitBranch)
    {
        try
        {
            $branches = git.exe branch --no-color
            if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($branches))
            {
                $re = [regex] '(?m)\*\s+([\S()]+)'
                $match = $re.Match($branches)
                if ($match.Success)
                {
                    Write-Host -ForegroundColor $PsPrompt.Colors.GitBranchDelim `
                    -BackgroundColor $PsPrompt.Colors.TextBackground `
                    -NoNewline `
                    -Object '|'
                
                    Write-Host -ForegroundColor $PsPrompt.Colors.GitBranch `
                    -BackgroundColor $PsPrompt.Colors.TextBackground `
                    -NoNewline `
                    -Object $match.Groups[1]

                    Write-Host -ForegroundColor $PsPrompt.Colors.GitBranchDelim `
                    -BackgroundColor $PsPrompt.Colors.TextBackground `
                    -NoNewline `
                    -Object '|'
                }
            }
        }
        catch {}
    }
}

Function Write-PromptPath
{
    if ($PsPrompt.Options.ShowPath)
    {
        if ($PsPrompt.Options.PathOnNewLine)
        {
            Write-Host  -Object ''
        }

        Write-Host -ForegroundColor $PsPrompt.Colors.Path `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object (Shorten-Path (Get-Location))
    }
}

Function Write-PromptSymbol
{
    if ($PsPrompt.Options.ShowAdmin)
    {
        $isAdmin = (New-Object  -TypeName System.Security.Principal.WindowsPrincipal -ArgumentList ([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole('Administrators')

        if ($isAdmin)
        {
            Write-Host -ForegroundColor $PsPrompt.Colors.Admin `
            -BackgroundColor $PsPrompt.Colors.TextBackground `
            -NoNewline `
            -Object '#'
        }
        else
        {
            Write-Host -ForegroundColor $PsPrompt.Colors.NonAdmin `
            -BackgroundColor $PsPrompt.Colors.TextBackground `
            -NoNewline `
            -Object "$"
        }
    }
    else
    {
        Write-Host -ForegroundColor $PsPrompt.Colors.TextForeground `
        -BackgroundColor $PsPrompt.Colors.TextBackground `
        -NoNewline `
        -Object '>'
    }
}

Function Write-Prompt
{
    Write-PromptUserComputer
    if ($PsPrompt.Options.ShowUserName -and $PsPrompt.Options.ShowComputerName) 
    {
        Write-Host -NoNewline  -Object ' '
    }
    
    Write-PromptTime
    if ($PsPrompt.Options.ShowTime) 
    {
        Write-Host -NoNewline  -Object ' '
    }
    
    Write-PromptArchitecture
    if ($PsPrompt.Options.ShowArchitecture) 
    {
        Write-Host -NoNewline  -Object ' '
    }
    
    Write-PromptGitBranch
    if ($PsPrompt.Options.ShowGitBranch) 
    {
        Write-Host -NoNewline  -Object ' '
    }
    
    Write-PromptPath
    if ($PsPrompt.Options.ShowPath) 
    {
        Write-Host -NoNewline  -Object ' '
    }

    Write-PromptSymbol
    Write-ConsoleTitle
    return ' '
}

Function Shorten-Path
{
    param([string] $path)
    if ($PsPrompt.Options.ShortenPath)
    {
        if ($path.Length -gt 20)
        {
            $left = $path.Substring(0,5)
            $right = $path.Substring($path.Length - 16)
            return $left + '…' + $right            
        }
    }
    return $path;
}

