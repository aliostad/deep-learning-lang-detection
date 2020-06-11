# set up some variables
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
. $dir\functions.ps1
$showlistfile = "$dir\$showlist"
$shows = @( "The Bachelor",
            "Playing It Straight",
            "MasterChef Australia",
            "Judge Judy",
            "Grand Designs",
            "Fashion Star",
            "America's Next Top M",
            "Selling Houses Abroa",
            "Escape to the Countr",
            "60 Minute Makeover",
            "Homes Under the Hamm",
            "New Zealand's Next T",
            "Dr Oz")

Get-Date
$library = ituneslibrary

foreach ($show in $shows) {
    #"checking $show"
    $masterdir = $master+$show
    if (test-path $masterdir) {
        $slavedir = $slave+$show
        if (!(test-path $slavedir)) {
            "making directory $remotedir"
            new-item $slavedir -type directory
        }
        foreach ($episode in (Get-ChildItem $masterdir)) {
            #"checking $episode"
            if ((Test-Path "$masterdir\$episode" -PathType leaf) -and -not (Test-Path "$slavedir\$episode") -and -not
                (Select-String -path $showlistfile -quiet "$episode")) {
                if ((file_size "$masterdir\$episode") -gt (free_disk_c)) {
                    "not enough space on C: to copy $episode"
                    return
                }
                "copying over $episode"
                try {
                    Copy-Item "$masterdir\$episode" "$slavedir"
                } catch {
                    "failed"; $error[0]
                    return
                }
                "add $episode to iTunes and setting metadata"
                try {
                    ($name, $title, $filename, $year,$month,$day,$time) = meta_from_iTunes_file $episode
                } catch {
                    "couldn't get metadata from name of $episode"; $error[0]
                    return
                }
                try {
                    add_to_itunes_set_metadata $library "$slavedir\$episode" $title $name $year
                } catch {
                    "problem adding $episode to iTunes"; $error[0]
                    return
                }
                "$episode" >> $showlistfile
            }
        }
    }
}
