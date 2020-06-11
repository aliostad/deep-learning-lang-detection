
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$source,
    [Parameter(Mandatory=$false, Position=1)]
    [string]$message
)

. init.ps1

function IsBranch
{
    $(git show-ref --verify --quiet "refs/heads/$source"; $?)
}

function IsCommitReference
{
    $(git rev-parse --verify --quiet "$source"; $?)
}

function IsOnCurrentBranch
{
    $commit = $(git rev-parse "$source")
    $(git rev-list HEAD) | sls -Quiet "$commit"
}

function CommitIfMessageProvided
{
    if ($message)
    {
        git commit -a -m "$message"
    }
}

function PromptContinuationIfSquashingMaster
{
    if ($source -eq "master")
    {
        $reply = Read-Host -Prompt "Warning: squashing '$source'! Continue [Y/N]?"
        if (sls "^[Yy]$" -InputObject $reply -NotMatch -Quiet)
        {
            write "Exiting"
            exit 1
        }
    }
}

function SquashBranch
{
    PromptContinuationIfSquashingMaster
    $(git merge --squash "$source"; $?) -or $(exit 1) | null
    CommitIfMessageProvided
}

function SquashCurrentBranch
{
    $(git reset --soft "$source"; $?) -or $(exit 1) | null
    CommitIfMessageProvided
}

if (IsBranch)
{
    SquashBranch
}
elseif (IsCommitReference -and IsOnCurrentBranch)
{
    SquashCurrentBranch
}
else
{
    error "Source branch or commit reference required!"
}
