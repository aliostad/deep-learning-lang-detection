<#
.SYNOPSIS

Script to send a .eml file using an API call to Mandrill

.DESCRIPTION

Reads the file specified in filename, sends it.  The file needs to be a valid email file.

.PARAMETER filename

Filename of a file that contains legal mime suitable for sending, e.g. an .eml file

.PARAMETER key

Mandrill API key for authentication

#>

[CmdletBinding() ]
param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string]$filename,

    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string]$key

    
)

BEGIN {}
PROCESS {
	$r = @{"key"= $key ,
	       "raw_message" = (Get-Content $filename -Raw) 
	      }
        $output = Invoke-RestMethod -Uri https://mandrillapp.com/api/1.0/messages/send-raw.json -Body $r -Method Post
        if ($output.status -ne "sent") {
          # Sending failed
          throw "Error sending message - " + $Output.reject_reason
        }
} 
END {}
