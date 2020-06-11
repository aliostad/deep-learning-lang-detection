#
# Check this: https://github.com/mariuszwojcik/RabbitMQTools
#
Write-Host "CheckOrConfigureRabbitMQ..."

$secpasswd = ConvertTo-SecureString 'guest' -AsPlainText -Force
$credGuest = New-Object System.Management.Automation.PSCredential ('guest', $secpasswd)

Write-Host "Create virtual host 'selkie' in RabbitMQ..."
$vhost = try 
{ 
    Invoke-RestMethod 'http://localhost:15672/api/vhosts/selkie' -credential $credGuest -Method Get 
} 
catch 
{ 
    #$_.Exception.Response 
    $body = @{
    } | ConvertTo-Json

    Invoke-RestMethod 'http://localhost:15672/api/vhosts/selkie' -credential $credGuest -Method Put -ContentType "application/json" -Body $body
}

Write-Host -ForegroundColor Green "...created VirtualHost '" $vhost.name "'!"

Write-Host "Create 'selkie' user..."

$userSelkie = 
try
{ 
    Invoke-RestMethod 'http://localhost:15672/api/users/selkie' -credential $credGuest  -Method Get -ContentType "application/json"
} 
catch 
{ 
    #$_.Exception.Response 
    $body = @{
               'password' = 'selkie'
               'tags' = ''
           } | ConvertTo-Json


    Invoke-RestMethod 'http://localhost:15672/api/users/selkie' -credential $credGuest  -Method Put -ContentType "application/json" -Body $body 
}

Write-Host -ForegroundColor Green "... created user '" $userSelkie.name "'!"

Write "Update permissions for user 'selkie'..."

$permissions = 
try
{ 

    $body = 
        @{
            'configure' = '.*'
            'write' = '.*'
            'read' = '.*'
        } | ConvertTo-Json

    Invoke-RestMethod 'http://localhost:15672/api/permissions/selkie/selkie' -credential $credGuest  -Method Put -ContentType "application/json" -Body $body
} 
catch 
{ 
    $_.Exception.Response 
}

Write-Host -ForegroundColor Green "...updated permissions for user!"

Write-Host "Create 'selkieAdmin' user..."

$userSelkie = 
try
{ 
    Invoke-RestMethod 'http://localhost:15672/api/users/selkieAdmin' -credential $credGuest  -Method Get -ContentType "application/json"
} 
catch 
{ 
    #$_.Exception.Response 
    $body = @{
               'password' = 'selkieAdmin'
               'tags' = 'administrator'
           } | ConvertTo-Json


    Invoke-RestMethod 'http://localhost:15672/api/users/selkieAdmin' -credential $credGuest  -Method Put -ContentType "application/json" -Body $body 
}

Write-Host -ForegroundColor Green "... created user '" $userSelkie.name "'!"

Write "Update permissions for user 'selkieAdmin'..."

$permissions = 
try
{ 

    $body = 
        @{
            'configure' = '.*'
            'write' = '.*'
            'read' = '.*'
        } | ConvertTo-Json

    Invoke-RestMethod 'http://localhost:15672/api/permissions/selkie/selkieAdmin' -credential $credGuest  -Method Put -ContentType "application/json" -Body $body
} 
catch 
{ 
    $_.Exception.Response 
}

Write-Host -ForegroundColor Green "...updated permissions for user!"

