
#call the api to mark the vm as ready for capture
#start the preparation process

$apiCallback = $args[0]
#write-host $apiCallback

'You are starting the Capture process for this VM.'
$userChoice = read-host 'If you are sure you want to capture the VM now, please type "Y" if not please type "N"'

if ($userChoice -eq 'Y')
{
	"Starting the Capture process. The VM will shut down shortly and you'll receive and email when the image is ready."

	Invoke-RestMethod "$apiCallback"

	#Invoke-Expression "$env:windir\system32\sysprep\sysprep /oobe /generalize /shutdown /quiet /quit"

	Invoke-Expression "$env:windir\system32\sysprep\sysprep /oobe /generalize /shutdown"
}