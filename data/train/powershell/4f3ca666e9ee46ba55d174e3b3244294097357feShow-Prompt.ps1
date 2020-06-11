Function Show-Prompt {
<#
	.SYNOPSIS
		Function to display a Simple Yes or No Prompt.

	.DESCRIPTION
		Displays Yes or No Pompt with or without help text.

	.PARAMETER  Yes
		Set default to Yes.

	.PARAMETER  Title
		Title of Question
		
	.PARAMETER  HelpYes
		Help text for Yes action
		
	.PARAMETER  HelpNo
		Help text for No action
	
	.EXAMPLE
		PS C:\> Show-Prompt "Continue?" -Boolean
		
		Continue?
		[N] No  [Y] Yes  [?] Help (default is "N"): ?
		N - No
		Y - Yes
		
		[N] No  [Y] Yes  [?] Help (default is "N"): Y
		
		True

	.EXAMPLE
		PS C:\> "Continue?" | Show-Prompt -Default 1
		
		Continue?
		[N] No  [Y] Yes  [?] Help (default is "Y"): N
		
		No

	.EXAMPLE
		$Options = @{
			One = "Option 1";
			Two = "Option 2";
			Three = "Option 3";
			4 = "Option Four";
		}
		PS C:\> Show-Prompt -Options

	.INPUTS
		System.String

	.OUTPUTS
		System.Boolean

	.LINK
		www.Proxx.nl/Wiki/Show-Prompt

#>

	Param(
		[String]$Title,
		[Parameter(Position=0,ValueFromPipeline=$true)][String]$Message,
		[HashTable]$Options=@{ "yes"="Yes";"No"="No"},
		[Int32]$Default=0,
		[Switch]$Boolean
	)
	
	$items = @()
	[System.Collections.Hashtable] $test = @{}
	[int]$Index = 0
    foreach($option in ($Options.Keys | Sort))
    {
        $items += New-Object System.Management.Automation.Host.ChoiceDescription(("&" + $option), $options.Item($option))
		$test.Add($Index, $option)
		$Index++
    }
	Try {
    	$choice = $host.ui.PromptForChoice($Title,$Message,$items,$Default)
	} Catch { return } 
	if ($Boolean) {
		Switch($choice) {
			0 { return $false }
			1 { Return $true }
			default { Return $_ }
		}
	} Else {
		Return $test.Item($choice)
	}
}
