$LCErrorLog = "c:\error.log"
$wksname = $(Get-WmiObject Win32_Computersystem).name

function Get-LCSystemInfo {
    <#
    .SYNOPSIS
    Script for remote machine inspection.
    .OPTIONS
    blah balh blah
    .PARAMETER Computername
    .EXAMPLE
    .\Get-SystemInfo -ComputerName ANYCOMPUTERNAME

    #>
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$True,
                    ValueFromPipeline = $True, 
                    ValueFromPipelineByPropertyName = $True, 
                    HelpMessage = "Computername or IP: ")]
        [Alias('h')]
        [string[]]$ComputerName = 'localhost',
        
        [Parameter()]
        [string]$LCErrorLogPath = $LCErrorLog,
  	
		[switch]$ShowProgress
		
        
        )
        
    BEGIN{
	
		$each_computer = (100 / ($ComputerName.count) -as [int])
		$current_complete = 0
	}
    PROCESS{
        foreach ($Computer in $computername) {
		
		if ($Computer -eq '127.0.0.1') {
			Write-Warning "Connecting to local computer loopback"
		}
			if ($ShowProgress) { Write-Progress -Activity "Working on $computer" -Status "Percent added: " -PercentComplete $current_complete }
		
        	Write-verbose "Connecting via WMI to $computer"
			if ($ShowProgress) { Write-Progress -Activity "Working on $computer" -Status "Percent added: " -CurrentOperation "Operating System" -PercentComplete $current_complete }
            $os = Get-WmiObject -Class win32_operatingsystem -ComputerName $Computer
			
			if ($ShowProgress) { Write-Progress -Activity "Working on $computer" -Status "Percent added: " -CurrentOperation "Computer System" -PercentComplete $current_complete }
            $cs = Get-WmiObject -Class win32_computersystem -ComputerName $Computer
			
			Write-Verbose "Finished with WMI"
			if ($ShowProgress) { Write-Progress -Activity "Working on $computer" -Status "Percent added: " -CurrentOperation "Creating output" -PercentComplete $current_complete }
			$props = @{
                'ComputerName' = $Computer;
                'OSVersion' = $os.version;
                'OSBuild' = $os.buildnumber;
                'SPVersion' = $os.servicepackmajorversion;
                'Model' = $cs.model;
                'Manufacturer' = $cs.manufacturer;
                'RAM' = $cs.totalphysicalmemory/1KB -as [int];
                'SOckets' = $cs.numberofprocessors;
                'Cores' = $cs.numberoflogicalprocessors
                }

            $obj = New-Object -TypeName PSObject -Property $props
			Write-Verbose "Outputting to pipeline"
            Write-Output $obj
			Write-Verbose "Done with $computer"
			$current_complete += $each_computer
			if ($showprogress) { write-Progress -Activity "Working on $computer" -Status "Percent added: " -PercentComplete $current_complete }
        }
    }
    END{
			if ($showprogress) { write-Progress -Activity "Done" -Status "Percent added: " -completed }

	
	}
}

#Get-LCSystemInfo -h localhost,127.0.0.1,$wksname,localhost,127.0.0.1,$wksname,localhost,127.0.0.1,$wksname -ShowProgress

