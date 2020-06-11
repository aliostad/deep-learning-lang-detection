function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ShareName,

		[parameter(Mandatory = $true)]
		[System.String]
		$Path
	)

    #Temporary variable to store the results of the file share check
    $shareInfo = $null

    Write-Verbose -Message "Checking to see if the file share $ShareName exists..."

    #If the share exists, it will return an object
    $shareInfo = Get-SmbShare $ShareName -ErrorAction SilentlyContinue
    if ($shareInfo)
    {
        Write-Verbose -Message "File share exists."
        #If the Get-SmbShare does not throw an exception, then the share exists
        $ensureResult = "Present"
    }
    else
    {
        Write-Verbose -Message "File share does not exist."
        #The share doesn't exist
        $ensureResult = "Absent"
    }

    Write-Verbose -Message "Creating hashtable."

	$returnValue = @{
		ShareName = $ShareName
		Path = $Path
		Ensure = $ensureResult
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ShareName,

		[parameter(Mandatory = $true)]
		[System.String]
		$Path,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    if($Ensure -eq "Present")
    {
        #Add the share
        Write-Verbose -Message "Creating the file share"

        Write-Verbose -Message "Checking to see if the path exists"
        #Check to see if the path exists
        $PathExists = Test-Path -Path $Path

        if (!$PathExists)
        {
            Write-Verbose "The path does not exist"
            Write-Verbose "Creating the path..."
            #Create the folder because it doesn't exist
            New-Item -Path $Path -ItemType directory
        }

        Write-Verbose -Message "Creating the share"
        #Create the share
        New-SmbShare -Name $ShareName -Path $Path
    }
    else
    {
        Write-Verbose -Message "Removing the file share"
        #Remove the share
        Remove-SmbShare -Name $ShareName -Force
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
		$ShareName,

		[parameter(Mandatory = $true)]
		[System.String]
		$Path,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	Write-Verbose -Message "Configuration has requested that the share be $Ensure"

    #Initialize the return value variable
    $returnValue = $false

    if($Ensure -eq "Present")
    {
        <#
            The user wants to make sure that the share exists
            If it does, return true, if not false
        #>
        Write-Verbose -Message "Checking to see if the file share $ShareName exists..."
        $ShareInfo = Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue
        if ($ShareInfo)
        {
            Write-Verbose -Message "Share exists."
            $returnValue = $true
        }
        else
        {
            Write-Verbose -Message "Share does not exist."
            $returnValue = $false
        }
    }
    else
    {
        <#
            The user wants to make sure that the share does NOT exist
            If it does, return false, if not true
        #>
        Write-Verbose -Message "Checking to see if the file share $ShareName exists..."
        $ShareInfo = Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue
        if ($ShareInfo)
        {
        Write-Verbose -Message "Share exists."
            $returnValue = $false
        }
        else
        {
            Write-Verbose -Message "Share does not exist."
            $returnValue = $true
        }
    }

	$returnValue
}


Export-ModuleMember -Function *-TargetResource