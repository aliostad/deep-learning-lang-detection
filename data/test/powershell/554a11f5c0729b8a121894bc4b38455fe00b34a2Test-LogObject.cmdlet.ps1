Function Test-LogObject {
	[CmdLetBinding()]
	param($Path = $null 
			,[switch]$Screen = $false
			,[switch]$Buffer = $false
			,$LogLevel = 3
			,$LoggingNumber = 15
			,$BufferIsHostDelay = 1
			,[switch]$BufferIsHost = $false
			,[string[]]$RandomColoring=$null
			,$RetainedInterval = 1
			,$RetainedCount = 5
			,$IdentString = "`t"
	)
	
	try {

		$o = New-LogObject
		$o.LogTo = @()
		$o.BufferIsHost = $BufferIsHost;
		$o.IgnoreLogFail = $false;
		$o.IdentString = $IdentString;
		
		if($Screen) {
			$o.LogTo += "#"
		}
		
		if($Buffer) {
			$o.LogTo += "#BUFFER"
		}
		
		if($LogLevel){
			$o.LogLevel = $LogLevel;
		}
		
		if($Path){
			$o.LogTo += $Path;
		}
		
		if($BufferIsHost){
			$o | Invoke-Log "THIS WAS FORCED!" "PROGRESS" -ForceNoBuffer
		}
		
		#coloring test...
		$o | Invoke-Log "Color logging" "PROGRESS" -ForegroundColor "Red"; 
		$o | Invoke-Log "WITH NO TIMESTAMP!" -NoUseTimestamp
		
		#Identation
		$o | Invoke-Log "TESTING IDENTATION SIMPLE"
		$o | Invoke-Log "1" 		-RaiseIdent -SaveIdent "B_1.1"
		$o | Invoke-Log "1.1" 		-RaiseIdent -SaveIdent "B_1.1.1"
		$o | Invoke-Log "1.1.1"
		$o | Invoke-Log "1.1.2" 	-RaiseIdent 
		$o | Invoke-Log "1.1.2.1"	
		$o | Invoke-Log "1.1.3"		-DropIdent
		$o | Invoke-Log "1.2"		-ResetIdent "B_1.1.1"
		$o | Invoke-Log "2" 		-IdentLevel 0
		$o | Invoke-Log "3 no params."
		$o | Invoke-Log "3.1 -RaiseIdent -ApplyThis = This message must raise"		-RaiseIdent -ApplyThis
		$o | Invoke-Log "3.1.2 -RaiseIdent -ApplyThis = This message must raise"	-RaiseIdent -ApplyThis
		$o | Invoke-Log "3.1.3 (no param specified) = this message must keep previous message identation level"
		$o | Invoke-Log "3.2 -DropIdent = this message must drop one level"		-DropIdent
		$o | Invoke-Log "3.2.1 -RaiseIdent -ApplyThis -KeepFlow = this message must raise one level and next must maintain previous."		-RaiseIdent -ApplyThis -KeepFlow
		$o | Invoke-Log "3.3 (no param) = this message must be same level as 3.2"
		$o | Invoke-Log "4 -DropIdent = this message most return to level 0 (no identation)" -DropIdent
		$o | Invoke-Log "5 -RaiseIdent = this message = 0" -RaiseIdent
		$o | Invoke-Log "5.1 (no params) = this message = 1, because previous RaiseIdent"
		$o | Invoke-Log "6 -DropIdent -RaiseIdent = this message = 0, next = 1" -DropIdent -RaiseIdent
		$o | Invoke-Log "6.1 (no params) = this message = 1" 
		$o | Invoke-Log "6.2-Drop -Raise -ApplyThis = no effect. maintain previous" -DropIdent -RaiseIdent -ApplyThis
		$o | Invoke-Log "6.3 -Drop -Raise -ApplyThis -KeepFlow = no effect. maintain previous" -DropIdent -RaiseIdent -ApplyThis -KeepFlow
		$o.dropIdent();
		$o | Invoke-Log "7 No parans, Ident must be droppped because previous method dropIDent."
		$o | Invoke-Log "8 -Raise = Next must raise." -RaiseIdent
		$CurrentLevel = $o.getIdentLevel();
		$o | Invoke-Log "8.1 -Raise . this must raise and must raise next." -RaiseIdent
		$o | Invoke-Log "8.1.1 This must raise because previous -Raise"
		$o.setIdentLevel($CurrentLevel);
		$o | Invoke-Log "9 Must return to main level, because setIdent method."
		$o | Invoke-Log "" -IdentLevel 0 -NoUseTimestamp
		
		
		$o | Invoke-Log "TESTING IDENTATION WITH RETAIN FLUSH" -IdentLevel 0
		$o | Invoke-Log "1 (Retained)" 		-Retain -RaiseIdent
		$o | Invoke-Log "1.1 (Retained)" 	
		$o | Invoke-Log "1.2 (Retained)" 	
		$o | Invoke-Log "2 (Flushed)"		-DropIdent -Flush 	
		$o | Invoke-Log "3 (Normal)" 	
		
		
		
		
		
		#buffering (retain) test
		$o | Invoke-Log "Retained Start!!!" "PROGRESS" -Retain 
	
		1..$RetainedCount | %{
			$TestLogLevel = Get-Random -Minimum 1 -Maximum 5	
			$o | Invoke-Log "Retained message $_ - LogLevel: $TestLogLevel " $TestLogLevel 
			Start-Sleep -s $RetainedInterval
		}
		
		$o | Invoke-Log "Flushed message" "PROGRESS" -Flush
		
		$o | Invoke-Log "Log levels + color testing" -IdentLevel 0
		
		1..$LoggingNumber | %{
			$TestLogLevel = Get-Random -Minimum 1 -Maximum 5
			
			$fcolor = $null;
			$bcolor = $null;
			$MessageToLog = "";
			
			if($RandomColoring){
				$fcolor = @($RandomColoring + 1) | Get-Random
				
				if($fcolor -eq 1){
					$fcolor = $null;
				}
				else {
					$MessageToLog += "[F:$($fcolor)]"
				}
				
			}
			
			if($RandomColoring){
				$bcolor = @($RandomColoring + 1) | ? { $_  -ne $fcolor } | Get-Random
				
				if($bcolor -eq 1){
					$bcolor = $null;
				}
				else {
					$MessageToLog += "[B:$($bcolor)]"
				}

			}
			
			$MessageToLog += "TestLog $_ LogLevel $TestLogLevel"
			
			$o | Invoke-Log $MessageToLog $TestLogLevel -fcolor $fcolor -bcolor $bcolor
			
			Start-Sleep -s $BufferIsHostDelay
		}
		
		


	} finally {
		write-host ">>> LOGGIN TEST FINIHED. CHECK NEXT RESULTS."
		
		if($Path){
		write-host "------------ PATHS: "
			$Path | %{
				if(-not(Test-Path $_)){
					write-host "Log file inexistent: $_"
					continue;
				}
				
				$p = gi $_
				write-host "	$($p.FullName):"
				gci $p | %{write-host "		$($_.Name)"}
			}
		}
	
		if($o.outBuffer){
			write-host "------------ BUFFERED CONTENTS: "
			write-host ($o.outBuffer -join "`r`n")
		}
		
		$o = $null
	}
}