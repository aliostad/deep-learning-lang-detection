#requires -version 2.0

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [string] $CommitMessagePath
)

$script:ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
function PSScriptRoot { $MyInvocation.ScriptName | Split-Path }

Trap { throw $_ }

function Main
{
    . "$(PSScriptRoot)\Common.ps1"

    if (-not ([Convert]::ToBoolean((Get-HooksConfiguration).CommitMessages.enforceTfsPrefix)))
    {
        Write-Debug "CommitMessages/@enforceTfsPrefix is disabled in HooksConfiguration.xml"
        ExitWithSuccess
    }

    Write-Debug "Running commit hook"
    $workingCopyRoot = Join-Path $(PSScriptRoot) "..\.."
    Write-Debug "WorkingCopyRoot is $workingCopyRoot"

    $mergeHeadFile = Join-Path $workingCopyRoot ".git\MERGE_HEAD"
    $workItemPattern = "^TFS(?<id>\d+)"
    $qcPattern = "^QC(?<id>\d+)"
    $adhocPattern = "^ADH\s+"
    $fixupSquashPattern = "^(fixup)|(squash)[!]\s+"
    $revertPattern = "This reverts commit [0-9a-fA-F]{40}"
    $badFormatPattern = "^(?s:TFS[^\w\d]*(?<id>\d+)\s*(?<text>.*))"
    $buildFixPattern = "^BUILDFIX\s+"
    
    $commitMessage = Get-Content $CommitMessagePath | Out-String

    if ($commitMessage -match $buildFixPattern)
    {
        Write-Debug "Commit was a BUILDFIX"
        ExitWithSuccess
    }

    # Allow fixup/squash commits
    if ($commitMessage -match $fixupSquashPattern)
    {
        Write-Debug "Commit was a fixup/squash"
        ExitWithSuccess
    }

    # Allow merge commits
    if (Test-Path $mergeHeadFile)
    {
        Write-Debug "Commit was a merge"
        ExitWithSuccess
    }

    # Allow revert commits
    if ($commitMessage -match $revertPattern)
    {
        Write-Debug "Commit was a revert"
        ExitWithSuccess
    }

    # Allow Adhoc commits
    if ($commitMessage -match $adhocPattern)
    {
        Write-Debug "Commit was an ad-hoc"
        # Strip out the "ADH"
        Update-CommitMessage ($commitMessage -replace $adhocPattern)
        ExitWithSuccess
    }

    # Clean up similar, but wrong, formats
    if ($commitMessage -match $badFormatPattern)
    {
        $commitMessage = "TFS$($matches["id"]) $($matches["text"])"
        Update-CommitMessage $CommitMessage
        Write-Debug "Re-wrote message to: [$CommitMessage]"
    }

    # Allow commits that contain a work item ID in the message
    if (($commitMessage -match $workItemPattern) -or ($commitMessage -match $qcPattern))
    {
        Write-Debug "ID in message"
        Validate-WorkItemId $matches["id"]
        ExitWithSuccess
    }
    # Also allow commits that contain a work item ID in the branch name
    elseif ((Get-CurrentBranchName) -match $workItemPattern)
    {
        Write-Debug "ID in branch"
        $WorkItem = $matches[0];

        # Include the work item ID in the commit message
        Update-CommitMessage "$WorkItem $commitMessage"
        ExitWithSuccess
    }

    if (-not (Test-RunningFromConsole))
    {
        $result = Show-Dialog
    }
    else
    {
        $result = New-Object PSObject -Property `
        @{
            Cancel = $false;
            AdHoc = $false;
            WorkItemId = 0
        }

        $rawInput = Read-Host 'Enter TFS WorkItem ID (or ADH if ad-hoc)'
        $result.AdHoc = $rawInput -eq 'ADH'
        if (-not $result.AdHoc)
        {
            $result.Cancel = $rawInput -notmatch '\d+'
            $result.WorkItemId = $rawInput
        }
    }

    if ($result.Cancel)
    {
        Write-HooksWarning "Commit message missing TFS WorkItem ID.`nSee wiki-url/index.php?title=Git#Commit_messages"
        ExitWithFailure
    }
    elseif ($result.AdHoc)
    {
        Write-Debug "Commit was an ad-hoc"
        ExitWithSuccess
    }
    else
    {
        Validate-WorkItemId $result.WorkItemId
        Write-Debug "Adding TFS WorkItem ID $($result.WorkItemId)"
        Update-CommitMessage "TFS$($result.WorkItemId) $commitMessage"
        ExitWithSuccess
    }
}

function Show-Dialog
{
    Add-Type -AssemblyName PresentationFramework

    $xaml = [xml] @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Provide TFS WorkItem ID" Height="140" Width="480" FocusManager.FocusedElement="{Binding ElementName=workItemIdTextBox}">
    <Grid>
        <TextBlock HorizontalAlignment="Left" Margin="10,10,0,0" TextWrapping="Wrap"
                   Text="You should provide TFS WorkItem ID for your commit or mark it as an ad-hoc change" VerticalAlignment="Top" />
        <Label Content="TFS WorkItem ID" HorizontalAlignment="Left" Margin="10,30,0,0" VerticalAlignment="Top" />
        <TextBox x:Name="workItemIdTextBox" HorizontalAlignment="Left" Margin="110,35,0,0" Text=""
                 VerticalAlignment="Top" Width="120" />
        <CheckBox x:Name="adHocCheckBox" Content="Ad-hoc change" HorizontalAlignment="Left" Margin="250,35,0,0" VerticalAlignment="Top" />
        <Button x:Name="okButton" Content="OK" HorizontalAlignment="Left" Margin="285,65,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False" IsDefault="True" />
        <Button x:Name="cancelButton" Content="Cancel" HorizontalAlignment="Left" Margin="375,65,0,0" VerticalAlignment="Top" Width="75" IsCancel="True" />
    </Grid>
</Window>
"@

    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $form = [Windows.Markup.XamlReader]::Load($reader)

    $okButton = $form.FindName("okButton")
    $cancelButton = $form.FindName("cancelButton")
    $adhocCheckBox = $form.FindName("adHocCheckBox")
    $workItemIdTextBox = $form.FindName("workItemIdTextBox")

    $result = New-Object PSObject -Property `
    @{
        Cancel = $false;
        AdHoc = $false;
        WorkItemId = 0
    }

    $okButton.add_Click(
        {
            $form.Close()
            $result.AdHoc = $adhocCheckBox.IsChecked;
            $result.WorkItemId = $workItemIdTextBox.Text;
        })

    $cancelButton.add_Click(
        {
            $form.Close()
            $result.Cancel = $true
        })

    $adhocCheckBox.add_Checked(
        {
            $workItemIdTextBox.IsEnabled = $false
            $okButton.IsEnabled = $true
        })

    $adhocCheckBox.add_Unchecked(
        {
            $workItemIdTextBox.IsEnabled = $true
            if ($workItemIdTextBox.Text -eq "")
            {
                $okButton.IsEnabled = $false
            }
        })

    $workItemIdTextBox.add_PreviewTextInput(
        {
            param
            (
                $Sender,
                $e
            )

            [UInt32] $value = 0
            if (!([UInt32]::TryParse($e.Text, [ref] $value)))
            {
                $e.Handled = $true
            }
        })

    $workItemIdTextBox.add_TextChanged({
        $okButton.IsEnabled = $workItemIdTextBox.Text -ne ""
    })

    $form.WindowStartupLocation = "CenterScreen"
    [void] $form.ShowDialog();

    $result
}

function Update-CommitMessage
{
    param
    (
        [string] $commitMessage
    )

    $commitMessage | Out-File $CommitMessagePath -Encoding Ascii
}

function Validate-WorkItemId
{
    param
    (
        [int] $WorkItemId
    )
    
    $fakeWorkItems = [int[]] (Get-HooksConfiguration).CommitMessages.FakeWorkItems.FakeWorkItem
    if ($fakeWorkItems -contains $WorkItemId)
    {
        Write-HooksWarning "TFS WorkItem ID $WorkItemId is a fake. Please use a real one.`nSee wiki-url/index.php?title=Git#Commit_messages"
        ExitWithFailure
    }
}

Main