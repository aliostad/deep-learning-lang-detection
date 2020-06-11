function Invoke-TfsCheckin(
	[string]$m = $(Read-Host -prompt "Commit message"),
	[string]$s, 
	[string]$o,
	[switch]$WhatIf
) {
<#
	.SYNOPSIS
	Commits pending changes in the current workspace, or from an existing shelveset.
	.DESCRIPTION
	Uses the tf checkin command to recursively commit pending changes in the current workspace without prompting the user with a GUI interface.  In some cases, it's required to override checkin policies with -o.
	.PARAMETER m
	Commit message - See https://spghp/ghpitweb/Wiki/TFS.aspx for examples of good commit messages.
	.PARAMETER s
	Shelveset name
	.PARAMETER o
	Override message
	.PARAMETER -WhatIf
	Tests checking in without actually doing it.  This option causes checkin to evaluate checkin policies, check check-in notes, and look for conflicts without actually checking in.  Any problems, such as conflicts, that are identified by this option must be resolved before you check in the item.
	.EXAMPLE
	Invoke-TfsCheckin -m "Commit message"
	.EXAMPLE
	Invoke-TfsCheckin -m "Commit message" -o "Override message"
	.EXAMPLE
	Invoke-TfsCheckin -s "Shelveset name" -m "Commit message"
	.EXAMPLE
	Invoke-TfsCheckin -m "Commit message" -WhatIf
#>
	Write-Host " "
	Write-Host "Checking in pending changes..."
	
	$cmd = "tf"
	$params = "checkin", ".", "/noprompt", "/recursive", "/comment:$m"
	
	if ($s.length -gt 0) {
		$params = $params + "/shelveset:$s "
	}
	
	if ($o.length -gt 0) {
		$params = $params + "/override:$o "
	}
	
	if ($WhatIf) {
		$params = $params + "/validate"
	}
	
	& $cmd $params
	
	Reset-TfsGlobals
}
