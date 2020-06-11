param (
    $option,
    $message,
    $files
)

$CODE = 0
$ROOT = ( git rev-parse --show-toplevel )

if ( !$? ) {
    write-host "WorkDir: ${pwd}" -foregroundcolor gray
    write-host "This is not GIT repository." -foregroundcolor red
    exit 10
}

function last10messages {
    push-location -path $ROOT   
    $MESSAGE = ( ( git log -10 --pretty=%s ) -split '\n' ) | ? { $_.trim() -ne '' }
    $CODE = $lastExitCode
    $MESSAGE
    pop-location
    exit $CODE
}

function repostatus {
    push-location -path $ROOT
    $STATS = ( git status -sb --ignore-submodules )
    $CODE = $lastExitCode
    if (0 -ne $CODE) {
        write-host "WorkDir: ${pwd}"
    }
    $STATS
    pop-location
    exit $CODE
}

function listbranches {
    push-location -path $ROOT
    $LOCAL_BRANCHES = ( git branch --list )
    $CODE = $lastExitCode
    $LOCAL_BRANCHES
    pop-location
    exit $CODE
}

function commitwork {
    if ($message -and $files) {
        push-location -path $ROOT
        echo "$message"
        foreach ($relPath in ( $files -split ',' ) ) {
            write-host "Adding to git: $relPath"
            git add $relPath
        }
        write-host "Commiting with message: $message"
        git commit -m"$message"
        pop-location
    }
    exit $CODE
}

switch ( $option ) {
    "last10messages" { last10messages }
    "repostatus" { repostatus }
    "commitwork" { commitwork }
    "listbranches" { listbranches }
    default { 
        write-host "WorkDir: ${pwd}" -foregroundcolor gray
        write-host "Please provide an option." -foregroundcolor red
        exit 20
    }
}
