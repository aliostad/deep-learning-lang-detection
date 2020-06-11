function LoadSqlSnapIn {
	if ( (Get-PSSnapin -Name sqlserverprovidersnapin100 -ErrorAction SilentlyContinue) -eq $null )
	{
		Add-PsSnapin sqlserverprovidersnapin100
	}
	if ( (Get-PSSnapin -Name sqlservercmdletsnapin100 -ErrorAction SilentlyContinue) -eq $null )
	{
		Add-PsSnapin sqlservercmdletsnapin100
	}
}