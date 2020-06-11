$architecture = "x64"
if ([IntPtr]::Size -eq 4)
{
	$architecture = "x86"
}

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$fullSqliteLibraryPath = $scriptDirectory + "\" + $architecture + "\System.Data.SQLite.dll"
[System.Reflection.Assembly]::LoadFrom($fullSqliteLibraryPath)

$configFilePath = $scriptDirectory + "\config.ps1"
. $configFilePath

$select = "SELECT d, m, y, SUM(sent) AS sent, SUM(recv) AS recv FROM traffic GROUP BY d, m, y"
$dataset = New-Object System.Data.DataSet
$dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($select, ("Data Source=" + $env:APPDATA + "\NetSpeedMonitor\data.db"))
$dataAdapter.Fill($dataset)

$minDate = (Get-Date).AddDays(-30)
ForEach($row In $dataset.Tables[0])
{
	$date = $row["y"].ToString() + "-" + $row["m"].ToString().PadLeft(2, '0') + "-" + $row["d"].ToString().PadLeft(2, '0')
	$in = $row["recv"].ToString()
	$out = $row["sent"].ToString()
	
	$dateParsed = [DateTime]::Parse($date)
	if ($dateParsed -ge $minDate -And $dateParsed -ne $minDate)
	{
		$apiRequestUrl = $LIHOCOS_URL + '/api/computers/add_traffic/' + $LIHOCOS_COMPUTER_ID + '/' + $date + '/' + $in + '/' + $out + '?api-key=' + $LIHOCOS_API_KEY;
		
		#Not using Invoke-WebRequest because Windows 7 is still here...
		#Invoke-WebRequest $apiRequestUrl
		$webClient = New-Object System.Net.WebClient
		$webClient.DownloadString($apiRequestUrl)
	}
}