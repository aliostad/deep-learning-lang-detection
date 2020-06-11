<#
    .NOTES
    ===========================================================================
     Created on:    19-06-2014
     Created by:    admcso
     Organization:  Helsingor Kommune
     Filename:      Copy_groupmember.ps1
    ===========================================================================
    .DESCRIPTION
        Copies all members if one group to another

    .SYNOPSIS

    .PARAMETER fromgroup
     The fromgroup parameter is where you set the group that you want to copy the members of

    .PARAMETER togroup
     The togroup parameter is where you want to copy the members to

    .EXAMPLE
    PS C:\>.\Copy_groupmember.ps1 -fromgroup CE -togroup ØS

    .LINK
        http://msdn.microsoft.com/en-us/library/ms147785(v=vs.90).aspx
#>


param (
    [string]$fromgroup,
    [string]$togroup
    )
Get-ADGroupMember $fromgroup |  Get-ADUser | Foreach-Object {Add-ADGroupMember -Identity $togroup -Members $_}