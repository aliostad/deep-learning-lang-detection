
. init.ps1

function git-contrib
{
    <#

    .SYNOPSIS
    Show user's contributions

    .DESCRIPTION
    Output a user's contributions to a project, based on the author name.

    .PARAMETER username
    The name of the user who owns the contributions.

    #>

    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$username
    )

    $count = (git log --oneline --pretty="format: %an" | sls "$username" | measure -Line).Lines
    if ($count -eq 0)
    {
        write "$username did not contribute"
        return
    }
    git shortlog | sls "$username" -Context 0,$count
}

git-contrib @args
