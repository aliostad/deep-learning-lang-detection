
# Load posh-git example profile
. 'C:\Users\Steven\Documents\WindowsPowerShell\profile.ps1'
. 'C:\Users\Steven\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {
    if(Test-Path Function:\PrePoshGitPrompt) {
        ++$global:poshScope;
        New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;
        $private:p = PrePoshGitPrompt;

        if(--$global:poshScope -eq 0) {
            Remove-Item function:\Write-Host -Force
        }
    }

    PoshGitPrompt
}

# Load Jump-Location profile
Import-Module 'C:\Users\Steven\Documents\WindowsPowerShell\Modules\Jump.Location\Jump.Location.psd1'
