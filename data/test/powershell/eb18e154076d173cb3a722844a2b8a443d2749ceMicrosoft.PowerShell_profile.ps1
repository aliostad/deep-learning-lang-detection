Set-Alias prof Edit-Profile
Set-Alias gcd Git-Project-Root
Set-Alias st Sublime-Text
Set-Alias which Which-Alias

function Sublime-Text {
    $a = $args
    if ($args -eq ".") {
        $a = $pwd
    }
    & 'c:\Program Files\Sublime Text 3\sublime_text.exe' $a
}

function Edit-Profile {
    Sublime-Text $Profile
}

function Git-Project-Root {
    $rootPath = & "git" "rev-parse" "--show-toplevel" 2>&1
    if (Test-Path $rootPath) {
        Set-Location $rootPath      
    }
    else {
        Write-Host "Not in a git repository!"
    }
}

function Which-Alias {
    (Get-Command $args).Path
}