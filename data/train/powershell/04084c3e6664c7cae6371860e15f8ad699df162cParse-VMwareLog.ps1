[cmdletbinding()]
Param (
    $file,
    $readcount = 100
)

#Read a log file and figure out
#Number of unique instances of a message

$logbatches = Get-Content $file -ReadCount $readcount

$messages = @()
foreach($batch in $logbatches) {
    $i++
    Write-Progress -Activity "Parsing log batch $i" -Status "[$i/$($logbatches.count)]" -PercentComplete (($i/$logbatches.count)*100)
        foreach($line in $batch) {
        $split = $line.Split("|")
        $time = $split[0]
        $source = $split[1].TrimStart(" ")
        $message = $split[2].TrimStart(" ")

        if($messages -match $message) {
            $index = $messages.IndexOf($message)
            $messages[$index].count++        
        } else {
            $messages += New-Object PSObject -Property @{
                Count = 1
                Message = $message
            }
        }

        #$logobj += New-Object PSObject -Property @{
        #    Time = $time
        #    Source = $source
        #    Message = $message
        #}
    }
}

$messages