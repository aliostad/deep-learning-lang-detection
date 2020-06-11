# source the ThrowError function instead of using `throw`
. "$PSScriptRoot\..\ThrowError.ps1"

#requires -Module PowerBotMQ
$Reactions = @{}
$CachedUsers = @{}

function Register-Reaction {
    #.Synopsis
    #   Register an automatic reaction for the bot
	[CmdletBinding()]
	param(
        # Regular Expression pattern to trigger this reaction
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		$Pattern,

        # Command to return when this reaction is triggered
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		$Command
	)
	process {
		Write-Verbose "Registering reaction trigger for '$Pattern'" -Verbose
		if(!$Reactions.Contains($Pattern)){
			$Reactions.$Pattern = @($Command)
		} else {
			$Reactions.$Pattern += $Command
		}
	}
}

function Unregister-Reaction {
    #.Synopsis
    #   Unregister an automatic reaction from the bot
	[CmdletBinding()]
	param(
        # The Regular Expression pattern of the reaction that you want to remove
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		$Pattern,

        # The Command of the pattern you want to remove
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		$Command
	)
	process {
		Write-Verbose "Removing reaction trigger for '$Pattern'" -Verbose
		if($Reactions.Contains($Pattern)){
			$Reactions.$Pattern = $Reactions.$Pattern | Where-Object { $_ -ne $Command }
		}
	}
}

function Get-Reaction {
    #.Synopsis
    #   Get a (list of) reaction(s) that are registered in this bot
    [CmdletBinding()]
    [OutputType([Hashtable], [Array])]
	param(
        # Optionally, the pattern you want the reaction(s) for
		[Parameter()]
		$Pattern
    )
    if($Pattern) {
        if($Reactions.Contains($Pattern)){
            $Reactions[$Pattern]
        }
    } else {
        $Reactions
    }
}

function Find-LastSeen {
    #.Synopsis
    #   Find the last time the specified user spoke     
    [CmdletBinding(DefaultParameterSetName="ByName")]
    [OutputType([string])]
    param(
        # The Users's GUID
        [Parameter(Position=0, Mandatory=$True, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByGuid')]
        [Guid]$Guid,
        
        # The Network the user belongs to
        [Parameter(Position=0, Mandatory=$True, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByName')]
        [string]$Network,
        
        # The AuthenticatedUser to fetch roles for
        [Parameter(Position=1, Mandatory=$True, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByName')]
        [Alias("AuthenticatedUser")]
        [string]$UserName         
    )
    if($Guid) {
        Write-Verbose "Search For User Guid: $Guid"
        if($CachedUsers.Contains($Guid)) {
            $Message = $CachedUsers[$User.Guid]
            $MessageText = @($Message.Message)[0] + $(if(@($Message.Message).Length -gt 1){"..."})
            "I saw {0} ({1}) on {2} at {3:hh:mm tt} on {3:dddd, MMMM dd} saying: {4}" -f $Message.DisplayName, ($User.Roles -join ", "), $Message.Network, $Message.TimeStamp, $MessageText 
        } else {
            "I haven't seen them recently."
        }
    } else {
        Write-Verbose "Search For User: $Network\$UserName"
        if($User = Get-Role -Network $Network -AuthenticatedUser $UserName -ErrorAction SilentlyContinue) {
            Write-Verbose "Found User.`n$($User | Format-Table | Out-String)"
            if($CachedUsers.Contains($User.Guid)) {
                $Message = $CachedUsers[$User.Guid]
                $MessageText = @($Message.Message)[0] + $(if(@($Message.Message).Length -gt 1){ "..."})
                "I saw {0} ({1}) on {2} at {3:hh:mm tt} on {3:dddd, MMMM dd} saying: {4}" -f $Message.DisplayName, ($User.Roles -join ", "), $Message.Network, $Message.TimeStamp, $MessageText 
            } else {
                "I haven't seen '$($User.DisplayName)' recently."
            }
        } else { 
            "I don't know '$UserName' yet."
        }          
    }
}

function Start-Adapter {
    #.Synopsis
    #   Start this adapter (mandatory adapter cmdlet)
    [CmdletBinding()]
    param(
        # The Context to start this adapter for. Generally, the channel name that's common across networks.
        # Defaults to "PowerShell"
        $Context = "PowerShell",

        # The Name of this adapter.
        # Defaults to "PowerBot"
        [String]$Name = "PowerBot",
        
        # The allowed roles. Defaults to "Admin" and "User"
        [String[]]$Roles = @("Admin", "User", "Guest")
    )
    
    # Push the roles into the user roles module
    & (Get-Module UserRoles) { $Script:Roles = $Args } @Roles

    if($Reactions.Count -eq 0) {
        InitializeAdapter
    }

    $Reactions = Get-Reaction

    $Script:PowerBotName = $Name
    Register-Receiver $Context
    $Character = $Null
    while($Character -ne "Q") {
        while(!$Host.UI.RawUI.KeyAvailable) {
            if($Message = Receive-Message -NotFromNetwork "Robot") {
                Write-Verbose "Receive-Message -NotFromNetwork Robot"
                $Message | Format-Table | Out-String | Write-Verbose
                # Track last message from each authenticated user
                if($Message.AuthenticatedUser) {
                    $User = $Message | Get-Role 
                    $CachedUsers.($User.Guid) = $Message
                }                
                foreach($KVP in $Reactions.GetEnumerator()) {
                    if($Message.Message -Join "`n" -Match $KVP.Key) {
                        foreach($Command in $KVP.Value) {
                            foreach($string in & $Command $Message) {
                                Send-Message -Context $Message.Context -NetworkFrom Robot -ChannelFrom $Message.Channel -Type $Message.Type -Message $string 
                            }
                        }
                    }
                }
            }
        }
        $Character = $Host.UI.RawUI.ReadKey().Character
    }
}

function InitializeAdapter {
    #.Synopsis
    #   Initialize the adapter (mandatory adapter cmdlet)
    param()

    Register-Reaction "!seen\s+(\S+)" {
        param(
            [PoshCode.Envelope]$Message
        )
        process {
            $null = $Message.Message -Join "`n" -Match "!seen\s+(?<user>\w+)(?:\s+on\s+(?<network>\S+))?"
            
            if($Matches["network"]) {
                "Hey $($Message.DisplayName), " + $(Find-LastSeen -Network $Matches["network"] -AuthenticatedUser $Matches["user"]) 
            } else {
                "Hey $($Message.DisplayName), " + $(Find-LastSeen -Network $Message.Network -AuthenticatedUser $Matches["user"])
            }
        }
    }

    Register-Reaction '^ping$' { "Pong" }
    Register-Reaction '^time$' { Get-Date }
    # TODO: Load more of these from files...
}

Export-ModuleMember -Function Register-Reaction, Unregister-Reaction, Get-Reaction, Start-Adapter