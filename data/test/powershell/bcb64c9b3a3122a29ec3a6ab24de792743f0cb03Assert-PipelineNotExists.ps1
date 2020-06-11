function Assert-PipelineNotExists
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowNull()]
        [System.Object]
        $InputObject,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false, Position = 0)]
        [System.Management.Automation.ScriptBlock]
        $Predicate,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('Any', 'Single', 'Multiple')]
        [System.String]
        $Quantity = 'Any'
    )

    begin
    {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference') -as [System.Management.Automation.ActionPreference]
        }

        if ($PSBoundParameters.ContainsKey('InputObject')) {
            $PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newPipelineArgumentOnlyError -functionName $PSCmdlet.MyInvocation.MyCommand.Name -argumentName 'InputObject' -argumentValue $InputObject))
        } else {
            #NOTE
            #
            #If StrictMode is on, and the $InputObject pipeline variable has no value (because process block does not run),
            #then using the $InputObject variable in the end block will generate an error.
            #Specifying a default value for $InputObject in the param block does not work.
            #Specifying a default value for $InputObject in the begin block is the least confusing option.
            #Even if the $InputObject pipeline variable is not used in the end block, just set it anyway so StrictMode will definitely work.
            $InputObject = $null
        }

        $found = 0
        $runPredicate = $true
        [System.Int32]$index = -1
    }

    process
    {
        if ($runPredicate) {
            $index++
            $result = $null
            try   {$result = do {& $Predicate $InputObject $index} while ($false)}
            catch {$PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newPredicateFailedError -errorRecord $_ -predicate $Predicate))}

            if (($result -is [System.Boolean]) -and $result) {
                $found++
                $earlyFail = ($Quantity -eq 'Any') -or (($found -gt 1) -and ($Quantity -eq 'Multiple'))

                if ($earlyFail) {
                    $message = & $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionStatus -invocation $MyInvocation -fail

                    Write-Verbose -Message $message

                    if (-not $PSBoundParameters.ContainsKey('Debug')) {
                        $DebugPreference = [System.Int32]($PSCmdlet.GetVariableValue('DebugPreference') -as [System.Management.Automation.ActionPreference])
                    }
                    Write-Debug -Message $message
                    $PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionFailedError -message $message -innerException $null -value $InputObject))
                }
            }

            $runPredicate = -not (($found -gt 1) -and ($Quantity -eq 'Single'))
        }

        ,$InputObject
    }

    end
    {
        $exists =
            (($found -gt 0) -and ($Quantity -eq 'Any')) -or
            (($found -eq 1) -and ($Quantity -eq 'Single')) -or
            (($found -gt 1) -and ($Quantity -eq 'Multiple'))

        $fail = $exists

        if ($fail -or ([System.Int32]$VerbosePreference)) {
            $message = & $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionStatus -invocation $MyInvocation -fail:$fail

            Write-Verbose -Message $message

            if ($fail) {
                if (-not $PSBoundParameters.ContainsKey('Debug')) {
                    $DebugPreference = [System.Int32]($PSCmdlet.GetVariableValue('DebugPreference') -as [System.Management.Automation.ActionPreference])
                }
                Write-Debug -Message $message
                $PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionFailedError -message $message -innerException $null -value $null))
            }
        }
    }
}
