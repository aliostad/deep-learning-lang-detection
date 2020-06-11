param($file, $show) 
. .\browser.ps1 
function get_timestamp{
    $retval = Get-Date -uformat "%Y.%m.%d %H:%M:%S";
    return $retval;
}

function parse_show_parameters($show){
    $global:show_all = $false;
    $global:show_run = $false;
    $global:show_get = $false;
    $global:show_test = $false
    if ($show -match "a") {$global:show_all = $true} 
    if ($show -match "r") {$global:show_run = $true}
    if ($show -match "g") {$global:show_get = $true}
    if ($show -match "t") {$global:show_test = $true}
}

function step_run($line, $line_num, $browser){
    if($global:show_all -or $global:show_run) { get_timestamp | Write-Host -nonewline; Write-Host " RUN: " -foregroundcolor black -backgroundcolor yellow -nonewline; Write-Host $line_num $line.operation $line.target $line.value $line.wait_before }
    switch ($line.operation) 
    { 
        'navigate' 
        {
            $retval = browser_navigate $browser $line.value 
        } 
        'value' 
        {
            $retval = browser_set_value $browser $line.target $line.value 
        } 
        'click' 
        {
            $retval = browser_click $browser $line.target 
        } 
        'checked'
        {
            $retval = browser_checked $browser $line.target $line.value
        }
        'close' 
        {
            $browser.Quit();
            Write-Host "FINISHED" -foregroundcolor black -backgroundcolor yellow;           
        } 
        default {Write-Host " ERROR:Unknown operation " -backgroundcolor red -nonewline}
    }
}

function step_get($line, $line_num, $browser){
    if($global:show_all -or $global:show_get) {
        get_timestamp | Write-Host -nonewline; Write-Host " GET: " -foregroundcolor black -backgroundcolor green -nonewline; Write-Host $line_num $line.operation $line.target $line.value $line.wait_before ;
        get_timestamp | Write-Host -nonewline; Write-Host " GET LINE=" $line_num -foregroundcolor black -backgroundcolor green;
        Write-Host "URL=" -nonewline; browser_get_url $browser | Write-Host ;
        Write-Host "TARGET=" $line.target;
    }
    switch ($line.operation) 
    {
        'navigate' 
        {
            Write-Host "NOT IMPLEMENTED YET SRY" -foregroundcolor black -backgroundcolor turqoise;  
        } 
        'value' 
        {
            $retval = browser_get_value $browser $line.target $line.value
            if($global:show_all -or $global:show_get) { Write-Host "VALUE=" $retval; }
        } 
        'checked'
        {
            $retval = browser_get_checked $browser $line.target
            if ($retval){
                if($global:show_all -or $global:show_get) { Write-Host "CHECKED=TRUE"; }
            }
            else { 
                if($global:show_all -or $global:show_get) { Write-Host "CHECKED=FALSE"; }
            }
        }
        default {Write-Host " ERROR:Unknown operation " -backgroundcolor red -nonewline}
    }
}

parse_show_parameters $show
$step_file =  Import-Csv -Delimiter "`t" -Path $file;
$browser = create_ie;
$line_num = 0;

foreach ($line in $step_file)
{   
    $line_num++;
    w8_for_browser $browser
#    Write-Host "EXECUTING: " $line_num $line.operation $line.target	$line.value	$line.wait_before ;
    Start-Sleep -Milliseconds $line.wait_before;
    $retval = $false
    switch ($line.instruction) 
    {
        '' 
        {
            $retval = step_run $line $line_num $browser
        } 
        'run' 
        {
            $retval = step_run $line $line_num $browser
        } 
        'get' 
        {
            $retval = step_get $line $line_num $browser
        } 
    }
}