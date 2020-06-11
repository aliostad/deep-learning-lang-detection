function Show-ConfirmationPrompt {
	[OutputType([System.Boolean])]
	param (
		[Parameter(Mandatory=$true)]$Caption,
		[Parameter(Mandatory=$true)]$Message,
		[ValidateSet("Yes", "No")]$Default = "Yes",
		$YesDescription = "Agree to $Message",
		$NoDescription = "Decline to $Message"
	)

	$choices = [System.Management.Automation.Host.ChoiceDescription[]](
		(New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $YesDescription),
		(New-Object System.Management.Automation.Host.ChoiceDescription "&No", $NoDescription)
	)

	switch ($Default)
	{
		"Yes" { $defaultIndex = 0 }
		"No" { $defaultIndex = 1 }
	}
	
	$result = $Host.UI.PromptForChoice($Caption, $Message, $choices, $defaultIndex)

	switch ($result)
    {
        0 { return $true }
        1 { return $false }
    }
}