
param(
    [switch]$local,
    [switch]$global
)

. init.ps1

function ShowContent
{
    param($context, $file)

    if (!(Test-Path $file -PathType Leaf))
    {
        write "There is no $context .gitignore yet"
    }
    else
    {
        write "$context gitignore: $file"
        cat $file 
    }
}

function ShowGlobal
{
    ShowContent "Global" $(iex "git config --global core.excludesfile")
}

function ShowLocal
{
    pushd $(git root)
    ShowContent "Local" .gitignore
    popd
}

function AddPatterns
{
    param($file, $patterns)

    write "Adding pattern(s) to: $file"
    foreach ($pattern in $patterns)
    {
        write "... adding '$pattern'"
        $escapedPattern = [Regex]::Escape($pattern)
        if (!($file -and (Test-Path $file) -and $pattern -and (cat $file | sls "^$escapedPattern$")))
        {
            $pattern | Out-File $file -Append -Encoding utf8
        }
    }
}

function AddGlobal
{
    param($patterns)

    AddPatterns $(iex "git config --global core.excludesfile") $patterns
}

function AddLocal
{
    param($patterns)

    pushd $(git root)
    AddPatterns .gitignore $patterns
    popd
}

if ($args.Count -eq 0 -and !$local.IsPresent -and !$global.IsPresent)
{
    ShowGlobal
    write "---------------------------------"
    ShowLocal
}
else
{
    if ($global.IsPresent)
    {
        if ($args.Count -ne 0) { AddGlobal $args }
        ShowGlobal
    }
    else
    {
        if ($args.Count -ne 0) { AddLocal $args }
        ShowLocal
    }
}
