#
# 
# Created By AMakhn voodoo.slim@gmail.com
# BitBucket   https://bitbucket.org/metallsmell/
# GitHub      https://github.com/metalicsmell
#
#

########## Variables #########
#TelegramToken Here
$token = '_some_token_'
$global:message_offset=0

########## Functions #########
function processUpdates ($updates) {
		foreach ($update in $updates) {
				$global:message_offset = $update.update_id
				if ($update.message.text -eq 'test') {
					$text = 'It is you just sent me test request?'

					sendMessage $update.message.chat.id $text
						}
				}

			}
function getUpdates ($offset) {
	$response = execute("getUpdates?offset=$offset")
	if ($response.ok -eq $true) {
		if ($response.result.Count -ne 0) {
			return $response.result
		} else {
			return 0
		}
	}
}
function sendMessage ([string]$chat_id, [string]$text) {
	
	$response = execute("sendMessage?chat_id=$chat_id&text=$text")
	$response.ok #return $response.ok
}
function execute ($action) {
	$siteURL="https://api.telegram.org/bot$token/$action"
	$result = Invoke-WebRequest -URI $siteURL
	return $result.Content | ConvertFrom-Json
}


########## Main #########
do {
	$updates = getUpdates($global:message_offset+1)

	if ($updates -ne 0) {
		processUpdates($updates)
		Start-Sleep -s 5
	} else {
		Start-Sleep -s 10
	}
} until ($stop -eq 0)