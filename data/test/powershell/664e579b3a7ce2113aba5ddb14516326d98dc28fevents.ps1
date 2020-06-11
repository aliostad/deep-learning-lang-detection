$commons = Join-Path (Get-ScriptDirectory) "common.ps1"
. $commons

Import-Module activedirectory

<#
.SYNOPSIS
	.
.DESCRIPTION
	Выводит сведения о событиях журнала Security.
.EXAMPLE
	Get-EventLogInfo -id 4624 -ws  "*WIN*"
	Возвращает события успешного входа на рабочих станциях, содержащих в названии "WIN"
.EXAMPLE
	Get-EventLogInfo -id 4776 -after "5/15/2012" -before "5/17/2012"
	Возвращает все попытки входа в промежутке между 15.05.2012 и 17.05.2012
.EXAMPLE
	Get-EventLogInfo -id 4776 -td "1"
	Возвращает события с id 4776 за прошедшие сутки
.NOTES
	.
#>
function Get-EventLogInfo{
	param(
		[Parameter(HelpMessage="Имя компьютера из свойств события")]
		[Alias("pc")]
		[string]
		$computerName,
		[Parameter(HelpMessage="Имя пользователя из свойств события")]
		[Alias("u")]
		[string]
		$userName,
		[Alias("after")]
		[datetime]
		$startDate,
		[Alias("before")]
		[datetime]
		$endDate,
		[Parameter(HelpMessage="Разница между начальной (конечной) датой, если одна из них задана, или между текущей датой и начальной, если начальная и конечная даты не заданы, игнорируется, если одновременно заданы startDate и endDate")]
		[Alias("td")]
		[timespan]   
		$timedelta,
		[Parameter(HelpMessage="Event Id (см. http://www.windowsecurity.com/articles/event-ids-windows-server-2008-vista-revealed.html)")]
		[Alias("id")]
		[Int]
		$eventId = 0,
		[Parameter(HelpMessage="Имя рабочей станции из описания события")]
		[Alias("ws")]
		[string]
		$workstation
	)
	$str = "Get-EventLog security"
	if ($computerName -ne ""){
		$str = "$str -ComputerName $computerName"
	}
	if ($userName -ne ""){
		$str = "$str -UserName $userName"
	}
	if ($timedelta -ne $null){
		$startDate, $endDate = Change-Dates $timedelta $startDate $endDate
	}
	if ($startDate -ne $null){
		$str = "$str -after {0}" -f ($startDate.ToShortDateString())
	}
	if ($endDate -ne $null){
		$str = "$str -before {0}" -f ($endDate.ToShortDateString())
	}
	$events = invoke-expression $str
	if ($eventId -ne 0){
		$events = $events | ? {$_.eventid -eq $eventId }
	}

	$Data = New-Object System.Management.Automation.PSObject
	$Data | Add-Member NoteProperty Time ($null)
	$Data | Add-Member NoteProperty UserName ($null)
	$Data | Add-Member NoteProperty ComputerName ($null)
	$Data | Add-Member NoteProperty Workstation ($null)
	$Data | Add-Member NoteProperty Address ($null)
	$Data | Add-Member NoteProperty ErrorCode ($null)
	$Data | Add-Member NoteProperty EventId ($null)
		
	$events | %{

		$Data.Time = $_.TimeGenerated

		if ($_.message -ne $null){
			$message = $_.message.split("`n") | %{$_.trimstart()} | %{$_.trimend()}
		}
		else {
			$message = ""
		}

		$Data.UserName = ($message | ? {[regex]::matches($_ , "(Имя учетной записи|Учетная запись входа):*")} | %{$_ -replace "^.+:."} )
		$Data.Address = ($message | ? {$_ -like "Адрес сети источника:*"} | %{$_ -replace "^.+:."})
		$Data.Workstation = ($message | ?{$_ -like "*станци?:*"} | %{$_ -replace "^.+:."})
		$Data.ErrorCode = ($message | ?{$_ -like "Код ошибки:*"} | %{$_ -replace "^.+:."})
		$Data.EventId = $_.eventid
		$Data
	} | ? { ($workstation -eq "") -or ($Data.Workstation -like $workstation)}
}