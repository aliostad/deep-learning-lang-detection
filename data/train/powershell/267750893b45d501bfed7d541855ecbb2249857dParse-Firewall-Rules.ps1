Function Parse-Firewall-Rules($rawRules) {
	[xml]$rules = [xml](Get-Content $rawRules)
	[string]$saveRoot = Dialog($TRUE)

	# Walk the XML tree from the Panorama output.
	# We are looking for the ruleset groups.
	$ruleGroups = $rules.config.devices.entry.'device-group'.entry
	[PSCustomObject]$securityRules = @()
	foreach ($group in $ruleGroups) {
		$XMLSecurityRules = $group.'pre-rulebase'.security.rules.entry
		$XMLSecurityRules += $group.'post-rulebase'.security.rules.entry

	   # Bundle each rule as a PowerScript object and sanitize some of the text output.
	   [PSCustomObject]$securityRules = @()
	   foreach ($rule in $XMLSecurityRules) {
			$tmp = [PSCustomObject]@{
				Name = $rule.name
				Action = $rule.action
				From = Clean-String($rule.source.member | Out-String)
				To = Clean-String($rule.destination.member | Out-String)
				Description = $rule.description
				Application = Clean-String($rule.application.member | Out-String)
				Service = Clean-String($rule.service.member | Out-String)
			}
			
		$securityRules += $tmp
		}

		# Save every ruleset as a CSV to the user specified folder.
		# The default folder is wherever the script lives.
		$securityRules | Export-CSV -PATH "$($saveRoot)\$($group.name).csv"
	}
}

# This is just a fluffed-up string trim().
Function Clean-String($str) {
	return ($str -creplace '(?m)^\s*\r?\n', '').Trim()
}

# Convienence function to load the open file and save folder dialogs.
# 
# Function accepts input $TRUE or $FALSE; $TRUE will invoke the folder dialog.
Function Dialog($save) {
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	if ($save -eq $TRUE) {
		$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
		$dialog.SelectedPath = $PSScriptRoot
		$dialog.ShowDialog() | Out-Null
		$dialog.SelectedPath
	} else {
		$dialog = New-Object System.Windows.Forms.OpenFileDialog
		$dialog.InitialDirectory = $PSScriptRoot
		$dialog.ShowDialog() | Out-Null
		$dialog.Filename
	}		
}

Parse-Firewall-Rules(Dialog($FALSE))