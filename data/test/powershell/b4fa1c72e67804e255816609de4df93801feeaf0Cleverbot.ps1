# Cleverbot.ps1
# Author:       xcud
#

function Start-CleverBot
{
	param([switch]$Visible = $false);
	
	if($cleverBotBrowser -ne $null) { 
		return; 
	}
	
	set-Variable -Name cleverBotBrowser -Scope global -Value (new-object -com "InternetExplorer.Application")
	$cleverBotBrowser.Visible = $Visible
	$cleverBotBrowser.Navigate("http://cleverbot.com")
	WaitFor-CleverBotBrowser
}

function Stop-CleverBot 
{
	try {
		$cleverBotBrowser.Quit();
	}
	catch { }
	finally {
		$cleverBotBrowser = $null
		Remove-Variable cleverBotBrowser -Scope global -ErrorAction silentlycontinue
	}
}

function WaitFor-CleverBotBrowser 
{
	while ($cleverBotBrowser.busy -and $cleverBotBrowser.Document.readystate -ne "complete") 
	{ sleep -milliseconds 500 }
	Sleep -Milliseconds 500 # one more time
}

function Tell-CleverBot
{
	param([parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$msg)
	
	Start-CleverBot
	
	$history = Get-CleverBotTranscript
	
	# send message
	$stimulus = $cleverBotBrowser.Document.getElementById("stimulus")
	$stimulus.value = $msg
	$submit = $cleverBotBrowser.Document.getElementById("sayit")
	$submit.click();
	WaitFor-CleverBotBrowser 

	# get response
	$counter = 0
	while($true) {
	
		WaitFor-CleverBotBrowser
		
		$lastMessage = Get-CleverBotTranscript | select -last 1
		$lastMessageLen = $lastMessage.Length
		if($lastMessageLen -lt 2) 
		{  
			# cleverbot is thinking
			Write-Verbose "Thinking ..."
			continue
		} 
		
		sleep -Milliseconds 100
		$lastMessage = Get-CleverBotTranscript | select -last 1
		if($lastMessage.length -ne $lastMessageLen) 
		{ 
			# message is being written
			Write-Verbose "Writing ..."
			continue
		} 
		
		# check for a valid 'most recent message' from cleverbot
		if( $lastMessage -ne $msg `
			-and ![string]::IsNullOrEmpty($lastMessage) `
			-and !($history -contains $lastMessage) ) 
		{
			$lastMessage
			break
		}
		
		# check for timeout
		if($counter++ -gt 30) {
			Write-Error "Timed out"
			break
		}
		
		Sleep -Seconds 1
	}
}

function Get-CleverBotTranscript
{
	$respArea = $cleverBotBrowser.Document.getElementById("respArea")
	$rows = ($respArea.getElementsByTagName("tr") | select -First 1).getElementsByTagName("tr")
	$rows | ? { $_.innerText -match "\S" -and $_.innerText -ne "|" } | select -ExpandProperty innerText
}