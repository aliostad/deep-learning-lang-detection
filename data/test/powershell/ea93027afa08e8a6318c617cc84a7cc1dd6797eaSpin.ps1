. .\Lesson.ps1

function Pause
{
    #$Host.UI.RawUI.ReadKey() | Out-Null
    Write-Host `n
    $Ignore = Read-Host '::'
}

function Display-Message($Message, $Pause)
{
    Write-Host " |  $Message" -ForegroundColor Cyan
    #TODO: word wrap to $host.UI.RawUI.BufferSize.Width
    if ($Pause -eq $true) { Pause }
}

function Debug-Message($Message)
{
    Write-Host "DEBUG: $Message" 
}

function Display-Percentage-Completed-Message($FractionCompleted)
{
    $PercentageCompleted = [System.Convert]::ToInt32(100 * $FractionCompleted)                
    $TotalLength = ($host.UI.RawUI.BufferSize.Width - 20)
    $StatusBar = "=" * [System.Convert]::ToInt32($FractionCompleted * $TotalLength)
    $Spaces = " " * ($TotalLength-$StatusBar.Length)
    $Message = " |{0}{1}|  {2:d}% `n" -f $StatusBar, $Spaces, $PercentageCompleted
    Write-Host $Message -ForegroundColor Cyan
}


function Display-Menu($Message, $Options, $Targets)
{
    if ($Options.Count -ne $Targets.Count) 
    {
        Write-Error "Invalid args to Display-Menu"
        return
    }

    Display-Message $Message    

    #Display Menu
    $i = 1
    foreach($Option in $Options)
    {
        Write-Host $i ": $Option"
        $i++
    }

    #Read Selection; until valid selection or 0 to exit
    Write-Host `n   
    $MenuSelection = 1
    do {
        if ($MenuSelection -ne 1) { Write-Host "Enter an item from the menu, or 0 to exit" }
        Write-Host "Selection: " -ForegroundColor Blue -NoNewline
        $MenuSelection = Read-Host
        if ($MenuSelection -ge 1 -and 
            $MenuSelection -le $Targets.Count)
        {
            try {  &$Targets[$MenuSelection-1] }
            catch { Debug-Message ("Unable to find menu selection " + $Targets[$MenuSelection-1]) }
            break
        }
    } While ($MenuSelection -ne 0)
}

function Start-Spin
{
    ##Greet
    Display-Message "Hi! Hit Enter when you are ready to begin."
    Read-Host

    clear-Host
    #$UserName = Read-Host 'What shall I call you? '
    #Display-Message -Message "Hi $UserName. Let's cover a few quick housekeeping items before we begin our first lesson. First of all, you should know that when you see '...', that means you should press Enter when you are done reading and ready to continue."

    #Menu
    Display-Menu -Message "Main Menu" -Options @("TestLesson","Err") -Targets @("Start-Lesson","option2")
    Display-Message -Message "Leaving spin now. Type spin.ps1 to resume."

    #Lesson
}

Start-Spin