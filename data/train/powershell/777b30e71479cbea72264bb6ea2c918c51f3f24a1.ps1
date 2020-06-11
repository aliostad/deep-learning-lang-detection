. ./settings.ps1
. ./common.ps1

$message_bus_assembly = $null


function Push-AzureMessageTopic {
    param(
        [Parameter(Mandatory=$true)]
        $obj
    )
    if(-not $message_bus_assembly){
        $message_bus_assembly = Load-MessageBusAssembly
    }
    
    $credentials = [Microsoft.ServiceBus.TokenProvider]::CreateSharedSecretTokenProvider($settings_name, $settings_key);
    $address = [Microsoft.ServiceBus.ServiceBusEnvironment]::CreateServiceUri('sb', $settings_namespace, "")
    $message_factory = [Microsoft.ServiceBus.Messaging.MessagingFactory]::Create($address, $credentials)
    $topic = $message_factory.CreateTopicClient($settings_topic)

    $message_body = [string]$obj
    $args = [System.IO.Stream] (new-object System.IO.MemoryStream -ArgumentList (, [System.Text.Encoding]::UTF8.GetBytes($message_body)))
    $message = new-object Microsoft.ServiceBus.Messaging.BrokeredMessage -ArgumentList ($args, $true)
    $message.ContentType = "text/plain"

    $topic.Send($message)
} 

# Get-Content .\text-file.txt | % { Push-AzureMessageTopic $_ }

# Este aqui não funciona
# Get-Content .\text-file.txt | Push-AzureMessageTopic