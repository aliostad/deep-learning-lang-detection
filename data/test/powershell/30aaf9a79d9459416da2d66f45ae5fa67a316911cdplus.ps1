function Push-Directory ($newLocation) {
    $newLocation = Get-Item -force $newLocation;
    $global:CD_COMMAND_HISTORY_LIST.Insert(0, $(Get-Location))
    Push-Location $newLocation
}

function Get-CommandList () {
    $global:CD_COMMAND_HISTORY_LIST
}

function Show-HistoryDirectory ($ShowCount) {
    if(!$ShowCount) {
        $ShowCount = 10;
    }
    $index = 0;
    foreach ($location in Get-CommandList){
        Write-Host ("{0,6}) {1}" -f $index, $location)
        $index++
        if($index -gt $ShowCount) {
            break;
        }
    }
}

function Set-Directory ($cmd) {
    if(!$global:CD_COMMAND_HISTORY_LIST) {
        $global:CD_COMMAND_HISTORY_LIST = New-Object 'System.Collections.Generic.List[string]'
    }

    switch($cmd) {
    ""  {
        if (!$Env:HOME) {
            Push-Directory ($Env:USERPROFILE)
        } else {
            Push-Directory ($Env:HOME)
        }
    }

    "-" {
        if($global:CD_COMMAND_HISTORY_LIST.Count -ge 1) {
            Push-Directory ($global:CD_COMMAND_HISTORY_LIST[0])
        }
    }

    default {
        $newLocation = $cmd;

        # check to see if we're using a number command and get the correct directory.
        [int]$cdIndex = 0;

        if([system.int32]::TryParse($cmd, [ref]$cdIndex)) {
            # Don't pull from the history if the index value is the same as a folder name
            if( !(test-path $cdIndex) ) {
                $results = (Get-CommandList);
                if( ($results | measure).Count -eq 1 ){
                    $newLocation = $results
                }
                else {
                    $newLocation = $results[$cdIndex]
                }
            }
        }

        #If we are actually changing the dir.
        if($pwd.Path -ne $newLocation){

            # if the path exists
            if( test-path $newLocation ){

                # if it's a file - get the file's directory.
                if( !(Get-Item $newLocation -Force).PSIsContainer ) {
                    $newLocation = (split-path $newLocation)
                }

                Push-Directory $newLocation
            }
            else {
                if($force) {
                    $prompt = 'y'
                }
                else {
                    $prompt = Read-Host "Folder not found. Create it? [y/n]"
                }

                if($prompt -eq 'y' -or $prompt -eq 'yes') {
                    New-Item $newLocation
                    Push-Directory $newLocation
                }
            }
        }
    }
    }
}

