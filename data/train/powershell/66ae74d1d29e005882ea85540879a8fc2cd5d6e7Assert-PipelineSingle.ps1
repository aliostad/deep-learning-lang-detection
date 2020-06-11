function Assert-PipelineSingle
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowNull()]
        [System.Object]
        $InputObject
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

        $anyItems = $false
    }

    process
    {
        if ($anyItems) {
            #fail immediately
            #do not wait for all pipeline objects

            $message = & $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionStatus -invocation $MyInvocation -fail

            Write-Verbose -Message $message

            if (-not $PSBoundParameters.ContainsKey('Debug')) {
                $DebugPreference = [System.Int32]($PSCmdlet.GetVariableValue('DebugPreference') -as [System.Management.Automation.ActionPreference])
            }
            Write-Debug -Message $message
            $PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionFailedError -message $message -innerException $null -value $InputObject))
        }

        $anyItems = $true
        ,$InputObject
    }

    end
    {
        $fail = -not $anyItems

        if ($fail -or ([System.Int32]$VerbosePreference)) {
            $message = & $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionStatus -invocation $MyInvocation -fail:$fail

            Write-Verbose -Message $message

            if ($fail) {
                if (-not $PSBoundParameters.ContainsKey('Debug')) {
                    $DebugPreference = [System.Int32]($PSCmdlet.GetVariableValue('DebugPreference') -as [System.Management.Automation.ActionPreference])
                }
                Write-Debug -Message $message
                $PSCmdlet.ThrowTerminatingError((& $_7ddd17460d1743b2b6e683ef649e01b7_newAssertionFailedError -message $message -innerException $null -value $InputObject))
            }
        }
    }
}
