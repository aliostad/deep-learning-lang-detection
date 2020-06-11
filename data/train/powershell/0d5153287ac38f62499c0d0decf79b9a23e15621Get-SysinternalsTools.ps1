
function Get-SysinternalsTools {
    <#
    .Synopsis
       Downloads the Sysinternals tools to the Machine
    .DESCRIPTION
       Downloads the Sysinternals tools to a specified directory using Bits Transfer.
    .PARAMETER Path
        Path to save the sysinternals executables.
    .EXAMPLE
       Get-SysinternalsTools -Path 'C:\Sysinternals' -Verbose -DownloadProtocol HTTP
    .EXAMPLE
       Get-SysinternalsTools -Path 'C:\Sysinternals' -DownloadProtocol SMB -Verbose
    #>
	
	[CmdletBinding()]
	
	Param
	(
		
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   ValueFromRemainingArguments = $false,
				   Position = 0,
				   HelpMessage = "Enter the path to wich you want to save the file.")]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[System.String]$Path,
		
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = "Select the protocol you wish to use to Download the Tools")]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('SMB', 'HTTP')]
		$DownloadProtocol
		
	)
	
	Begin {
		
		Write-Verbose -Message "Verifing if the webclient service is currently running..."
		
		if ((Get-Service -Name webclient).Status -eq 'Running') {
			
			Write-Verbose -Message "Webclient service if running, will continue now."
			
		}
		else {
			
			Write-Verbose -Message "Webclient service not running..."
			
			try {
				Write-Verbose -Message "Trying to start the service..."
				
				$start_service = $true
				
				Start-Service -Name 'webclient' -ErrorAction 'Stop'
				
			}
			catch {
				
				$start_service = $false
				
				Write-Error -Message "Couldn't start the webclient service"
				
			}
			finally {
				
				Write-Verbose -Message "Sucessfully Started the service"
				
			}
			if (-not ($start_service)) {
				
				return
				
			}
		}
		
		Write-Verbose -Message "Verifing if the provided path exists..."
		
		if (-not (Test-Path -Path $Path)) {
			
			Write-Verbose -Message "Provided path does not exist..."
			
			Write-Verbose -Message "Trying to create the folder"
			
			Try {
				$folder_Creation = $true
				
				New-Item $Path -ItemType Directory -Force -ErrorAction 'Stop'
				
			}
			Catch {
				
				$folder_Creation = $false
				
				Write-Verbose -Message "Error Creating the folder"
				Write-Error -Message "Can't create the folder... Will exit now"
				
				return
				
				
			}
			
			if ($folder_Creation) {
				
				Write-Verbose -Message "Sucessfully Created the folder"
				
			}
			
		}
		
	}
	
	Process {
		
		if ($DownloadProtocol -eq 'SMB') {
			
			Write-Verbose -Message 'Selected download protocol is SMB'
			
			$progParam = @{
				
				Activity = "Downloading Sysinternals executables"
				CurrentOperation = '\\live.sysinternals.com\tools'
				Status = "Querying top level Tools"
				PercentComplete = 0
				
			}
			
			Write-Progress @progParam
			
			Write-Verbose -Message "Begin listing tools"
			
			try {
				
				$listing_status = $true
				
				$TotalItems = Get-Childitem -Path '\\live.sysinternals.com\tools' -Recurse -ErrorAction 'Stop'
				
			}
			catch {
				
				$listing_status = $false
				
				Write-Error -Message "Error listing the files, please verify your conectivity"
				
			}
			if (-not ($listing_status)) {
				
				break
				
			}
			
			Write-Verbose -Message "Tools sucessfully listed"
			
			Write-Verbose -Message "Will Begin the Download now"
			
			Write-Verbose -Message "Initializing loop counter"
			
			$i = 0
			
			foreach ($item in $TotalItems) {
				
				#calculate percentage
				Write-Verbose -Message "Calculating current percentage..."
				
				$i++
				
				[int]$percent = ($i / $TotalItems.count) * 100
				
				Write-Verbose -Message "Currently on $percent%..."
				
				[String]$FileName = $item.Name
				
				[String]$Source = $Item.FullName
				
				[String]$Destination = $Path
				
				$progParam.CurrentOperation = "Downloading file: $FileName"
				$progParam.Status = "Downloading from '\\live.sysinternals.com'"
				$progParam.PercentComplete = $percent
				
				Write-Progress @progParam
				
				Write-Verbose -Message "Begin downloading $FileName"
				
				try {
					
					$Download_Status = $true
					
					Start-BitsTransfer -Source $Source -Destination $Destination -DisplayName $FileName -Priority 'High' -Description "Downloading tool..." -ErrorAction 'Stop'
					
				}
				catch {
					
					Write-Error -Message "Error Downloading $FileName..."
					
				}
				
				if ($Download_Status) {
					
					Write-Verbose -Message "Sucessfully downloaded $FileName"
					
				}
				
				Start-Sleep -Milliseconds 200
				
				Write-Verbose -Message "Sucessfully Download the Tools"
			}
		}
		if ($DownloadProtocol -eq 'HTTP') {
			
			Write-Verbose -Message 'Selected download protocol is HTTP'
			
			$progParam = @{
				
				Activity = "Downloading Sysinternals executables"
				CurrentOperation = 'http://live.sysinternals.com\tools'
				Status = "Querying top level Tools"
				PercentComplete = 0
				
			}
			
			Write-Progress @progParam
			
			Write-Verbose -Message "Begin listing tools"
			
			try {
				
				$listing_status = $true
				
				$TotalItems = (Invoke-WebRequest -Uri 'http://live.sysinternals.com' -ErrorAction 'Stop').links
				
			}
			catch {
				
				$listing_status = $false
				Write-Error -Message "Error listing the files, please verify your conectivity"
				
				
			}
			if (-not ($listing_status)) {
				
				break
				
			}
			
			Write-Verbose -Message "Tools sucessfully listed"
			
			Write-Verbose -Message "Will Begin the Download now"
			
			Write-Verbose -Message "Initializing loop counter"
			
			$i = 0
			
			foreach ($item in $TotalItems) {
				
				#calculate percentage
				Write-Verbose -Message "Calculating current percentage..."
				
				$i++
				
				[int]$percent = ($i / $TotalItems.count) * 100
				
				Write-Verbose -Message "Currently on $percent%..."
				
				[String]$FileName = $Item.InnerText
				
				[String]$Source = "http://live.sysinternals.com/$($Item.innerText)"
				
				[String]$Destination = $Path
				
				$progParam.CurrentOperation = "Downloading file: $FileName"
				$progParam.Status = "Downloading from 'http://live.sysinternals.com'"
				$progParam.PercentComplete = $percent
				
				Write-Progress @progParam
				
				Write-Verbose -Message "Begin downloading $FileName from $Source..."
				
				
				
				try {
					
					$Download_Status = $true
					
					Start-BitsTransfer -Source $Source -Destination $Destination -DisplayName $FileName -Priority 'High' -Description "Downloading tool..." -ErrorAction 'Stop' -TransferType Download
					
				}
				catch {
					
					Write-Error -Message "Error Downloading $FileName..."
					
				}
				
				if ($Download_Status) {
					
					Write-Verbose -Message "Sucessfully downloaded $FileName"
					
				}
				
				Start-Sleep -Milliseconds 200
				
				Write-Verbose -Message "Sucessfully Download the Tools"
				
			}
			
		}
		
		
	}
	
	End {
	}
	
}