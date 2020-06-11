$botkey = ""

$getMeLink = "https://api.telegram.org/bot$botkey/getMe"
$sendMessageLink = "https://api.telegram.org/bot$botkey/sendMessage"
$forwardMessageLink = "https://api.telegram.org/bot$botkey/forwardMessage"
$sendPhotoLink = "https://api.telegram.org/bot$botkey/sendPhoto"
$sendAudioLink = "https://api.telegram.org/bot$botkey/sendAudio"
$sendDocumentLink = "https://api.telegram.org/bot$botkey/sendDocument"
$sendStickerLink = "https://api.telegram.org/bot$botkey/sendSticker"
$sendVideoLink = "https://api.telegram.org/bot$botkey/sendVideo"
$sendLocationLink = "https://api.telegram.org/bot$botkey/sendLocation"
$sendChatActionLink = "https://api.telegram.org/bot$botkey/sendChatAction"
$getUserProfilePhotosLink = "https://api.telegram.org/bot$botkey/getUserProfilePhotos"
$getUpdatesLink = "https://api.telegram.org/bot$botkey/getUpdates"
$setWebhookLink = "https://api.telegram.org/bot$botkey/setWebhook"

$offset = 0
write-host $botkey

while($true) {
	$json = Invoke-WebRequest -Uri $getUpdatesLink -Body @{offset=$offset} | ConvertFrom-Json
	Write-Host $json
	Write-Host $json.ok
	$l = $json.result.length
	$i = 0
	Write-Host $json.result
	Write-Host $json.result.length
	while ($i -lt $l) {
		$offset = $json.result[$i].update_id + 1
		Write-Host "New offset: $offset"
		Write-Host $json.result[$i].message
		$i++
	}
	Start-Sleep -s 2
}
