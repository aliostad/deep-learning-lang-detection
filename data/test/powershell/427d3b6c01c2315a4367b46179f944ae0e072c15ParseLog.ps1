param([string]$LogName = ".", [string]$DateFormat, [string]$MatchText, [Boolean]$ShouldMatch = $true, [string]$Tag, [string]$Name, [boolean]$OnlyNewLines = $true, [int]$SleepMinutes = 5)

function FindMonitor([string] $name) {
  foreach ($node in $monitors.monitors.childnodes) {
    if ($node.name -eq $name) {
	  return $node.id
	}
  }
}

function ShowMsg($msg) {
  $msg = (Get-Date).ToString("yyyyMMdd HH:mm:ss") + " " + $msg
  Write-Host $msg
}

function AddResult() {
  $apiKey = "3TE4K9JAJICQDKRANI3IPTBLQK"
  $secretKey = "5CK8P2176A21Q9ARDDRGUJSAK"

  #Requesting token
  $url = "http://www.monitis.com/api?action=authToken&apikey=" + $apiKey + "&secretkey=" + $secretKey
  $wc = new-object net.webclient
  $resp = $wc.DownloadString($url).ToString()
  $pos = $resp.IndexOf(":") + 2
  $token = $resp.Substring($pos, $resp.Length - $pos - 2)

  #Requests the monitor list in order to find the MonitorID
  $url = 'http://www.monitis.com/customMonitorApi?action=getMonitors&apikey=' + $apiKey + "&tag=" + $Tag + "&output=xml"
  $wc = new-object net.webclient
  $resp = $wc.DownloadString($url).ToString()

  $monitors = new-object "System.Xml.XmlDocument"
  $monitors.LoadXml($resp)

  $monitorID = FindMonitor $Name
  $results = "match:" + $matchRes + ";"

  $nvc = new-object System.Collections.Specialized.NameValueCollection
  $nvc.Add('apikey', $apikey)
  $nvc.Add('validation', 'token')
  $nvc.Add('authToken', $token)
  $nvc.Add('timestamp', ((get-date).touniversaltime().ToString("yyyy-MM-dd HH:mm:ss").ToString()))
  $nvc.Add('action', 'addResult')
  $nvc.Add('monitorId', $monitorID)
  $nvc.Add('checktime', ([int][double]::Parse((get-date((get-date).touniversaltime()) -UFormat %s))).ToString() + '000')
  $nvc.Add('results', $results)

  $wc = new-object net.webclient
  $wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
  $resp = $wc.UploadValues('http://www.monitis.com/customMonitorApi', $nvc)
  ShowMsg ([text.encoding]::ascii.getstring($resp))
}

$prevFile = ""
$linesProc = 0 
$dfre = [regex]("(?<date>" +  ($DateFormat -replace "\w", "\d") +")")
ShowMsg "Starting"
while ($true) {
  $files = @(Get-ChildItem $LogName | Sort-Object LastWriteTime -descending)
  $fileName = $files[0].FullName
  ShowMsg ("Parsing file:" + $fileName )
  
  if ($prevFile -ne "") {
    if ($fileName -ne $prevFile) {
	  $linesProc = 0
	  ShowMsg ("Log file name changed, parsing from start")
    }
	if ((Get-ChildItem $fileName).length -lt $prevSize) {
	  $linesProc = 0
	  ShowMsg ("Log file size changed, parsing from start")
	}
  }
  $prevFile = $fileName
  $prevSize = (Get-ChildItem $fileName).length
  
  $matchRes = 0;
  $file = [System.io.File]::Open($fileName, 'Open', 'Read', 'ReadWrite')
  $file = New-Object System.IO.StreamReader($file)
  
  if ($OnlyNewLines -eq $true) {
    ShowMsg "Skipping to end of file"
    while (-not $file.EndOfStream) {
	  $line = $file.ReadLine()
	  $linesProc++
	}
    $OnlyNewLines = $false;
  } else {
    ShowMsg ("Skipping " + $linesProc + " lines")
    for ($l=1; $l -le $linesProc; $l++) {
	  $line = $file.ReadLine()
	}
  }

  $newLines = 0
  if ($file.EndOfStream) {
    Showmsg	"At end of file"
  } else {
    ShowMsg ("Parsing file")
  }
  while (-not $file.EndOfStream) {
    $line = $file.ReadLine()
	$newLines++
    try {
      if ($line -match $MatchText) {
        $matchRes = 1;
        Write-Host $line
        if ($ShouldMatch -eq $true) {
          break;
        }
      }
    }
    catch {
    }
  }
  $file.close()
  if ($ShouldMatch -eq $false) {
    if ($matchRes -eq 0) {
      $matchRes = 1;
    } else {
      $matchRes = 0;
    }
  }
  ShowMsg ("New lines processed: " + $newLines + ", sleeping " + $SleepMinutes + " minutes")
  $linesProc = $linesProc + $newLines

  ShowMsg ("Result: " + $matchRes)
  AddResult
  
  Start-Sleep -s ($SleepMinutes * 60)
}
