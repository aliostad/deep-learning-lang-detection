function Out-Stream
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
        Position = 0)]
        [string[]] $Message
    )

    Begin {}

    Process {
        foreach ($output in $Message)
        {
            if (!$Global:isMuted)
            {
                $Global:messageTextArea.SendKeys($output)
                $Global:chatSendButton.Click()
            }
        }
    }

    End {}
}
