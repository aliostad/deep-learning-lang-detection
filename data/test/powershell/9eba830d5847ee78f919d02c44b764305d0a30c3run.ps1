Function Invoke-RestAPI {
    param(
        [string]$User,
        [string]$Pwd,
        [string]$URL
        ) 

  #Create a URI instance since the HttpWebRequest.Create Method will escape the URL by default.
  $URI = New-Object System.Uri($URL,$true)
 
  #Create a request object using the URI
  $request = [System.Net.HttpWebRequest]::Create($URI)
 
  #Build up a nice User Agent
  $request.UserAgent = $UserAgent
 
  #Establish the credentials for the request
  $creds = New-Object System.Net.NetworkCredential($User,$Pwd)
  $request.Credentials = $creds
 
  $response = $request.GetResponse()
  $reader = [IO.StreamReader] $response.GetResponseStream()
  $respnseBody = $reader.ReadToEnd()
        
  $reader.Close()
  $response.Close()
  return $respnseBody
}

Function DumpProcInfo {
    param(
        [string]$procInfo
        ) 

        $procObj = ConvertFrom-Json $procInfo
        $content= $procObj.time_stamp + "`t" + $procObj.name + "`t" + $procObj.id + "`t" + $procObj.start_time + "`t" + $procObj.thread_count + "`t" + $procObj.handle_count + "`t" + $procObj.total_cpu_time + "`t" + $procObj.user_cpu_time + "`t" + $procObj.working_set + "`t" + $procObj.peak_working_set + "`t" + $procObj.private_memory + "`t" + $procObj.virtual_memory + "`t" + $procObj.peak_virtual_memory + "`t" + $procObj.paged_memory + "`t" + $procObj.peak_paged_memory + "`t" + $procObj.paged_system_memory + "`t" + $procObj.non_paged_system_memory
        Add-Content $logFile $content
}



$username = "your deploy user name"
$password = "your deploy password"

$sitename = $env:WEBSITE_SITE_NAME
#${sitename} = "wzhaotest"

$time = Get-date -Format "yyyymmdd-hhmmss"
$script:logFile = $env:HOME + "\LogFiles\" + $env:COMPUTERNAME + "-" + $sitename + "-" +  $time + ".log"

$content= "Time`t`t`t`t`tName`t`t`tID`t`tstart_time`t`t`t`t`t`tthread_count`thandle_count`t`ttotal_cpu_time`t`tuser_cpu_time`t`tworking_set`t`tpeak_working_set`t`tprivate_memory`t`tvirtual_memory`t`tpeak_virtual_memory`t`tpaged_memory`t`tpeak_paged_memory`t`tpaged_system_memory`t`tnon_paged_system_memory"
Add-Content $logFile $content

 while (1 -eq 1){
  $apiUrl = "https://${sitename}.scm.azurewebsites.net/api/processes"
  Write-Output $apiUrl

  $result = Invoke-RestAPI $username $password $apiUrl
  $procs = ConvertFrom-Json $result

 
 ForEach ($proc in $procs)
 {
    $wpid = $proc.Id
    Write-Output $proc.Name
    Write-Output $proc.Id

    $apiUrl = "https://${sitename}.scm.azurewebsites.net/api/processes/${wpid}"
    Write-Output $apiUrl

    $result = Invoke-RestAPI $username $password $apiUrl
    DumpProcInfo $result
 }
 sleep -Seconds 30
}