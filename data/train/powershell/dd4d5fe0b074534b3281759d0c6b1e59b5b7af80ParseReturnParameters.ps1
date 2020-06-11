[CmdletBinding(SupportsShouldProcess=$true)]
param (
    [parameter(Mandatory=$true, HelpMessage="The file with list of assembles to process")]
    [string] $inputFile,
    [parameter(Mandatory=$false, HelpMessage="Specify the pattern of return value to search for")]
    [string] $returnTypeToSearchFor = "System.Threading.Tasks.Task"
    )

#---------------------------------------------------------------------
# Script begins
$scriptFolderPath = Split-Path -Path $MyInvocation.MyCommand.Path

#---------------------------------------------------------------------
# Configure logging
$startTime = [System.DateTime]::Now.ToString("yyyyMMdd-HHmmss")
$logDirPath = $scriptFolderPath
$logFilePath = Join-Path -Path $logDirPath -ChildPath "ParseReturnParameters.$startTime.ps1.log"

try
{
    #---------------------------------------------------------------------
    # Start logging
    Start-Transcript -Path $logFilePath -Append
    Write-Output "PowerShellMe.ps1 has been started from '$scriptFolderPath'"
    Write-Output "Logging the script to '$logFilePath'"
    
	Write-Verbose "Passed inputFile:"
	$inputFile
	
	$inputFile = Resolve-Path -Path $inputFile

	Write-Output "InputFile is:"
	$inputFile
	
	Write-Output "Searching for:"
	$returnTypeToSearchFor
	
	$outputFile = [System.IO.Path]::GetDirectoryName($inputFile) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($inputFile) + ".Results" +[System.IO.Path]::GetExtension($inputFile)
	Write-Output "outputFile will be:"
	$outputFile
	
    #---------------------------------------------------------------------
	# Load list of files
    $filesToProcess = Import-Csv -Path $inputFile
		
	# Declare list of hits
	$resultLinesColl = @()
	
	foreach ($fileToProcess in $filesToProcess)
	{
		$assemblyFullNameorFileName = $fileToProcess.Assembly
		Write-Output "Path: $assemblyFullNameorFileName"

		$assembly = $null
		
		[bool] $tryLoadWithFilePath = $false

		#---------------------------------------------------------------------
		# First try loading assuming it's full assembly name
		# System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089
		try
		{
			#$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoad($assemblyFullNameorFileName)
			$assembly = [System.Reflection.Assembly]::Load($assemblyFullNameorFileName)
		}
        catch [System.IO.FileLoadException]
        {
			if ($_.exception.Message.Contains("The given assembly name or codebase was invalid. (Exception from HRESULT: 0x80131047)"))
			{
				Write-Verbose "$assemblyFullNameorFileName is not a fully qualified assembly name"
				$tryLoadWithFilePath = $true
			}
			else
			{
				Write-Warning "Unable to load $assemblyFullNameorFileName because of the System.FileLoadException"
				$_.exception
			}
        }
        catch [System.Exception]
        {
            Write-Warning "Unable to load $assemblyFullNameorFileName because of the System.Exception"
            $_.exception
        }
		
		#---------------------------------------------------------------------
		# If that didn't work, try loading as DLL
		if ($tryLoadWithFilePath -eq $true)
		{
			try
			{
				#$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($assemblyFullNameorFileName)
				$assembly = [System.Reflection.Assembly]::LoadFrom($assemblyFullNameorFileName)
			}
			catch [System.IO.FileLoadException]
			{
				Write-Warning "Unable to load $assemblyFullNameorFileName because of the System.FileLoadException"
				$_.exception
			}
			catch [System.Exception]
			{
				Write-Warning "Unable to load $assemblyFullNameorFileName because of the System.Exception"
				$_.exception
			}
		}
		
		#---------------------------------------------------------------------
		# Got assembly loaded, process types
		if ($assembly -ne $null)
		{
			if ($PSBoundParameters["Verbose"]) 
			{
				Write-Verbose "Assembly:"
				$assembly | Format-Table
			}
			else
			{
				Write-Output "."			
				Write-Output "Assembly: $($assembly.Location)"
			}
			
			try
			{
				foreach ($type in $assembly.GetTypes())
				{
					if ($PSBoundParameters["Verbose"]) 
					{
						Write-Verbose "Type:"
						$type | Format-List
					}
					else
					{
						#Write-Output "Type: $($type.FullName)"
						Write-Host "." -NoNewLine
					}
					
					foreach ($methodInfo in $type.GetMethods([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::Static -bor [System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::NonPublic))
					{
						$returnType = $null
						$returnType = $methodInfo.ReturnType
						
						if ($PSBoundParameters["Verbose"]) 
						{
							Write-Verbose "Method:"
							$methodInfo | Format-List
							Write-Verbose "Return type:"
							$returnType | Format-List							
						}
						else
						{
							#Write-Output "Method: $($returnType.UnderlyingSystemType) $($methodInfo.Name)"
							Write-Host "." -NoNewLine
						}
																		
						if ($returnType.ToString().StartsWith($returnTypeToSearchFor))
						{
							Write-Output "."
							Write-Output "Match: $($returnType.UnderlyingSystemType) $($methodInfo.Name)"
							
							$foundResult = New-Object -TypeName PSCustomObject -Property @{
								LookingFor = $returnTypeToSearchFor
								Location = $assembly.Location
								Version = $assembly.ImageRuntimeVersion
								GAC = $assembly.GlobalAssemblyCache
								Module = $type.Module
								Assembly = $type.Assembly
								ClassName = $type.FullName
								ClassVisibility = "private"
								Method = $methodInfo.Name
								ReturnType = $returnType.UnderlyingSystemType}

							if ($type.IsPublic -eq $true) {$foundResult.ClassVisibility = "public"}
							if ($type.IsNotPublic -eq $true) {$foundResult.ClassVisibility = "internal"}
							
							$resultLinesColl += $foundResult
						}
					}
				}
			}
			catch [System.Reflection.ReflectionTypeLoadException]
			{
				Write-Warning "Unable to load list of types because of the System.Reflection.ReflectionTypeLoadException"
				$_.exception
				$_.exception.LoaderExceptions 
			}
			catch [System.Exception]
			{
				Write-Warning "Unable to load $assemblyFullNameorFileName because of the System.Exception"
				$_.exception
			}
		}
	}

	# Write results
	$resultLinesColl | Select LookingFor, Assembly, Version, GAC, Location, Module, ClassVisibility, ClassName, Method, ReturnType | Export-CSV -Path $outputFile -Delimiter "," -NoTypeInformation			
}
finally
{
    #---------------------------------------------------------------------
    # End Logging
    Write-Output "ParseReturnParameters.ps1 is done"

    #---------------------------------------------------------------------
    # Stop logging
    Stop-Transcript
}

