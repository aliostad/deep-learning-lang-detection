#region Enumerations

Add-Type -TypeDefinition @"
    public enum DSCurrentUserContext {
        LocalMachine = 0,
        LocalComputer = LocalMachine,
        CurrentUser = 1,
        LoggedOnUser = CurrentUser
    }
"@

#endregion

function Initialize-ErrorRecord {
    <#
        Function will be removed once it is built out of module.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Message')]
    Param(
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $True, Position = 0)]
        [Management.Automation.ErrorRecord]$ErrorRecord,
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $False, Position = 1)]
        [Parameter(ParameterSetName = 'Message', Mandatory = $False, Position = 1)]
        [Object]$Object,
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $False, Position = 2)]
        [Parameter(ParameterSetName = 'Message', Mandatory = $False, Position = 2)]
        [String]$Title,
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $False, Position = 3)]
        [Parameter(ParameterSetName = 'Message', Mandatory = $False, Position = 3)]
        [Management.Automation.ErrorCategory]$ErrorCategory = 'NotSpecified',
        [Parameter(ParameterSetName = 'Message', Mandatory = $True, Position = 0)]
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $False, Position = 4)]
        [String]$ErrorMessage
    )
    switch ($PsCmdlet.ParameterSetName) {
        'Message' {
            $Exception = New-Object Exception $ErrorMessage
            $ErrorRecord = New-Object Management.Automation.ErrorRecord (
                $Exception,
                $ErrorMessage,
                $ErrorCategory,
                [System.Object]
            )
        }
    }
    if (!$Object) {
        $Object = $ErrorRecord.TargetObject
    }
    if (!$ErrorMessage) {
        $ErrorMessage = $ErrorRecord.Exception.GetBaseException().Message
    }
    if ($Title) {
        $ErrorMessage = "$Title : $ErrorMessage"
    }
    return New-Object Management.Automation.ErrorRecord (
        $ErrorRecord.Exception.GetBaseException(),
        $ErrorMessage,
        $ErrorCategory,
        $Object
    )
}

#region Function Module Members
# Dot source all .ps1-files 
if ($PSScriptRoot -eq $Null) {
    $ScriptRoot = (Resolve-Path $MyInvocation.MyCommand.Path).Path
} else {
    $ScriptRoot = $PSScriptRoot
}
Get-ChildItem -Path "$ScriptRoot\Functions" -Include *.ps1 -Recurse | Foreach-Object { 
    . $_.FullName 
}

Export-ModuleMember -Function @( Get-ChildItem "$ScriptRoot\Functions" -Include '*.ps1' -Recurse | ForEach-Object {
    $_.Name -replace ".ps1" } )

#endregion