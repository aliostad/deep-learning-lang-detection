function NewRelicTagAppDeployment($apiKey, $appId, $appName, $description, $revision, $changeLog, $user) {
    $postData = New-Object -TypeName "System.Collections.Generic.Dictionary[string, string]"
    if(!([string]::IsNullOrEmpty($appId))) {
        $postData.Add("deployment[application_id]", $appId)
    }
    if(!([string]::IsNullOrEmpty($appName))) {
        $postData.Add("deployment[app_name]", $appName)
    }
    if(!([string]::IsNullOrEmpty($description))) {
        $postData.Add("deployment[description]", $description)
    }
    if(!([string]::IsNullOrEmpty($revision))) {
        $postData.Add("deployment[revision]", $revision)
    }
    if(!([string]::IsNullOrEmpty($changeLog))) {
        $postData.Add("deployment[changelog]", $changeLog)
    }
    if(!([string]::IsNullOrEmpty($user))) {
        $postData.Add("deployment[user]", $user)
    }
    
    Invoke-WebRequest -Uri https://api.newrelic.com/deployments.xml -Headers @{"x-api-key"="$apiKey";} -Method Post -ContentType "application/x-www-form-urlencoded" -Body $postData > $null
}