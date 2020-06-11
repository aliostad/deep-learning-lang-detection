
$ScriptRunTime = (get-date).ToFileTime()

Get-Process | select -Unique | %{ 
	
    try
    {
        $Query = "Select CommandLine FROM WIN32_PROCESS WHERE NAME='{0}.exe'" -f $_.ProcessName
        $CommandLine = Get-wmiobject -Query $Query | select -expand CommandLine | select -first 1
    }
    catch
    {
    
    }
	if($CommandLIne)
	{
        $Message = 'Name="{0}" Product="{1}" ProductVersion="{2}" Path="{3}" CommandLine="{4}" ScriptRunTime="{5}"' -f $_.Name,$_.Product,$_.ProductVersion,$_.path,($CommandLine -replace '"',""),$ScriptRunTime
	}
    else
    {
        $Message = 'Name="{0}" Product="{1}" ProductVersion="{2}" Path="{3}" CommandLine="{4}" ScriptRunTime="{5}"' -f $_.Name,$_.Product,$_.ProductVersion,$_.path,([string]::empty),$ScriptRunTime
    }
	if($Message)
	{
		Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((get-date).ToUniversalTime()),( $Message ))
	}
    
}