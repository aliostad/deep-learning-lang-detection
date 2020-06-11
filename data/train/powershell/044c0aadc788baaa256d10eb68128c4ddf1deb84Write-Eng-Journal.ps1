#Writes a time-stamped entry to a file

function Write-Eng-Journal
{
    if($args.count -lt 1){
        return "ERROR: No Message Given"
    } elseif($args.count -gt 1){
        $filePath = $args[0];
		$message = $args[1];
    } else {
        $filePath = Get-Eng-Journal-Location
        $message = $args[0];
    }

    $dateTime = Get-Date;
    $todayString = $dateTime.ToString("MM/dd/yy");
    $lastLine = (Get-Content $filePath)[-1];
    if(!$lastLine.StartsWith($todayString))
    {
        $separator = "========================= " + $todayString + " ==========================";
        Add-Content $filePath "";
        Add-Content $filePath $separator;
    }
    
    $message = $dateTime.ToString("MM/dd/yy HH:mm") + " - " + $message;
    Add-Content $filePath $message;
}