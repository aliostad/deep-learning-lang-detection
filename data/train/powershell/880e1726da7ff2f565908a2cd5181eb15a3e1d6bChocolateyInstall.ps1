try {
	Update-ExecutionPolicy Unrestricted
	Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

	cinstm ruby
	cinstm nodejs.install

	cinstm ConEmu
	cinstm windbg
	cinstm git.install
	cinstm webpicommandline

	cinstm Emacs
	cinstm sublimetext2
	cinstm windbg
	cinstm baretail
	cinstm PhantomJS
	cinstm githubforwindows
	cinstm dotPeek
	cinstm filezilla

	cinstm Firefox
	cinstm GoogleChrome
	cinstm GoogleChrome.Canary
	cinstm HipChat
	cinstm spotify

	cinst IIS-WebServerRole -source windowsfeatures
	cinst IIS-HttpCompressionDynamic -source windowsfeatures
	cinst IIS-ManagementScriptingTools -source windowsfeatures
	cinst IIS-WindowsAuthentication -source windowsfeatures
	cinst IIS-WebServer -source windowsfeatures
	cinst IIS-WebServerManagementTools -source windowsfeatures
	cinst IIS-RequestFiltering -source windowsfeatures
	cinst IIS-HttpRedirect -source windowsfeatures
	cinst IIS-ASPNET45 -source windowsfeatures
	cinst IIS-ASPNET -source windowsfeatures
	cinst IIS-Metabase -source windowsfeatures
	
	cwebpi UrlRewrite2

    Write-ChocolateySuccess 'WebDev'
} catch {
  Write-ChocolateyFailure 'WebDev' $($_.Exception.Message)
  throw
}
