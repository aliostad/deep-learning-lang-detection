# HipChat functions
# t.r.parkinson@sheffield.ac.uk
#-requires version 3.0

#region Helpers

function Test-HipChatRate {
throw "not implemented yet"
}

function Set-HipChatRate {
throw "not implemented yet"
}

function Invoke-HipChatMethod {
throw "not implemented yet"
}

function Initialize-HipChat {
    [CmdletBinding(DefaultParameterSetName='File')]

    param(
        [Parameter(ParameterSetName='File')]
        $Path=(Join-Path -Path $PSScriptroot -ChildPath 'token.txt'),
        [Parameter(ParameterSetName='Token')]
        $Token
    )
    
    begin {}

    process {
        if (-not $Token) {
            if (Test-Path -Path $Path) {
                $Token = Get-Content -Path $Path
            } else {
                throw "Token file not found"
            }
        }

        $script:Token = $Token
        
    }

    end {}

}


#endregion

#region Room API
function Send-HipChatMessage {
<#
#>
    [CmdletBinding(DefaultParameterSetName='HTMLConversion')]

    param(
        [Parameter(Position=0,
                   ValueFromPipeline=$true,
                   Mandatory=$true)]
        $Message,
        [Parameter(Position=1)]
        [String]$Room,
        [Parameter(Position=2)]
        [ValidateLength(1,15)]
        [ValidatePattern('^[a-zA-Z_\-\s\d]*$')]
        [String]$From='Powershell',
        [Parameter(Position=3)]
        [ValidateSet('html','text')]
        [String]$MessageFormat = 'text',
        [Parameter(Position=4)]
        [ValidateSet('json','xml')]
        [String]$ResponseFormat = 'json',
        [Parameter(Position=5)]
        [ValidateSet('yellow','red','green','purple','gray','random')]
        [Alias('Color')]
        [String]$Colour,
        [Parameter(Position=6)]
        [Switch]$Notify,
        [Parameter(Position=7)]
        [String]$Endpoint = 'https://api.hipchat.com/v1/rooms/message',
        [Parameter(Position=8)]
        [String]$Token = $script:Token,
        [Parameter()]
        [Switch]$Test,
        [Parameter()]
        [Switch]$PassThru,
        [Parameter(ParameterSetName='HTMLConversion')]
        [Switch]$HTML,
        [Parameter(ParameterSetName='HTMLPreformatted')]
        [Switch]$HTMLPreformatted

    )

    begin {
        Write-Verbose "Constructing API Url for message send"

        if ($Test) {
            $url = "$($Endpoint)?format=$ResponseFormat&auth_token=$Token&test=true"
        } else {
            $url = "$($Endpoint)?format=$ResponseFormat&auth_token=$Token"
        }
        Write-Verbose "URL: $url"

        if ($Notify) {
            [Int32]$Notify = 1
        }

        $input_objects = @()

    }

    process {
        $input_objects += $Message
        if ($PassThru) {
            Write-Output $Message
        }
    }

    end {

        if ($HTML) {
            $message_string = $input_objects | ConvertTo-Html | out-string

            if ($message_string.Length -gt 10000) {
                throw "Output too large, consider using reducing"
            } else {
                                
                Write-Verbose "Constructing body of request $_"
                $body = @{
                    'room_id'=$Room
                    'from'=$From
                    'message'=$message_string
                    'message_format'='html'
                    'notify'=$Notify
                    'color'=$colour
                    'format'=$ResponseFormat
                }

                $response = Invoke-RestMethod -Method Post -Uri $url -Body $body

                #TODO: Support XML response too
                if ($response.Status -ne 'sent') {
                    Write-Warning 'Message not sent'
                }
            }
        } elseif ($HTMLPreformatted) {
            $input_objects |
                ForEach-Object {
                    $Message = $_

                    Write-Verbose "Constructing body of request $_"
                    $body = @{
                        'room_id'=$Room
                        'from'=$From
                        'message'=$Message
                        'message_format'='html'
                        'notify'=$Notify
                        'color'=$colour
                        'format'=$ResponseFormat
                    }

                    $response = Invoke-RestMethod -Method Post -Uri $url -Body $body 
                
                    #TODO: Support XML response too
                    if ($response.Status -ne 'sent') {
                        Write-Warning 'Message not sent'
                    }
                
                }
        } else {
            $message_string = ($input_objects | Out-String).TrimEnd()
            $length = 10000
            0..[Math]::Floor($message_string.Length/$length) |
                ForEach-Object {
                    $start = $_ * $length
                
                    if ($length -gt ($message_string.Length - $start)) {
                        $length = ($message_string.Length - $start)
                    }
                    $Message = $message_string.Substring($start,$length)

                    Write-Verbose "Constructing body of request $_"
                    $body = @{
                        'room_id'=$Room
                        'from'=$From
                        'message'=$Message
                        'message_format'=$MessageFormat
                        'notify'=$Notify
                        'color'=$colour
                        'format'=$ResponseFormat
                    }

                    $response = Invoke-RestMethod -Method Post -Uri $url -Body $body
                
                    #TODO: Support XML response too
                    if ($response.Status -ne 'sent') {
                        Write-Warning 'Message not sent'
                    }
            }
        }
        

    }
}

function New-HipChatRoom {
throw "not implemented yet"
}

function Remove-HipChatRoom {
throw "not implemented yet"
}

function Get-HipChatHistory {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true,
                    Position=0)]
        $Room,
        [Parameter(Position=1)]
        $Date = 'recent',
        [Parameter(Position=2)]
        $Timezone = 'UTC',
        [Parameter(Position=3)]
        $Format = 'json',
        [Parameter(Position=4)]
        [String]$Endpoint = 'https://api.hipchat.com/v1/rooms/history',
        [Parameter(Position=5)]
        [String]$Token = $script:Token
    )

    begin {
        Write-Verbose "Constructing API URL for history"
        $url = "$($Endpoint)?format=$ResponseFormat&auth_token=$Token&room_id=$Room&date=$Date&timezone=$Timezone&format=$Format"

    }

    process {
        $response = Invoke-RestMethod -Method GET -Uri $url 

        $response.messages
    }

    end {}
}

function Get-HipChatRoomList {
throw "not implemented yet"
}

function Get-HipChatTopic {
throw "not implemented yet"
}

function Get-HipChatRoom {
throw "not implemented yet"
}
#endregion

#region User API
function New-HipChatUser {
throw "not implemented yet"
}

function Remove-HipChatUser {
throw "not implemented yet"
}

function Get-HipChatUserList {
throw "not implemented yet"
}

function Get-HipChatUser {
throw "not implemented yet"
}

function Restore-HipChatUser {
throw "not implemented yet"
}

function Set-HipChatUser {
throw "not implemented yet"
}

#endregion
