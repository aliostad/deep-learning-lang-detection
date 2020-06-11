
#要写入的日志文件
$csvfile= Join-Path -path (Get-Location)  -childpath "ping.csv"

#要Ping的主机
$hostname= "192.168.1.164"

#最大次数 ，0表示无限制
$times=10

#间隔时间
$sleeptime=5




function WriteLine {
	param(
		[Parameter(Position=0)]
		$message
	)

	$s="$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"),$message"
	
	Write-Host $s 
	Out-File -FilePath $logfile -Append  -Encoding "UTF8" -InputObject  $s 
}



$index=0

do
{
    $pinger= New-Object -TypeName 'System.Net.NetworkInformation.Ping'
		

    try
    {
        $pr=$pinger.Send($hostname)

        WriteLine "$($pr.Status),$($pr.Address.ToString()),$($pr.RoundtripTime)"
	
    }
    catch  [System.Exception]
    {
        $ErrorMessage = $_.Exception.Message
        WriteLine "发生异常: $ErrorMessage"
    }
    finally
    {
        
    }

    sleep -Seconds $sleeptime

    $index +=1
}
until (($times -gt 0 ) -and ( $index -gt $times ))


