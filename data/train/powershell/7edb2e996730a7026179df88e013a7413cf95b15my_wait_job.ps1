<#
.SYNOPSIS
    http://social.technet.microsoft.com/Forums/scriptcenter/en-US/e961e00d-e2aa-4d42-baa5-fb2fa50f4fc0/controlling-powershells-console-output
#>
function my_wait_job($job) 
{
$saveY = [console]::CursorTop
$saveX = [console]::CursorLeft   
$str = '|','/','-','\'     
do {
$str | ForEach-Object { Write-Host -Object $_ -NoNewline
        Start-Sleep -Milliseconds 100
        [console]::setcursorposition($saveX,$saveY)
        } # end foreach-object
    if ((Get-Job -Name $job).state -eq 'Running') 
    {$running = $true}
    else {$running = $false}
    } # end do
while ($running)
} # end function

<#
Start-Job -ScriptBlock {Start-Sleep 10} -Name j1
myWaitJob j1
rjb j1
#>