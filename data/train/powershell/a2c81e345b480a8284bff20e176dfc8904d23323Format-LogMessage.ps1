function Format-LogMessage {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Message,

        [Parameter(Mandatory = $false, Position = 1)]
        [System.Management.Automation.ErrorRecord] $Error
    )

    $formatstring = "{0} : {1}`n{2}`n" +
                    "        + CategoryInfo          : {3}`n" +
                    "        + FullyQualifiedErrorId : {4}`n"

    if ($Error) {
        $Message += $($formatstring -f @(
                $Error.InvocationInfo.MyCommand.Name,
                $Error.ErrorDetails.Message,
                $Error.InvocationInfo.PositionMessage,
                $Error.CategoryInfo.ToString(),
                $Error.FullyQualifiedErrorId
        ))
    }

    return $Message
}