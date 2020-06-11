# set up some variables
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
. $dir\functions.ps1

Get-Date
$library = ituneslibrary

# specify a date after which we want to fix the artwork
$okdate = Get-Date "2012-07-30 8:12 AM"

# generate a list of candidate tv shows
"getting list of shows to fix"
$list = $library.Tracks | Where-Object { ($_.VideoKind -eq 3) -and ($_.DateAdded -gt $okdate) } | Sort-Object DateAdded

"number of shows to fix is "+$list.count

foreach ($show in $list) {
    "setting artwork for "+$show.Name
    set_artwork $show $show.Show
}
