<?php
global $processingTime;

$processingTime['Total']['stop'] = microtime(true);
$showTime = Framework::getConfigProperty(SHOW_TIME);


##====================================================================##
#display/log processing times if configured to do so

if($showTime != SHOW_TIME_OFF){
	if($showTime == SHOW_TIME_PRINT){
		echo "<div class=\"log\">\n";
	}
	$logMessage = 'Processing Time:';
	foreach($processingTime as $processName => $times){
		$message = "$processName: " . (number_format($times['stop'] - $times['start'], 5)) . " seconds"; 
		if($showTime == SHOW_TIME_PRINT){
			echo "<div class=\"log-item\">$message</div>\n";

		}else if($showTime == SHOW_TIME_LOG){
			$logMessage .= "\n\t$message";
		}
	
		
	}
    if($showTime == SHOW_TIME_PRINT){
		echo "</div>\n";
	}
	if($showTime == SHOW_TIME_LOG){
		Logger::notice($logMessage);
	}
}


?>
