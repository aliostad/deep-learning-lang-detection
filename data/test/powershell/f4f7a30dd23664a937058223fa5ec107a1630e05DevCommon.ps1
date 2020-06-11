if(!$env:ANT_HOME){
	Write-BoxstarterMessage "ANT is not yet installed"
	#Common
	Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
	cinst nodejs
	cinst git -version 1.9.5.20150114
	choco install java.jdk -version 7.0.75
	#cinst jdk8 #http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-windows-x64.exe
	cinst ant

	$antHome="C:\tools\apache-ant-1.9.4"
	[System.Environment]::SetEnvironmentVariable('ANT_HOME', $antHome, 'Machine')
	$oldPath=(Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).Path
	$newPath=$oldPath+";"+$antHome+"\bin"
	Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath

	Write-BoxstarterMessage "Put ANT on the path, rebooting..."
	Invoke-Reboot
}else{
	Write-BoxstarterMessage "ANT is already installed, continuing ..."
}