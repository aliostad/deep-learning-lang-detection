﻿function Remove-DbaCmConnection {
    <#
    .SYNOPSIS
    Removes connection objects from the connection cache used for remote computer management.

    .DESCRIPTION
    Removes connection objects from the connection cache used for remote computer management.

    .PARAMETER ComputerName
    The computer whose connection to remove.
    Accepts both text as well as the output of Get-DbaCmConnection.

    .PARAMETER Silent
    Replaces user friendly yellow warnings with bloody red exceptions of doom!
    Use this if you want the function to throw terminating errors you want to catch.
	
	.NOTES
	Author: Fred Winmann (@FredWeinmann)
	Tags: ComputerManagement
	
	Website: https://dbatools.io
	Copyright: (C) Chrissy LeMaire, clemaire@gmail.com
	License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0

	.LINK
	https://dbatools.io/Remove-DbaCmConnection

    .EXAMPLE
    Remove-DbaCmConnection -ComputerName sql2014

    Removes the cached connection to the server sql2014 from the cache.

    .EXAMPLE
    Get-DbaCmConnection | Remove-DbaCmConnection

    Clears the entire connection cache.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [Sqlcollaborative.Dbatools.Parameter.DbaCmConnectionParameter[]]
        $ComputerName,

        [switch]
        $Silent
    )

    BEGIN {
        Write-Message -Level InternalComment -Message "Starting"
        Write-Message -Level Verbose -Message "Bound parameters: $($PSBoundParameters.Keys -join ", ")"
    }
    PROCESS {
        foreach ($connectionObject in $ComputerName) {
            if (-not $connectionObject.Success) { Stop-Function -Message "Failed to interpret computername input: $($connectionObject.InputObject)" -Category InvalidArgument -Target $connectionObject.InputObject -Continue }
            Write-Message -Level VeryVerbose -Message "Removing from connection cache: $($connectionObject.Connection.ComputerName)" -Target $connectionObject.Connection.ComputerName
            if ([Sqlcollaborative.Dbatools.Connection.ConnectionHost]::Connections.ContainsKey($connectionObject.Connection.ComputerName)) {
                $null = [Sqlcollaborative.Dbatools.Connection.ConnectionHost]::Connections.Remove($connectionObject.Connection.ComputerName)
                Write-Message -Level Verbose -Message "Successfully removed $($connectionObject.Connection.ComputerName)" -Target $connectionObject.Connection.ComputerName
            }
            else {
                Write-Message -Level Verbose -Message "Not found: $($connectionObject.Connection.ComputerName)" -Target $connectionObject.Connection.ComputerName
            }
        }
    }
    END {
        Write-Message -Level InternalComment -Message "Ending"
    }
}
