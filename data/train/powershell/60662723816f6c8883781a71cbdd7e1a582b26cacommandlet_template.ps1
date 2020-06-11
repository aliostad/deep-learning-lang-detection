function global:Verb-Noun{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=0,HelpMessage=’object: Object with arguments as properties’)]
		[object]$arg_obj=$null,
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=0,HelpMessage=’datatype: Description’)]
		[string]$var
		)
		
	Begin
	{
		#input validation
		
		#parse arg_obj
		if($arg_obj -ne $null)
		{
			try
			{
				#$var = [Type]$arg_obj.var
				
			
			}
			catch
			{
				$ErrorMessage = $_.Exception.Message
    			$FailedItem = $_.Exception.ItemName
				Write-Host "Error parsing input. Item: $FailedItem `n ---ERROR-- `n $ErrorMessage"
				Break
			
			}
		
	}
	Process
	{
		
	}
	End
	{
		#cleanup
	}

}