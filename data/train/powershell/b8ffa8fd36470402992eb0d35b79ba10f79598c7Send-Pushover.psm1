# PoSH module for sending push notifications to Pushover notification service.

Function Send-Pushover
{
	param (
        [parameter(Mandatory=$true)][string]$message, # Message to be sent to client
        [parameter(Mandatory=$true)][string]$token = '[application token]', # Application token.
        [parameter(Mandatory=$true)][string]$user = '[user token]', # User token.
        [parameter(Mandatory=$true)][string]$title # optional title used by pushover notification
        
    ) # end parameters
   
    $uri = 'https://api.pushover.net/1/messages.json' # Pushover API address
    $parameters = @{ # Parameters to be sent to Pushover service for notification
        token = $token
        user = $user
        title = $title
        message = $message
   }
    $parameters | Invoke-RestMethod -Uri $uri -Method Post | Out-Null # Post rest method used to push $parameters to Pushover; Out-Null to remove all output
}
