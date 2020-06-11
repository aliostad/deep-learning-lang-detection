$Global:programList = $null;

function ParseCmd($params)
{
	LoadStartupPrograms;
	
	foreach ($p in $Global:programList)
	{
		$procesExists = ps $p -ErrorAction SilentlyContinue;
		if($procesExists)
		{ write-host "$p is running" -foregroundcolor "green"; }
		else
		{
			write-host "$p is not running" -foregroundcolor "red";
			StartProgram $p;
		}
	}
}

function StartProgram($program)
{
	write-host "    Starting Up $program ...";
	switch($program)
	{
		"chrome" { & "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"; }
		"devenv" { & "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"; }
		"lync" { & "C:\Program Files (x86)\Microsoft Office\Office15\lync.exe"; }
		"notepad++" { & "C:\Program Files (x86)\Notepad++\notepad++.exe"; }
		"OUTLOOK" { & "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE"; }
		"Ssms" { & "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe"; }
		default { write-host "    Could not find startup program" -foregroundcolor "red"; } 
	}
}

function LoadStartupPrograms()
{
	#List of programs to startup
	$Global:programList = @("chrome","devenv","lync","notepad++","OUTLOOK","Ssms");
}

ParseCmd $args;