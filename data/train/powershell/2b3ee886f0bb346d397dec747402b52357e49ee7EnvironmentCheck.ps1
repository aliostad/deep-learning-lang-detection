
task EnvironmentCheck {
    $toolsDir = Get-Conventions toolsDir

    if (-not (Test-Path "$toolsDir\ILMerge")) {
        Log-Message -message "Could not find ILMerge dependency" -type "error"
        exit 1
    }

    if (-not (Test-Path "$toolsDir\PSake")) {
        Log-Message -message "Could not find PSake dependency" -type "error"
        exit 1
    }

    if (-not (Test-Path "$toolsDir\PowerYaml")) {
        Log-Message -message "Could not find PowerYaml dependency" -type "error"
        exit 1
    }

    if (-not (Test-Path "$toolsDir\NUnit")) {
        Log-Message -message "Could not find NUnit dependency" -type "error"
        exit 1
    }

}

