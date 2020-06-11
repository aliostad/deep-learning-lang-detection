###
#
# Author
#             Navid Azimi (nazimi)
#
# Send Mail
#             This script sends an arbitrary email from the current logged on user
#             provided their account supports sending email. For more information,
#             please see: http://infoplus30/getdocument.aspx?documentid=d07-ze
#
# Params
#             $to                         list of email recipients
#             $subject               the subject of the email message
#             $body                   the content of the email
#             $text                     if present, indicates this is a plain-text message (not HTML)
#             $whatif                 if present, does not send the email but outputs 
#
###

param([string] $to = $(throw "You must specify at least one recipient."), [string] $subject, [string] $body, [switch] $text, [switch] $whatIf);

$private:from = "$env:USERNAME@microsoft.com";
$private:smtp = "smtphost.redmond.corp.microsoft.com";

## create an empty mail message
$private:message = new-object Net.Mail.MailMessage;

## if we fail to send this message, notify the sender
$message.DeliveryNotificationOptions = [Net.Mail.DeliveryNotificationOptions]::OnFailure;

## split the to line based on spaces, commas or semi-colons
$addresses = $to.Split(' ,;');

## iterate through all the recipients and add them to the TO line
foreach($address in $addresses)
{
    $message.To.Add($address);
}

## set the message from the current logged on user
$message.From = new-object Net.Mail.MailAddress($from);

## set the subject of the email
$message.Subject = $subject;

## set the body of the email
$message.Body = $body;

## set the body type
$message.IsBodyHtml = (-not $text);

## prepare the SMTP client information
$private:smtpClient = new-object Net.Mail.SmtpClient($smtp);

## ensure we use our AD credentials for authentication
$smtpClient.UseDefaultCredentials = $true;

## set the delivery method to network send
$smtpClient.DeliveryMethod = [Net.Mail.SmtpDeliveryMethod]::Network;

if($whatIf)
{
    ## just show us the settings
    $message
    $smtpClient
}
else
{
    ## send the message!
    $smtpClient.Send($message);
}
