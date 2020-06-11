function global:prompt {
	# show prompt
	Write-Host
	if ( Test-Admin ) {
		Write-Host ("A ") -n -f Red
	}
	Write-Host ($env:username + "@" + $([System.Net.Dns]::GetHostName()) + " ") -n -f DarkGray
	Write-Host ($(get-location)) -n -f Green

	# git extensions which get override by this prompt
	$realLASTEXITCODE = $LASTEXITCODE
	$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
	Write-VcsStatus
	$global:LASTEXITCODE = $realLASTEXITCODE
	# end git

	Write-Host ("`n$([char]0x03BB) ") -n -f DarkGray
    return " "
}