function Find-String {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$Pattern,
		$Path = $PWD,
        $Exclude = @('*\bin\*', '*\obj\*', '*\.git\*', '*\.hg\*', '*\.svn\*', '*\_ReSharper\*'),
		[switch]$ShowContext,
        [switch]$DisableRecursion,
		[switch]$IncludeLargeFiles
    )

	$maxFileSizeToSearchInBytes = 1MB
	
	$searchErrors = @()

	Write-Host "Finding '$Pattern' in $Path...`n" -ForegroundColor White
	Get-ChildItem -Path $Path -Recurse:$(-not $DisableRecursion) -File -ErrorAction SilentlyContinue -ErrorVariable +searchErrors |
		? {
			$FullName = $_.FullName
			if ($Exclude | % { if ($FullName -like $_) { return $true } }) { return $false }

			if (-not $IncludeLargeFiles -and $_.Length -ge $maxFileSizeToSearchInBytes) { return $false }

			
			$byteArray = Get-Content -Path $_.FullName -Encoding Byte -TotalCount 1KB -ErrorAction SilentlyContinue -ErrorVariable +searchErrors
			if ($null -eq $byteArray -or $byteArray -contains 0) { return $false }

			return $true
		} |
		Select-String -Pattern ([Regex]::Escape($Pattern)) -AllMatches -Context 2 -ErrorAction SilentlyContinue -ErrorVariable +searchErrors  |
		Group-Object -Property Path |
		% {
			Write-Host (Resolve-Path -Relative $_.Name) -ForegroundColor Cyan -NoNewLine
			Write-Host ":"

			$displaySeperator = $false
			$_.Group | % {
				if ($ShowContext -and $displaySeperator) { Write-Host "--" }
				else { $displaySeperator = $true }

		     	# Display pre-context
	            if ($ShowContext -and $_.Context.DisplayPreContext) {
	            	$lines = ($_.LineNumber - $_.Context.DisplayPreContext.Length)..($_.LineNumber - 1)
	        		for ($i = 0; $i -lt $_.Context.DisplayPreContext.length; $i++) {
	        			Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPreContext[$i]) -ForegroundColor DarkGray
	        		}
	            }

	            # Display main result
	            Write-Host ("{0}: " -f $_.LineNumber) -NoNewLine
	            $index = 0
	            foreach ($match in $_.Matches) {
	                Write-Host $_.Line.SubString($index, $match.Index - $index) -NoNewLine
	                Write-Host $match.Value -ForegroundColor Black -BackgroundColor Yellow -NoNewLine
	                $index = $match.Index + $match.Length
	            }
	            Write-Host $_.Line.SubString($index)

	            # Display post-context
				if ($ShowContext -and $_.Context.DisplayPostContext) {
					$lines = ($_.LineNumber + 1)..($_.LineNumber + $_.Context.DisplayPostContext.Length)
		        	for ($i = 0; $i -lt $_.Context.DisplayPostContext.length; $i++) {
		        		Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPostContext[$i]) -ForegroundColor DarkGray
		        	}
		  		}
		  	}
	  	}

	Write-Host
	_Write-FileSystemAccessErrors -ErrorArray $searchErrors
}