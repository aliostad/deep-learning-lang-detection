
function Send-MailgunEmail($from, $to, $subject, $body, $emaildomain, $apikey) {
    $idpass = "api:$apikey"
    $basicauth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($idpass))
    $headers = @{
        Authorization = "Basic $basicauth"
    }
    $url = "https://api.mailgun.net/v3/$emaildomain/messages"
    $body = @{
        from = $from;
        to = $to;
        subject = $subject;
        text = $body;
    }
    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
}
