#requires -version 5

Import-Module -Name $PSScriptRoot\..\..\Library\Helper.psm1

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$LogName
	)
    
    $returnValue = @{
	    LogName = $LogName
		Ensure = "Absent"
	}
    
    try
    {
        $returnValue = Get-CurrentValue -LogName $LogName

        $returnValue
    }
    catch
    {
        Write-Debug -Message "ERROR: $($_|Format-List -Property * -Force|Out-String)"
        New-TerminatingError -ErrorId 'klWindowsLogGet' -ErrorMessage $_.Exception -ErrorCategory InvalidOperation 
    }
    finally 
    {
        Write-Verbose -Message "$((get-date).GetDateTimeFormats()[112]) Done Get [klWindowsLog]$LogName" 
    }
}

function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$LogName,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    try 
    {
        Write-Verbose -Message "$((Get-Date).GetDateTimeFormats()[112]) Start Set [klWindowsLog]$LogName"

        if ($Ensure -eq "Present")
        {
           Write-Verbose -Message "Will create new log: $LogName, ensure is set to Present"
           New-EventLog -LogName $LogName -Source $LogName -Verbose 
        }
        else
        {
            Write-Verbose -Message "Will remove log: $LogName, ensure is set to Absent"
            Remove-EventLog -LogName $LogName -Verbose
        }
    }
    catch 
    {
        Write-Debug -Message "ERROR: $($_|Format-List -Property * -Force|Out-String)"
        New-TerminatingError -ErrorId 'klWindowsLogSet' -ErrorMessage $_.Exception -ErrorCategory InvalidOperation 
    }
    finally
    {
        Write-Verbose -Message "$((get-date).GetDateTimeFormats()[112]) Done Set [klWindowsLog]$LogName" 
    }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$LogName,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    $valuesMatch = $false

    try
    {
        Write-Verbose -Message "$((Get-Date).GetDateTimeFormats()[112]) Start Test [klWindowsLog]$LogName" 
        $current = Get-CurrentValue -LogName $LogName
        
        if ($current.Ensure -eq $Ensure) {
            $valuesMatch = $true
        }

        Write-Verbose -Message "Log with name: $LogName, ensure value returned from get-cv: $($current.Ensure), will return: $valuesMatch"

        return $valuesMatch
    }
    catch
    {
        Write-Debug -Message "ERROR: $($_|Format-List -Property * -Force|Out-String)"
        New-TerminatingError -ErrorId 'klWindowsLogTest' -ErrorMessage $_.Exception -ErrorCategory InvalidOperation
    }
    finally
    {
        Write-Verbose -Message "$((get-date).GetDateTimeFormats()[112]) Done Test [klWindowsLog]$LogName" 
    }
}

function Get-CurrentValue
{
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$LogName
	)

    $returnValue = @{
	    LogName = $LogName
		Ensure = "Absent"
	}
    
    $l = Get-EventLog -List | Where-Object -Property Log -eq $LogName
    if ($null -ne $l)
    {
         Write-Verbose -Message "Found log: $LogName"
         $returnValue.Ensure = "Present"
    }
    else
    {
        Write-Verbose -Message "Could not find log: $LogName"
    }

    return $returnValue
}


Export-ModuleMember -Function *-TargetResource