#written by Simon Watson
#Example only

#set TLS settings
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

#freshdesk tenant name
$tenant = 'contoso' 
#api endpoint
$api = "https://$tenant.freshdesk.com/api/v2/tickets"

#freshdesk credentials
$user = "email address/username"
$pass = "password"

#create auth header for basic auth
$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ 'Authorization' = $basicAuthValue}

#Freshdesk custom ticket fields
#Need to use Freshdesk API to get the ticket fields, as the names are different to what's shown in the web interface
#Invoke-WebRequest -Method get -Uri "https://$tenant.freshdesk.com/api/v2/ticket_fields?per_page=100" -Headers $headers -ContentType 'application/json'
$customFields = @{  'type' = "Fault";
                    'category' = "Server";
                    'item' = "Other";
                    }
            
#Freshdesk Default ticket fields
#Fields required will be based on Freshdesk policy configured for Agents when creating tickets (ie same when they manually create ticket in the web interface)
#responder_id is the agent to assign the ticket to
#group_id is the group in Freshdesk
#subject is the name of the ticket
#description is the contents of the ticket
$data = @{  'email'    = "example@contoso.com"; 
            'status'   = 2;
            'priority' = 1;
            'subject'  = "Test Ticket";
            'responder_id' = 8611765;
            'group_id' = 36372;
            'source'   = 2;
            'description'  = "test";
            'type'     = "OIA Monitoring";
            'custom_fields' = $customFields;
            }
#convert hash table to JSON
$json = $data | convertto-json


$results = Invoke-WebRequest -Method Post -Uri $api -Headers $headers -Body $json -ContentType 'application/json'
