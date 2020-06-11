# look for shows in the TV shows directory that are not in iTunes
# set up some variables
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
. $dir\functions.ps1

Get-Date
$library = ituneslibrary

foreach ($show in $shows) {
    "checking $show"
    $dir = $master+$show
    if (test-path $dir) {
        foreach ($episode in (Get-ChildItem $dir)) {
#            "checking $episode"
            if ((Test-Path "$dir\$episode" -PathType leaf)) {
#               "checking whether $episode is in iTunes"
                $title = ([string]$episode).substring(0,([string]$episode).Length - 4)
                if (!($item = $library.Search("$title",0))) {
                    "$title not in library - removing"
#                    Remove-Item $episode
                }
            }
        }
    }
}
