function Disable-RemoteDesktop
{
<#
	.SYNOPSIS
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.
	
	.DESCRIPTION
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.
	
	.PARAMETER ComputerName
		Specifies the computername
	
	.PARAMETER Credential
		Specifies the credential to use
	
	.PARAMETER CimSession
		Specifies one or more existing CIM Session(s) to use
	
	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01
	
	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01 -Credential (Get-Credential -cred "FX\SuperAdmin")
	
	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session
	
	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session1,$session2,$session3
	
	.NOTES
		Francois-Xavier Cat
		@lazywinadm
		www.lazywinadmin.com
        github.com/lazywinadmin
#>
	#Requires -RunAsAdministrator
	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   SupportsShouldProcess = $true)]
	PARAM (
		[Parameter(
				   ParameterSetName = "Main",
				   ValueFromPipeline = $True,
				   ValueFromPipelineByPropertyName = $True)]
		[Alias("CN", "__SERVER", "PSComputerName")]
		[String[]]$ComputerName,
		
		[Parameter(ParameterSetName = "Main")]
		[Alias("RunAs")]
		[System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty,
		
		[Parameter(ParameterSetName = "CimSession")]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)
	BEGIN
	{
		# Helper Function
		function Get-DefaultMessage
		{
<#
.SYNOPSIS
	Helper Function to show default message used in VERBOSE/DEBUG/WARNING
.DESCRIPTION
	Helper Function to show default message used in VERBOSE/DEBUG/WARNING
	and... HOST in some case.
	This is helpful to standardize the output messages
	
.PARAMETER Message
	Specifies the message to show
.NOTES
	Francois-Xavier Cat
	www.lazywinadmin.com
	@lazywinadm
#>
			PARAM ($Message)
			$DateFormat = Get-Date -Format 'yyyy/MM/dd-HH:mm:ss:ff'
			$FunctionName = (Get-Variable -Scope 1 -Name MyInvocation -ValueOnly).MyCommand.Name
			Write-Output "[$DateFormat][$FunctionName] $Message"
		} #Get-DefaultMessage
	}
	PROCESS
	{
		IF ($PSBoundParameters['CimSession'])
		{
			FOREACH ($Cim in $CimSession)
			{
				$CIMComputer = $($Cim.ComputerName).ToUpper()
				
				IF ($PSCmdlet.ShouldProcess($CIMComputer, "Disable Remote Desktop via Win32_TerminalServiceSetting"))
				{
					
					TRY
					{
						# Parameters for Get-CimInstance
						$CIMSplatting = @{
							Class = "Win32_TerminalServiceSetting"
							NameSpace = "root\cimv2\terminalservices"
							CimSession = $Cim
							ErrorAction = 'Stop'
							ErrorVariable = "ErrorProcessGetCimInstance"
						}
						
						# Parameters for Invoke-CimMethod
						$CIMInvokeSplatting = @{
							MethodName = "SetAllowTSConnections"
							Arguments = @{
								AllowTSConnections = 0;
								ModifyFirewallException = 0
							}
							ErrorAction = 'Stop'
							ErrorVariable = "ErrorProcessInvokeCim"
						}
						
						Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - disable Remote Desktop (and Modify Firewall Exception")
						Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
					}
					CATCH
					{
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")
						IF ($ErrorProcessGetCimInstance) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance") }
						IF ($ErrorProcessInvokeCim) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod") }
						Write-Warning -Message $Error[0].Exception.Message
					} #CATCH
					FINALLY
					{
						$CIMSplatting.Clear()
						$CIMInvokeSplatting.Clear()
					}
				}
			} #FOREACH ($Cim in $CimSessions)
		} #IF ($PSBoundParameters['CimSession'])
		ELSE
		{
			FOREACH ($Computer in $ComputerName)
			{
				$Computer = $Computer.ToUpper()
				
				IF ($PSCmdlet.ShouldProcess($Computer, "Disable Remote Desktop via Win32_TerminalServiceSetting"))
				{
					
					TRY
					{
						Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")
						IF (Test-Connection -Computer $Computer -count 1 -quiet)
						{
							$Splatting = @{
								Class = "Win32_TerminalServiceSetting"
								NameSpace = "root\cimv2\terminalservices"
								ComputerName = $Computer
								Authentication = 'PacketPrivacy'
								ErrorAction = 'Stop'
								ErrorVariable = 'ErrorProcessGetWmi'
							}
							
							IF ($PSBoundParameters['Credential'])
							{
								$Splatting.credential = $Credential
							}
							
							# disable Remote Desktop
							Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - disable Remote Desktop")
							(Get-WmiObject @Splatting).SetAllowTsConnections(0, 0) | Out-Null
							
							# Disable requirement that user must be authenticated
							#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
						}
					}
					CATCH
					{
						Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")
						IF ($ErrorProcessGetWmi) { Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject") }
						Write-Warning -MEssage $Error[0].Exception.Message
					}
					FINALLY
					{
						$Splatting.Clear()
					}
				}
			} #FOREACH
		} #ELSE (Not CIM)
	} #PROCESS
} #Function
