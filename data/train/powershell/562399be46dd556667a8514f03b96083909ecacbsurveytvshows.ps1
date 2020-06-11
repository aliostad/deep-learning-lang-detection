# find what TV shows are on Nicola's laptop
# set up some variables
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
. $dir\functions.ps1
$showlistfile = "$dir\$showlist"

Get-Date
$library = ituneslibrary

foreach ($show in $shows) {
    "checking $show"
    $dir = $slave+$show
    if (test-path $dir) {
        foreach ($episode in (Get-ChildItem $dir)) {
            if (Test-Path "$dir\$episode" -PathType leaf) {
                "checking $episode"
                $title = ([string]$episode).SubString(0,([string]$episode).Length - 4)
                
                # find
                if ($library.Search("$title",0) -eq $null) {
                    "need to add $title to iTunes"
                    ($name, $title, $filename, $year,$month,$day,$time) = meta_from_iTunes_file $episode
                    add_to_itunes_set_metadata $library "$dir\$episode" $title $name $year
                }
                "$episode" >> $showlistfile                
            }
        }
    }
}
