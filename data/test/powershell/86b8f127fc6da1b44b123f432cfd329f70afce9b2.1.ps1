. ./settings.ps1
. ./common.ps1

$message_bus_assembly = $null


function Push-AzureMessageTopic {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]
        $message_body)
    Begin {
        if(-not $message_bus_assembly){
            $message_bus_assembly = Load-MessageBusAssembly
        }
        $credentials = [Microsoft.ServiceBus.TokenProvider]::CreateSharedSecretTokenProvider($settings_name, $settings_key);
        $address = [Microsoft.ServiceBus.ServiceBusEnvironment]::CreateServiceUri('sb', $settings_namespace, "")
        $message_factory = [Microsoft.ServiceBus.Messaging.MessagingFactory]::Create($address, $credentials)
        $topic = $message_factory.CreateTopicClient($settings_topic)

        $i = 0;
    } 

    Process {
        
        $args = [System.IO.Stream] (new-object System.IO.MemoryStream -ArgumentList (, [System.Text.Encoding]::UTF8.GetBytes($message_body)))
        $message = new-object Microsoft.ServiceBus.Messaging.BrokeredMessage -ArgumentList ($args, $true)
        $message.ContentType = "text/plain"
        $message.Properties["MessageNumber"] = $i;

        $topic.Send($message)
        $i += 1
    } 

    End {
        
    } 
} 

# Get-Content .\text-file.txt | Push-AzureMessageTopic