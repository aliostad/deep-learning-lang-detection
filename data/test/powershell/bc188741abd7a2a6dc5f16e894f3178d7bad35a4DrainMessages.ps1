function EncodeCredentials($username, $password) {
    $credentials = "$($username):$($password)"
    return [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credentials));
}

function Get-Request($url, $username, $password) {
    $encodedCredentials = EncodeCredentials $username $password
    $Headers = @{ Authorization = "Basic $encodedCredentials" }
    $response = Invoke-WebRequest -Uri $url -Headers $Headers
    return $response.Content
}

function Post-Request($url, $username, $password, $body) {
    $encodedCredentials = EncodeCredentials $username $password
    $Headers = @{ Authorization = "Basic $encodedCredentials" }
    $response = Invoke-WebRequest -Uri $url -Headers $Headers -Body $body -Method POST
    return $response.Content
}

function Get-Message-Count($queueName) {
    $queueDetailsUrl = "http://$($broker):15672/api/queues/%2f/$queueName"
    $queueDetails = Get-Request $queueDetailsUrl $username $password | ConvertFrom-Json
    return $queueDetails.messages
}

function Get-Messages($queueName) {
    $queueMessagesUrl = "http://$($broker):15672/api/queues/%2f/$queueName/get"
    $body =  @{ count = $messageCount; requeue = "false"; encoding = "auto" } | ConvertTo-Json
    $queueMessages = Post-Request $queueMessagesUrl $username $password $body
    return $queueMessages | ConvertFrom-Json
}

function Publish-Message($exchangeName, $routingKey, $payload) {
    $messagePublishUrl = "http://$($broker):15672/api/exchanges/%2f/$exchangeName/publish"
    $body = @{ properties = @{}; routing_key = $routingKey; payload = $payload; payload_encoding = "string" } | ConvertTo-Json
    $publishResponse = Post-Request $messagePublishUrl $username $password $body
    return $publishResponse | ConvertFrom-Json
}

$configFile = "C:\Projects\mck\DrainMessages.xml"    # input
[xml]$configuration = Get-Content $configFile
$broker = $configuration.configuration.broker
$username = $configuration.configuration.username
$password = $configuration.configuration.password
$exchangeName = $configuration.configuration.exchangeName
$queueName = $configuration.configuration.queueName

$messages = Get-Messages $queueName
Write-Output "Found $($messages.Count) messages in the queue $queueName"

foreach ($message in $messages) {
    $routingKey = $message.routing_key
    $payload = $message.payload
    $response = Publish-Message $exchangeName $routingKey $payload
    if ($response.routed) {
        Write-Output "Published a message with routing key: $routingKey and payload: $payload"
    } else {
        Write-Error "Failed to publish a message with routing key: $routingKey and payload: $payload"
    }
}
