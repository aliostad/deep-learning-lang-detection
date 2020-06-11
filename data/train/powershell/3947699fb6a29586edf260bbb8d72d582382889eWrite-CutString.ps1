function Write-CutString {
    <#
    .Synopsis
       Helper method for simulating ellipsis in PSColor modified output
    .DESCRIPTION
       Helper method for simulating ellipsis in PSColor modified output
    .PARAMETER Message
        Message to modify
    .PARAMETER Length
        Length to limit output string to before inserting '...'
    .EXAMPLE
       Write-host ("{0,-18}" -f (Write-CutString $Mystring.Name 18)) -foregroundcolor "white" -noNewLine
    .LINK
       https://www.github.com/zloeber/OhMyPsh
    .NOTES
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Message,
        [Parameter(Position = 1)]
        [int]$Length
    )

    if ($message.length -gt $length) {
        return $message.SubString(0, $length-3) + '...'
    }

    return $message
}