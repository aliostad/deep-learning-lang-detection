function Read-Stream
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
    Param ()

    $ChatMessages = $Global:PhantomJsDriver.FindElementsByClassName('lctv-premium')

    $Log = @()

    $LastTime = '0:00'
    $Seconds = 0
    foreach ($ChatMessage in $ChatMessages)
    {
        $Parts = ($ChatMessage.GetAttribute('innerHTML')).Split('>')
        
        $Time = $Parts[2].Replace('</small', '')

        if ($Time -like '*.*.*')
        {
            $OrigSeconds = $Seconds
            $Minutes = 0
            $Hours = 0

            if ($Second -ge 60)
            {
                $Minutes = $Seconds / 60
                $Seconds = $Seconds % 60
            }

            if ($Minutes -ge 60)
            {
                $Hours = $Minutes / 60
                $Minutes = $Minutes % 60
            }

            $Time = $Time.Replace('.','/') + ' ' + $Hours + ':' + $Minutes + ':' + $Seconds 
            $Seconds = $OrigSeconds + 1
        }
        else
        {
            if ($Time -eq $LastTime)
            {
                $Seconds++
                $Time = $Time + ':' + $Seconds
            } # Find a better way to do this, could cause issues with more than 60 messages a second
            else
            {
                $LastTime = $Time
                $Seconds = 0
            }
        }

        $Timestamp = Get-Date $Time
        $Name = $Parts[3].Replace('</a', '')
        $Message = $Parts[4]

        $Properties = @{
            'Timestamp' = $Timestamp
            'Name'  = $Name
            'Message' = $Message
        }
        $Result = New-Object -TypeName PSCustomObject -Property $Properties
        $Log += $Result
    }

    $Log
}
