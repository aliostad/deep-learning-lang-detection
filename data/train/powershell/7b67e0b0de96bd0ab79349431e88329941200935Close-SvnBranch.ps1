function Close-SvnBranch {
	[CmdletBinding()]
	param (
		$Root,
		$Branches,
		$Postfix,
		$Closed,
		
		[Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
		[string[]] $BranchName
	)

	begin {
		$ErrorActionPreference = 'Stop'

		$config = Get-Configuration
		$Root = $config.GetValue('Root', $null, $Root)
		$Branches = $config.GetValue('Branches', $null, $Branches)
		$Postfix = $config.GetValue('Postfix', $null, $Postfix)
		$Closed = $config.GetValue('Closed', $null, $Closed)
		$svn = $config.GetValue('svn', 'svn')
		$messageTemplate = $config.GetValue('CloseMessageTemplate', 'Close branch {0}.')
	}
	
	process {
		Write-Message "Closing branch $BranchName"
		
		$message = $messageTemplate -f $BranchName
		$filename = [System.IO.Path]::GetTempFileName()
		$message | Out-File $filename -Encoding utf8
		
		& $svn mv `
		  (Format-Url @($Root, $Branches, $Postfix, $BranchName)) `
		  (Format-Url @($Root, $Branches, $Postfix, 'Closed', $BranchName)) `
		  -F $filename `
		  --encoding 'UTF-8'
		
		Remove-Item $filename
	}
}