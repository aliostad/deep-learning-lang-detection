if($args.Length -lt 1) {
    Write-Host "Not enough arguments passed, skipping script";
    return;
}
$file = $args[0];

$xml = [xml](get-content $file)
$îssueTypes = $xml.SelectNodes("/Report/IssueTypes/IssueType")
$issues = $xml.SelectNodes("/Report/Issues/Project/Issue")
$messages = @()

foreach($i in $issues){
	$issueType = $îssueTypes | ? { $_.Id -eq $i.TypeId }
	$messages += New-Object PSObject -Property @{
		File = $i.File
		Message = $i.Message
		Severity = $issueType.Severity
		Line = $i.Line
	}
}

foreach($msg in $messages){
		$msgfmt = $msg.Message + " in " + $msg.File + " line: " + $msg.Line
		
		if($env:APPVEYOR){
			if($msg.Severity -eq "SUGGESTION" -or $msg.Severity -eq "HINT") { Add-AppveyorMessage -Message $msgfmt -Category "Information" -Details $msgfmt }
			elseif($msg.Severity -eq "WARNING") { Add-AppveyorMessage -Message $msgfmt -Category "Warning" -Details $msgfmt }
			elseif($msg.Severity -eq "ERROR") { Add-AppveyorMessage -Message $msgfmt -Category "Error" -Details $msgfmt }			
		}else{
			Write-Host $msgfmt
		}
}