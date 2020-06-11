#requires -version 2.0

[CmdletBinding()]
param
(
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
function PSScriptRoot { $MyInvocation.ScriptName | Split-Path }
Trap { throw $_ }

if ((Get-Module PoshUnit) -eq $null)
{
    $poshUnitFolder = if (Test-Path "$(PSScriptRoot)\..\PoshUnit.Dev.txt") { ".." } else { "..\packages\PoshUnit" }
    $poshUnitModuleFile = Resolve-Path "$(PSScriptRoot)\$poshUnitFolder\PoshUnit.psm1"

    if (-not (Test-Path $poshUnitModuleFile))
    {
        throw "$poshUnitModuleFile not found"
    }

    Import-Module $poshUnitModuleFile
}

. "$(PSScriptRoot)\TestHelpers.ps1"

Test-Fixture "commit-msg hook tests" `
    -SetUp `
    {
        $tempPath = Get-TempTestPath

        $localRepoPath = Prepare-LocalGitRepo $tempPath
        Push-Location $localRepoPath

        . "Tools\GitHooks\Common.ps1"

        tools\GitHooks\Install-GitHooks.ps1 commit-msg
    } `
    -TearDown `
    {
        Pop-Location
        Remove-Item -Path $tempPath -Recurse -Force
    } `
    -Tests `
    (
        Test "When commit message starts with TFSxxxx it is used as is" `
        {
            git commit --allow-empty -m "TFS1357 Some message"
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("TFS1357 Some message"))
        }
    ),
    (
        Test "When commit message starts with ADH, ADH is trimmed out" `
        {
            git commit --allow-empty -m "ADH Some other message"
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("Some other message"))
        }
    ),
    (
        Test "When branch name starts with TFSxxxx, the branch name is added as a prefix to all commit messages" `
        {
            git checkout -b TFS1357 --quiet
            git commit --allow-empty -m "Some message"
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("TFS1357 Some message"))
        }
    ),
    (
        Test "When branch name starts with TFSxxxx fixup commit messages used as is" `
        {
            git checkout -b TFS1357 --quiet
            git commit --allow-empty -m "Some message"
            git commit --allow-empty --fixup=HEAD
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("fixup! TFS1357 Some message"))
        }
    ),
    (
        Test "When branch name starts with TFSxxxx squash commit messages used as is" `
        {
            git checkout -b TFS1357 --quiet
            git commit --allow-empty -m "Some message"
            git commit --allow-empty --squash=HEAD --reuse-message=HEAD
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("squash! TFS1357 Some message"))
        }
    ),
    (
        Test "When commit message starts with TFSxxxx with fake ID comit is cancelled" `
        {
            git commit --allow-empty -m "TFS1234 Some message"

            $commitExitCode = $LASTEXITCODE

            $Assert::That($commitExitCode, $Is::EqualTo(1))
        }
    ),
    (
        Test "Fixup commit messages are preserved" `
        {
            git commit --allow-empty -m "TFS1357 Some message"
            git commit --allow-empty --fixup=HEAD
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("fixup! TFS1357 Some message"))
        }
    ),
    (
        Test "Squash commit messages are preserved" `
        {
            git commit --allow-empty -m "TFS1357 Some message"
            git commit --allow-empty --squash=HEAD --reuse-message=HEAD
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("squash! TFS1357 Some message"))
        }
    ),
    (
        Test "When commit has a format similar enough to TFSxxxx it is changed to follow the pattern" `
        {
            git commit --allow-empty -m "TFS--1357    Some message"
            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("TFS1357 Some message"))
        }
    )

Test-Fixture "commit-msg hook UI dialog tests" `
    -SetUp `
    {
        $tempPath = Get-TempTestPath

        $localRepoPath = Prepare-LocalGitRepo $tempPath
        Push-Location $localRepoPath

        . "Tools\GitHooks\Common.ps1"

        tools\GitHooks\Install-GitHooks.ps1 commit-msg

        $hooksConfiguration = Get-HooksConfiguration
        $hooksConfiguration.CommitMessages.showDialogFromConsole = "true"

        Set-HooksConfiguration $hooksConfiguration

        $externalProcess = Start-PowerShell { git commit --allow-empty -m "Some message" }

        Init-UIAutomation

        $dialog = Get-UIAWindow -Name "Provide TFS WorkItem ID"
    } `
    -TearDown `
    {
        Pop-Location

        Stop-ProcessTree $externalProcess

        Remove-Item -Path $tempPath -Recurse -Force
    } `
    -Tests `
    (
        Test "When commit message does not start with TFSxxxx the dialog is shown" `
        {
            $Assert::That($dialog, $Is::Not.Null)
        }
    ),
    (
        Test "When Cancel button in the dialog is clicked commit is cancelled" `
        {
            $lastCommitMessage = Get-CommitMessage

            $dialog | `
                Get-UIAButton -Name Cancel | `
                Invoke-UIAButtonClick

            Wait-ProcessExit $externalProcess

            $currentCommitMessage = Get-CommitMessage

            $Assert::That($currentCommitMessage, $Is::EqualTo($lastCommitMessage))
        }
    ),
    (
        Test "When TFS WorkItem ID is entered it is used as a prefix for commit message" `
        {
            $dialog | `
                Get-UIAEdit -AutomationId workItemIdTextBox | `
                Set-UIAEditText -Text 1357

            $dialog | `
                Get-UIAButton -Name OK | `
                Invoke-UIAButtonClick

            Wait-ProcessExit $externalProcess

            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("TFS1357 Some message"))
        }
    ),
    (
        Test "When Ad-hoc checkbox is selected commit message is used as is" `
        {
            $dialog | `
                Get-UIACheckBox -Name "Ad-hoc change" | `
                Invoke-UIACheckBoxToggle

            $dialog | `
                Get-UIAButton -Name OK | `
                Invoke-UIAButtonClick

            Wait-ProcessExit $externalProcess

            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("Some message"))
        }
    ),
    (
        Test "When dialog is shown workItemIdTextBox is focused" `
        {
            $focusedElement = $dialog | `
                Get-UIAFocus

            $Assert::That($focusedElement.Current.AutomationId, $Is::EqualTo("workItemIdTextBox"))
        }
    ),
    (
        Test "When fake TFS WorkItem ID is entered commit is cancelled" `
        {
            $lastCommitMessage = Get-CommitMessage

            $dialog | `
                Get-UIAEdit -AutomationId workItemIdTextBox | `
                Set-UIAEditText -Text 1234

            $dialog | `
                Get-UIAButton -Name OK | `
                Invoke-UIAButtonClick

            Wait-ProcessExit $externalProcess

            $currentCommitMessage = Get-CommitMessage

            $Assert::That($currentCommitMessage, $Is::EqualTo($lastCommitMessage))
        }
    )

Test-Fixture "commit-msg hook interactive tests" `
    -SetUp `
    {
        $tempPath = Get-TempTestPath

        $localRepoPath = Prepare-LocalGitRepo $tempPath
        Push-Location $localRepoPath

        . "Tools\GitHooks\Common.ps1"

        tools\GitHooks\Install-GitHooks.ps1 commit-msg

        $hooksConfiguration = Get-HooksConfiguration
        $hooksConfiguration.CommitMessages.showDialogFromConsole = "false"

        Set-HooksConfiguration $hooksConfiguration

        $externalProcess = Start-PowerShell { git commit --allow-empty -m "Some message" }

        Init-UIAutomation

        $powerShellUI = $externalProcess | Get-UIAWindow
    } `
    -TearDown `
    {
        Pop-Location

        Stop-ProcessTree $externalProcess

        Remove-Item -Path $tempPath -Recurse -Force
    } `
    -Tests `
    (
        Test "When TFS WorkItem ID is entered it is used as a prefix for commit message" `
        {
            $powerShellUI | `
                Set-UIAFocus | `
                Set-UIAControlKeys -Text "1357`r"

            Wait-ProcessExit $externalProcess

            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("TFS1357 Some message"))

        }
    ),
    (
        Test "When ADH is entered commit message is used as is" `
        {
            $powerShellUI | `
                Set-UIAFocus | `
                Set-UIAControlKeys -Text "ADH`r"

            Wait-ProcessExit $externalProcess

            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo("Some message"))

        }
    ),
    (
        Test "When something wrong is entered commit is cancelled" `
        {
            $lastCommitMessage = Get-CommitMessage

            $powerShellUI | `
                Set-UIAFocus | `
                Set-UIAControlKeys -Text "Wrong`r"

            Wait-ProcessExit $externalProcess

            $commitMessage = Get-CommitMessage

            $Assert::That($commitMessage, $Is::EqualTo($lastCommitMessage))

        }
    ),
    (
        Test "When fake TFS WorkItem ID is entered commit is cancelled" `
        {
            $lastCommitMessage = Get-CommitMessage

            $powerShellUI | `
                Set-UIAFocus | `
                Set-UIAControlKeys -Text "1234`r"

            Wait-ProcessExit $externalProcess

            $currentCommitMessage = Get-CommitMessage

            $Assert::That($currentCommitMessage, $Is::EqualTo($lastCommitMessage))
        }
    )
