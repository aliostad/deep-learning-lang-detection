##############################################################################
# Install this script by putting the following in your
# Microsoft.Powershell_profile.ps1 file:
#
#     Import-Module 'C:\path\to\module\TfsHandy.psm1'
#
# Then you can use the commands Show-TfsDiff (mydf), Show-TfsChangeset
#   (mycs), Show-TfsStatus (myst) and Show-TfsHistory (myhi) to get
#   colorized and prettified output from your Team Foundation Server.
#
# You need to have something like this in your profile:
# $DEVS = @{
#     "user1" : Color1;
#     "user2" : 12;
#     ...      
# }
#
##############################################################################
# Write-Host variants ########################################################
##############################################################################
function Print(
    [string]$line
) {
    Write-Host $line -NoNewline
}

function PrintCol(
    [string]$line,
    [string]$col
) {
    Write-Host $line -ForegroundColor $col -NoNewline
}

function PrintCyan(
    [string]$line
) {
    PrintCol $line Cyan
}

function PrintGray(
    [string]$line
) {
    PrintCol $line Gray
}

function PrintGreen(
    [string]$line
) {
    PrintCol $line Green
}

function PrintRed(
    [string]$line
) {
    PrintCol $line 6
}

function PrintWhite(
    [string]$line
) {
    PrintCol $line White
}

##############################################################################
# TFS Utility ################################################################
##############################################################################

function CountChanges([string]$fname, [string]$versionOpt) {
    #requires -version 2
    $changes = $(0, 0)
    tf diff $fname $versionOpt /noprompt | ForEach {
        if ($_ -match "^\+[^\+]") {
            $changes[0] += 1
        }
        elseif ($_ -match "^\-[^\-]") {
            $changes[1] += 1
        }
    }
    return $changes
}

function ParseStatusLine([string]$line) {
    $res = $line -match "^([\w\-\.]+)\s+(edit|! rename|! add|add)\s+(.*)$"
    $prefix = ""
    $action = $matches[2]
    if ($action.StartsWith("! ")) {
        $prefix = "!"
        $action = $action.Substring(2)            
    }
    return @($prefix, $action, $matches[3])
}

function PrintChangesetLine(
    [string]$line,
    [bool]$verbose,
    [string]$versionOpt
) {
    if ($line -match "^\-{8}") {
    }
    elseif ($line -match "^([\s\w\-]+):(.*)$") {
        Write-Host $($matches[1]) -ForegroundColor White -NoNewline
        Write-Host ":" -NoNewline
        Write-Host $($matches[2]) -ForegroundColor 10
    }
    elseif ($line -match "^\s+(add|edit)\s+(.*)$") {
        $change = $matches[1]
        $fname = $matches[2]
        if ($change -eq "edit") {
            Write-Host "  edit " -ForegroundColor 10 -NoNewline
        }
        elseif ($change -eq "add") {
            Write-Host "  add  " -ForegroundColor 11 -NoNewline
        }
        $fnameStr = "{0,-75}" -f $fname
        Write-Host $fnameStr -NoNewline

        $changes = CountChanges $fname $versionOpt
        
        $plus = " {0,4}" -f $changes[0]
        $minus = " {0,4}" -f -$changes[1]
        Write-Host -NoNewline -ForegroundColor 11 $plus
        Write-Host -NoNewLine -ForegroundColor 6 $minus
        Write-Host ""
        return $fname
    }
    else {
        Write-Host "$line" 
    }
    return $null
}


##############################################################################
# Colorizers #################################################################
##############################################################################
function Format-Diff {
    <#
    .Synopsis
        Redirects a Universal DIFF encoded text from the pipeline to the host using colors to highlight the differences.
    .Description
        Helper function to highlight the differences in a Universal DIFF text using color coding.
    .Parameter InputObject
        The text to display as Universal DIFF.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSObject]$InputObject
    )
    Process {
        $line = $InputObject | Out-String
        if ($line -match "^Index:") {
            PrintCyan $line
        }
        elseif ($line -match "^==========") {
        }
        elseif ($line -match "^(\+|\-|\=){3}") {
            PrintCyan $line
        }
        elseif ($line -match "^@{2}") {
            PrintGray $line
        }
        elseif ($line -match "^\+") {
            PrintGreen $line
        }
        elseif ($line -match "^\-") {
            PrintRed $line
        } 
        else {
            Print $line 
        }
    }
}

function Colorize-Status {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]$InputObject
    )
    Process {
        $line = $InputObject | Out-String
        if ($line -match "^(File name|\-\-\-\-\-\-|\$/|\d+ change|There are no pending changes)") {
        }
        elseif ($line.trim() -eq "") {
        }
        else {
            $res = ParseStatusLine $line

            $prefix = $res[0]
            $action = $res[1]
            $fname = $res[2].trim()

            $col = "Red"
            if ($action -eq "edit") {
                $col = "Green"
            } elseif ($action -eq "add") {
                $col = "DarkMagenta"
            }
            $nSpaces = 10
            if ($prefix -eq "!") {
                PrintWhite "! "
                $nSpaces -= 2
            }                
            PrintCol ("{0,-$nSpaces}" -f $action) $col
            Print ("{0,-80}" -f $fname)

            $changes = CountChanges $fname ""
            $plus = " {0,4}" -f $changes[0]
            $minus = " {0,4}" -f -$changes[1]
            PrintCyan $plus
            PrintRed $minus
            Write-Host
        }
    }
}

$MONTH_COLORS = @{
    "01" = 2;
    "02" = 3;
    "12" = 11;
    "11" = 10;
    "10" = 9;
    "09" = 6;
    "08" = 12;
    "07" = 13;
    "06" = 14;
    "05" = 2;
    "04" = 7;
    "03" = 6
}        

function Colorize-History {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]$InputObject
    )
    Process {
        $line = $InputObject | Out-String
        if ($line -match "^(Changeset|\-\-\-\-\-)") {
        }
        # Possible domain prefix of user name is removed here.
        elseif ($line -match "^(\d+)\s+(\w+)\\(\w+)\s+([\w-]+)(.*)$") {
            Write-Host ("{0, 5}" -f $matches[1]) -ForegroundColor 14 -NoNewline
            $user=$matches[3]
            $col=$DEVS[$user]
            PrintCol ("{0,6}" -f $user) $col 
            $date = $matches[4]
            $month = ($date -split "-")[1]
            $dateCol = $MONTH_COLORS[$month]
            PrintCol ("{0,11}" -f $date) $dateCol
            Write-Host $matches[5] 
        }
    }
}

##############################################################################

function Show-TfsDiff {
    #requires -version 2
    if ($args.length -eq 0) {
        [Array]$args = "."
    }
    tf diff $args /recursive /noprompt | Format-Diff
}

function Show-TfsStatus {
    #requires -version 2
    if ($args.length -eq 0) {
        [Array]$args = "."
    }
    tf status /recursive $args | Colorize-Status
}

function Show-TfsHistory([string]$path = ".", [int]$limit = 30) {
    if (!(test-path variable:DEVS)) {
        PrintRed "For this command to work, the variable DEVS "  
        PrintRed "need to be set to an associative array mapping names " 
        PrintRed "of developers to colors."
        Write-Host
        return
    }

    tf history $path /recursive /noprompt /stopafter:$limit | Colorize-History
}

function Show-TfsChangeset([int]$cnum, [bool]$verbose) {
    #requires -version 2
    $text = tf history /noprompt /recursive /v:C$cnum~C$cnum /format:detailed .
    $diffFiles = @()
    $versionOpt = "/version:C$($cnum - 1)~C$cnum"
    $text | foreach {
        $val = PrintChangesetLine $_ $verbose $versionOpt
        if ($val -ne $null) {
            $diffFiles += $val
        }
    }
    if ($verbose -eq $false) {
        return
    }
    $diffFiles | foreach {
        tf diff $_ /noprompt $versionOpt | Format-Diff
    }
}

function Push-TfsChangeset() {
    #requires -version 2
    tf checkin $args
}

##############################################################################
New-Alias -name myci -value Push-TfsChangeset
New-Alias -name mycs -value Show-TfsChangeset
New-Alias -name mydf -value Show-TfsDiff
New-Alias -name myhi -value Show-TfsHistory
New-Alias -name myst -value Show-TfsStatus

Export-ModuleMember -Function Format-Diff,Show-*,Push-* -Alias myci,mycs,mydf,myhi,myst
