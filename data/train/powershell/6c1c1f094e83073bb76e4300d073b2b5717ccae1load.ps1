
function LoadGitTfs
{
    $env:Path += ";$installDir\git-tfs\bin"
}

function InstallGitTfs
{
    # $install = PromptForConfirmation `
    #     "Git Tfs Installation" `
    #     "Do you want to install Git Tfs now?" `
    #     "Install the latest version of Git Tfs." `
    #     "Do not install Git Tfs. Git Tfs will not be available in powerfull shell."

    # if (!$install) { return }

    $gitTfsVersion = "0.25.0"
    $downloadUrl = "https://github.com/git-tfs/git-tfs/releases/download/v$gitTfsVersion/GitTfs-$gitTfsVersion.zip"

    write "Downloading Git Tfs ..."
    Invoke-WebRequest $downloadUrl -OutFile "$env:TEMP\git-tfs.zip"
    write "Extracting Git Tfs ..."
    7za x -y "-o$installDir\git-tfs\bin" "$env:TEMP\git-tfs.zip" > $null

    LoadGitTfs
    write "Git Tfs successfully installed."
}

if (!(GitIsInstalled))
{
    Write-Verbose "Git is not installed. Git Tfs cannot be used."
    return
}

if (Test-Path "$installDir\git-tfs\bin\git-tfs.exe")
{
    LoadGitTfs
    return
}

InstallGitTfs
