function global:Take-Screenshot{
	[CmdletBinding()
		]
	param (
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=0,HelpMessage=’object: Object with arguments as properties’)]
		[object]$arg_obj=$null,
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=1,HelpMessage=’datatype: Description’)]
		[string]$out_path="tmp.bmp",
		[parameter(Mandatory=$False,ValueFromPipeline=$True,Position=2,HelpMessage=’datatype: Description’)]
		[string]$save_to_file = $false
		
		)
		
	Begin
	{
		#input validation
		
		#parse arg_obj
		if($arg_obj -ne $null)
		{
			try
			{
					$out_path = [string]$arg_obj.out_path
					$save_to_file = [bool]$arg_obj.save_to_file
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
		Add-Type -AssemblyName System.Windows.Forms
		Add-type -AssemblyName System.Drawing

		$vs = [System.Windows.Forms.SystemInformation]::VirtualScreen
		$Width = $vs.Width
		$Height = $vs.Height
		$Left = $vs.Left
		$Top = $vs.Top
		$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
		$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
		$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
		IF($save_to_file){
			$message = "Screenshot saved to: $out_path"
			CD $PSScriptRoot
			$bitmap.Save($out_path) 
			Write-Output $message
			}
		Write-Output $graphic
		
	}
	End
	{
		#cleanup
	}

}