$DEPLOYMENT=""  # Deployment to add Server Array to
$ST=""          # Set the ServerTemplate the Server Array will be based on
$CLOUD=""            # Specify the Cloud to add the Server Array to
$ITYPE=""             # Set the Instance Type for this Sever Array, this cloud, ...

$postURL = "https://my.rightscale.com/api/server_arrays"
$stringToPost = "server_array[name]=my_array_server&"+
"server_array[description]=my_app_server_description&"+
"server_array[deployment_href]=/api/deployments/$DEPLOYMENT&"+
"server_array[array_type]=alert&"+
"server_array[state]=disabled&"+
"server_array[instance][server_template_href]=/api/server_templates/$ST&"+
"server_array[instance][cloud_href]=/api/clouds/$CLOUD&"+
"server_array[elasticity_params][alert_specific_params][decision_threshold]=51&"+
"server_array[elasticity_params][bounds][min_count]=2&"+
"server_array[elasticity_params][bounds][max_count]=3&"+
"server_array[elasticity_params][pacing][resize_calm_time]=5&"+
"server_array[elasticity_params][pacing][resize_down_by]=1&"+
"server_array[elasticity_params][pacing][resize_up_by]=1"
$bytesToPost = [System.Text.Encoding]::UTF8.GetBytes($stringToPost)

$webRequest = [System.Net.WebRequest]::Create($postURL)
$webRequest.Method = "POST"
$webRequest.Headers.Add("X_API_VERSION","1.5")
$webRequest.CookieContainer = $cookieContainer # recieved from authentication.ps1

$requestStream = $webRequest.GetRequestStream()
$requestStream.Write($bytesToPost, 0, $bytesToPost.Length)
$requestStream.Close()

[System.Net.WebResponse]$response = $webRequest.GetResponse()
$responseStream = $response.GetResponseStream()
$responseStreamReader = New-Object System.IO.StreamReader -ArgumentList $responseStream
[string]$responseString = $responseStreamReader.ReadToEnd()

$responseString