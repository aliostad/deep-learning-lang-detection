# =============================================================================
# Author:       Chuck Spencer Jr.
# Create date: 	03/16/2015
# Description:	IRC Module
# Version:      3.0
# =============================================================================

function Send-IRCCommand {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, Position=0)]
        [array]$session, 

        [parameter(Mandatory=$true, Position=1)]
        [string[]]$command
    ) 

    $session.Writer.WriteLine($command);
    $session.Writer.Flush();

   <#

    .SYNOPSIS
    Send IRC Command.
    
    .DESCRIPTION
    Sends a command to an IRC server via session.

    .PARAMETER session
    Server session.

    .PARAMETER command
    Command to send.

    #>
}
Export-ModuleMember -function Send-IRCCommand

function Connect-IRCChannel {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, Position=0)]
        [array]$session, 

        [parameter(Mandatory=$true, Position=1)]
        [string[]]$user, 

        [parameter(Mandatory=$true, Position=2)]
        [string[]]$pwd, 

        [parameter(Mandatory=$true, Position=3)]
        [string[]]$nick, 

        [parameter(Mandatory=$true, Position=4)]
        [string[]]$realname, 

        [parameter(Mandatory=$true, Position=5)]
        [string[]]$channel
    )

    begin {}

    process {
        Send-IRCCommand $session "PASS $($pwd)";

        Send-IRCCommand $session "NICK $($nick)";

        Send-IRCCommand $session "USER $($user) 8 * :$($realname)";

        Send-IRCCommand $session "JOIN $($channel)";
    }

    end {}

   <#

    .SYNOPSIS
    Connect to IRC Channel.
    
    .DESCRIPTION
    Sends a command to connect to channel.

    .PARAMETER session
    IRC session.

    .PARAMETER user
    User to login as.

    .PARAMETER pwd
    Password.

    .PARAMETER nick
    Nickname for login.

    .PARAMETER realname
    Real Name for login.

    .PARAMETER channel
    Channel to connect too.

    #>
}
Export-ModuleMember -function Connect-IRCChannel

function Disconnect-IRCChannel {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, Position=0)]
        [array]$session, 

        [parameter(Mandatory=$true, Position=1)]
        [string[]]$channel
    ) 

    begin {}

    process {
        Send-IRCCommand $session "PART $($channel)";

        Send-IRCCommand $session "QUIT :bye bye";
    }

    end {}

   <#

    .SYNOPSIS
    Disconnect from IRC Channel
    
    .DESCRIPTION
    Send commands to disconnect from channel.

    .PARAMETER session
    IRC session.

    .PARAMETER channel
    Channel to connect too.

    #>
}
Export-ModuleMember -function Disconnect-IRCChannel

function Send-IRCPrivMsg {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, Position=0)]
        [array]$session, 

        [parameter(Mandatory=$true, Position=1)]
        [string[]]$channel, 

        [parameter(Mandatory=$true, Position=2)]
        [string[]]$message
    )

    begin {}

    process {
        $message = $message.Trimend();

	    if ($message -eq "") { $message = "-" }

        Send-IRCCommand $session "PRIVMSG $($channel) :$($message)";
    }

    end {}

   <#

    .SYNOPSIS
    Send private message.
    
    .DESCRIPTION
    Sends a private message to and IRC channel.

    .PARAMETER session
    Server session.

    .PARAMETER channel
    Channel to send too.

    .PARAMETER message
    Message to send.

    #>
}
Export-ModuleMember -function Send-IRCPrivMsg

function Send-IRCNotice {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, Position=0)]
        [array]$session, 

        [parameter(Mandatory=$true, Position=1)]
        [string[]]$channel, 

        [parameter(Mandatory=$true, Position=2)]
        [string[]]$message
    )

    begin {}

    process {
        $message = $message.Trimend();

	    if ($message -eq "") { $message = "-" }	

        Send-IRCCommand $session "NOTICE $($channel) :$($message)";
    }

    end {}

   <#

    .SYNOPSIS
    Send notification message.
    
    .DESCRIPTION
    Sends a notification message to and IRC channel.

    .PARAMETER session
    Server session.

    .PARAMETER channel
    Channel to send too.

    .PARAMETER message
    Message to send.

    #>
}
Export-ModuleMember -function Send-IRCNotice
