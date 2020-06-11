function Add-PBCommand
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
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
        Position = 0)]
        [string] $InputMessage
    )

    $Command = ''
    $Message = ''
    $Admin = $false

    $InputParts = $InputMessage.Split('-')

    foreach ($Part in $InputParts)
    {
        switch -Wildcard ($Part)
        {
            'Command*'
            {
                $Command = ($Part.Substring(8)).Trim().Trim("'")
                if ($Command -notlike '!*')
                {
                    $Command = "!$Command"
                }
            }
            'Message*'
            {
                $Message = ($Part.Substring(8)).Trim().Trim("'")
            }
            'Admin*'
            {
                $Admin = $true
            }
        }
    }

    New-PBCommand -Command $Command -Message $Message -Admin:$Admin
    Out-Stream -Message "Added $(if ($Admin) { 'admin ' })command: $Command"
}
