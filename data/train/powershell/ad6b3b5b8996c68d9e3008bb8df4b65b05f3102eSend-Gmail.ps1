## Send-Gmail.ps1 - Send a gmail message
## By Rodney Fisk - xizdaqrian@gmail.com
## 2 / 13 / 2011

# Get command line arguments to fill in the fields
# Must be the first statement in the script
param(
    [Parameter(Mandatory = $true,
                    Position = 0,
                    ValueFromPipelineByPropertyName = $true)]
    [Alias('From')] # This is the name of the parameter e.g. -From user@mail.com
    [String]$EmailFrom, # This is the value [Don't forget the comma at the end!]

    [Parameter(Mandatory = $true,
                    Position = 1,
                    ValueFromPipelineByPropertyName = $true)]
    [Alias('To')]
    [String[]]$Arry_EmailTo,

    [Parameter(Mandatory = $true,
                    Position = 2,
                    ValueFromPipelineByPropertyName = $true)]
    [Alias( 'Subj' )]
    [String]$EmailSubj,

    [Parameter(Mandatory = $true,
                    Position = 3,
                    ValueFromPipelineByPropertyName = $true)]
    [Alias( 'Body' )]
    [String]$EmailBody,

    [Parameter(Mandatory = $false,
                    Position = 4,
                    ValueFromPipelineByPropertyName = $true)]
    [Alias( 'Attachment' )]
    [String[]]$Arry_EmailAttachments

)

# From Christian @ StackOverflow.com
$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SMTPClient( $SmtpServer, 587 )  
$SMTPClient.EnableSSL = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( "", "" ); 

# From Core @ StackOverflow.com
$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = $EmailFrom
foreach ( $recipient in $Arry_EmailTo )
{
    $emailMessage.To.Add( $recipient )
}
$emailMessage.Subject = $EmailSubj
$emailMessage.Body = $EmailBody
# Do we have any attachments?
# If yes, then add them, if not, do nothing
if ( $Arry_EmailAttachments.Count -ne $NULL ) 
{
    $emailMessage.Attachments.Add()
}
$SMTPClient.Send( $emailMessage )