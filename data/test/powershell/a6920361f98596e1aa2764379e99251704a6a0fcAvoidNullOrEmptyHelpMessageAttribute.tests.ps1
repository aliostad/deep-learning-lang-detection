Import-Module PSScriptAnalyzer
$violationName = "PSAvoidNullOrEmptyHelpMessageAttribute"
$violationMessage = "HelpMessage parameter attribute should not be null or empty. To fix a violation of this rule, please set its value to a non-empty string."
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
$violations = Invoke-ScriptAnalyzer "$directory\AvoidNullOrEmptyHelpMessageAttribute.ps1" -IncludeRule PSAvoidNullOrEmptyHelpMessageAttribute
$noViolations = Invoke-ScriptAnalyzer "$directory\AvoidNullOrEmptyHelpMessageAttributeNoViolations.ps1" -IncludeRule PSAvoidNullOrEmptyHelpMessageAttribute

Describe "AvoidNullOrEmptyHelpMessageAttribute" {
    Context "When there are violations" {
        It "detects the violations" {
            $violations.Count | Should Be 6
        }

        It "has the correct description message" {
            $violations[0].Message | Should Match $violationMessage
        }
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}