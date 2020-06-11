## Create checks in uptime using API 
$file = Import-Csv C:\last.csv
$yourAuth = "Basic xxxxxxxxxxxx"
$uptimeUrl = "rdh url"
foreach ($row in $file)
{
    $st=$row.Environment
    $name=$row.Name
    $app=$row.PoolMemberName
    $url=$row.Url

    $Body = @{
        "url"="$url";
        "name"="$name $app"; 
        "interval"= "60";
        "maxTime"="1500";
        "alertTreshold"="2";
        "type"="http";
        "tags"="$st"
        } | ConvertTo-Json

Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks" -ContentType application/json -Method PUT -Body $Body -Headers @{"Authorization"="$yourAuth"}
}

#### Delete checks in uptime using API
$tests = Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks" -ContentType application/json -Method GET -Headers @{"Authorization"="$yourAuth="}
foreach ($test in $tests)
{
    $ref = $test._id
    Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks/$ref" -Method DELETE -Headers @{"Authorization"="$yourAuth"}
}

##### Delete checks that are currently down using API
$tests = Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks" -ContentType application/json -Method GET -Headers @{"Authorization"="$yourAuth"}
foreach ($test in $tests)
{
    $ref = $test._id
    if ($test.downtime -gt 0)
    {
        Write-Host $test
        Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks/$ref" -Method DELETE -Headers @{"Authorization"="$yourAuth"}
    }
    #Invoke-RestMethod -Uri "http://$uptimeUrl/api/checks/$ref" -Method DELETE -Headers @{"Authorization"="$yourAuth"}
}
