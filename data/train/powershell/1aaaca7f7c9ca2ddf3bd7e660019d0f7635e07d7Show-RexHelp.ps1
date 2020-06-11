function Show-RexHelp {
$h1="-" * 80

@"
$h1
                             _           _     _      _
                            /\ \        /\ \ /_/\    /\ \
                           /  \ \      /  \ \\ \ \   \ \_\
                          / /\ \ \    / /\ \ \\ \ \__/ / /
                         / / /\ \_\  / / /\ \_\\ \__ \/_/
                        / / /_/ / / / /_/_ \/_/ \/_/\__/\
                       / / /__\/ / / /____/\     _/\/__\ \
                      / / /_____/ / /\____\/    / _/_/\ \ \
                     / / /\ \ \  / / /______   / / /   \ \ \
                    / / /  \ \ \/ / /_______\ / / /    /_/ /
                    \/_/    \_\/\/__________/ \/_/     \_\/

$h1
"@ | Write-Host -ForegroundColor Red

@"
Rex is a very simple and basic package manager. It uses PowerShell to script
common tasks.

HELP
    The following options will show this help.

    rex
    rex /? | help | -h

PARAMETERS
    -Command
        The command to execute. Posible values are:

        Version
            Prints out version information.

        Install
            Installs a package.

    -PackageName
        Name of the package to install.

    -Directory
        Base directory for the installer.

    -Version
        Version to install.

    -URL
        The URL of the package.

EXAMPLES
    rex Install Groovy
    rex install Groovy C:\bin\groovy
    rex Install -PackageName Groovy
    rex Install -PackageName Groovy -Directory C:\bin\groovy
    rex -Command Install -PackageName Groovy -Directory C:\bin\groovy
    rex -c Install -p Groovy -d C:\bin\groovy

"@ | Write-Host -ForegroundColor White
}
