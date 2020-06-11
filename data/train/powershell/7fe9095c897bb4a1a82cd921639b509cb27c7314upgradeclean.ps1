<#
	Permite limpar diretórios de upgrade!
#>

[CmdLetBinding()]
param($CopyPaths = $null)


#Diretórios que não devem ser copiados (contém dados do usuário)
$ErrorActionPreference="Stop";


$CurrentFile = $MyInvocation.MyCommand.Definition
$CurrentDir  = [System.Io.Path]::GetDirectoryName($CurrentFile)
$BaseDir	 = [System.Io.Path]::GetDirectoryName($CurrentDir);

#Libs do componente de install. Note que estas libs são diferentes.
	$LibsDir = $BaseDir + "\core\glibs"

#Se não consegue encontrar o diretorio de libs...
	if(![System.IO.Directory]::Exists($LibsDir)){
		throw "LIB_DIR_NOT_FOUND: $LibsDir"
	}

#Carrega as libs 
	$OriginalDebugMode = $DebugMode;
	try {
		$LoadLib = $LibsDir + '\LoadLibs.ps1';
		. $LoadLib $BaseDir 
	} catch {
		$ex = New-Object Exception("LIB_LOAD_FAILED", $_.Exception)
		throw $ex;
	}
	$DebugMode = $OriginalDebugMode;
	
	
	
if([IO.File]::Exists($CopyPaths)){
	$CopyPaths = Get-Content $CopyPaths;
}
	
$CopyPaths | %{
	$PathID++;
	$CurrentPath = $_;
	$CorePath = $_ + '\core'
	write-host "Checking $CurrentPath..."
	
	if([System.IO.Directory]::Exists($CorePath)){
		UpgradeDirReport $CurrentPath
	} else {
		write-host "Parece não ser um diretório com arquivos do pszbx!"
	}
}