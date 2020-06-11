function Edit-PBCommand
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

    $CmdIndex = 0
    $CmdFound = $false

    While (!$CmdFound -and $CmdIndex -ne ($Global:PBCommands | Measure-Object).Count)
    {
        if ($Command -eq $Global:PBCommands[$CmdIndex].Command)
        {
            $CmdFound = $true
            
            $Global:PBCommands[$CmdIndex].Message = $Message
            $Global:PBCommands[$CmdIndex].Admin = $Admin

            $PersistentPath = Join-Path -Path (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path) -ChildPath '\PersistentData\'
            $Global:PBCommands | Export-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'commands.csv')

            Out-Stream -Message "Edited $Command"
        }
        else
        {
            $CmdIndex++
        }
    }

    if (!$CmdFound)
    {
        Out-Stream -Message "Couldn't edit $Command, consider adding it"
    }
}