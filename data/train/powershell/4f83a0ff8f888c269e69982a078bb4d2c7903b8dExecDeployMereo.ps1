. .\LoadConfig

$LogFile = $psscriptroot + "\logDeploy.txt"

Invoke-BatchFile "%VS100COMNTOOLS%\vsvars32.bat"

if(!$appSettings) 
{ 
	LogWrite "carregando configurações"
	LogWrite "-------------------------------------------"
	Write "carregando configurações"
	LoadConfig .\app.config
}

LogWrite "carregando comandos visual studio"
Write "carregando comandos visual studio"
return;

Invoke-BatchFile $appSettings['PATHVSCOMMANDLINE'] $appSettings['VAR1VSCOMMANDLINE'] 

$LASTEXITCODE = 0;

write-warning "Recuperando o source do TFS"
.\TFGetWorkSpace

if($LASTEXITCODE -ne 0)
{
	write-error "Ocorreu um erro ao recuperar os arquivos do TFS (TFGetWorkSpace.ps1)"
	return
}

