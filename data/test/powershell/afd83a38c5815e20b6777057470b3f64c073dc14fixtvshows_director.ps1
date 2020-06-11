# set up some variables
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
. $dir\functions.ps1


Get-Date
$library = ituneslibrary

$shows = @("Marvel's Agents Of S")

foreach ($show in $shows) {
    "checking $show"
    
    foreach ($item in $library.Search($show,0)) {
       "updating metadata for : "+$item.Name
        
        # set metadata
        $item.Artist = "1"
            
        set_artwork $item $show
    }
}
