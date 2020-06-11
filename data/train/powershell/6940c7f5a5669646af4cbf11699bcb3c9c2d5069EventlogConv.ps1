# (参考）
# http://d.hatena.ne.jp/skRyo/20120625/1340599737
#

#ログファイルの出力先
$filetime = get-date -format yyyyMMddhhmmss
$file = "eventlog" + "_" + $filetime + ".txt"

#ホスト名
$hostname  = [Net.Dns]::GetHostName()


$LogNames = @("System","Application","Security")
$SortKeyName = "TimeGenerated"
Foreach ( $LogName in $LogNames ) {

	$logArray = Get-EventLog -logname $LogName | Where-Object { $_.TimeGenerated -gt (get-date).addhours(-24) } `
			|  Select-Object EntryType,EventID,Source,TimeGenerated,Message | Sort-Object $SortKeyName

	#取得したイベントログをファイルに書き込む---------------------
        foreach ($row in $logArray) {

            	#Messageに入っている改行コードを変換①
            	$LogMessage = [string]$row.Message.Replace("`r`n"," ")

                #Messageに入っている改行コードを変換②
          	    $LogMessage = $LogMessage.Replace("`n"," ")

            	#Messageに入っているカンマを変換
            	$LogMessage = $LogMessage.Replace(","," ")

		#日付の書式を整形
		$LogTimeGenerated = [string]$row.TimeGenerated.ToString("yyyy/MM/dd HH:ss:mm")

		#Logソース
		$LogSource =  [string]$row.Source

		#Logタイプ
		$LogType = [string]$row.EntryType

		#イベントＩＤ
		$LogEventID  = [string]$row.EventID
	  
		$line =  $LogTimeGenerated + "," + $hostname + "," + $LogName + "," + $LogEventID + "," + $LogSource + "," + $LogType + "," + $LogMessage

#	    	Write-Host $line

		#ファイルに書き込む
            	$line | Out-File -filepath $file  -Encoding default -Append

	}

}