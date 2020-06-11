
$services = 
(
	@{
		messageType 	= "rest"
		requestType 	= "post"
		endpoint 		= "/SessionService.svc/start?forceHttpStatusOk=1"
		requestMessage 	= "<sessionStartParameters username='$username' plainTextPassword='$password' uniqueConstraint='1' siteId='1' clientAppType='Web' clientAppName='Bingo.Flash'/>"
		
		validations = @(
			@{
				Function 
				{
					param ([object] $message)
					$message.response.session.id -ne $null
				}
			}
		)
			
		properties = @(
			username = ""
			password = ""
		)
		
	}
)