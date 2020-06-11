# Poshbot - A simple API based bot framework for hipchat
# t.r.parkinson@sheffield.ac.uk
# requires -version 3.0

# Requires https://github.com/timparkinson/posh-hipchat

Set-Variable -Name "PoshbotBrains" -Value @{} -Scope Script

#region Invoke
function Start-Poshbot {
    [CmdletBinding(DefaultParameterSetName='File')]

    param(
        [Parameter(ParameterSetName='File')]
        $TokenPath=(Join-Path -Path $PSScriptroot -ChildPath 'token.txt'),
        [Parameter(ParameterSetName='Token')]
        $Token,
        [Parameter()]
        [String]$Name = 'Poshbot',
        [Parameter(Mandatory=$true)]
        [String]$Room,
        [Parameter()]
        [Scriptblock]$ScriptBlock={
            #Just echo what is said back to the room
            "@$from $instruction"
        },
        [Parameter()]
        $Sleep = 10,
        [Parameter()]
        $MessageHashFilePath = (Join-Path -Path $PSScriptroot -ChildPath 'messages.txt')
    )

    begin {

        Write-Verbose "Setting up"
        $messages_to_me_history = @{}
        if (-not (Test-Path -Path $MessageHashFilePath -IsValid)) {
            throw "Problem with Message Hash File Path"
        } elseif (Test-Path -Path $MessageHashFilePath) {
            Get-Content -Path $MessageHashFilePath |
                ForEach-Object {
                    $messages_to_me_history.$_ = $true   
            }
        }

        if (-not $Token) {
            if (Test-Path -Path $TokenPath) {
                $Token = Get-Content -Path $TokenPath
            } else {
                throw "Token file not found"
            }
        }

        $hash_algorithm = 'SHA1'
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($hash_algorithm)
        $encoder = New-Object System.Text.UTF8Encoding
    
        $ScriptBlock_text = @"
param(`$from,`$instruction)
$($Scriptblock.ToString())

"@

       $ScriptBlock = [scriptblock]::create($ScriptBlock_text)

           Write-Verbose "Registering HTML output type"
            Add-Type -TypeDefinition @"
            using System;
             
            public class PoshbotHTMLOutput
            {
                public String Content;
            }
"@

    }


    process {
        Write-Verbose "Entering Loop -functions: $functions"
        while ($true) {
            $hipchat_history = Get-HipChatHistory -Room $Room -Token $Token -ErrorAction Continue

            $hipchat_history | 
                Where-Object {$_.message -match "^(@)?$Name (?<instruction>.*)" } | 
                        ForEach-Object {
                            Write-Verbose "Matched a message"
                            $string_builder = New-Object System.Text.StringBuilder
                            $message_hash = $hasher.ComputeHash($encoder.GetBytes("$($_.date)$($_.from)$($_.message)"))
                            $message_hash |
                                ForEach-Object {
                                    [void]$string_builder.Append($_.ToString("x2"))
                                }
                            $message_hash_string = $string_builder.ToString()

                            Write-Verbose "Hash: $message_hash_string"
                            if (-not $messages_to_me_history.$message_hash_string) {
                                $messages_to_me_history.$message_hash_string = $true
                                $message_hash_string | Out-File -FilePath $MessageHashFilePath -Append
                                $from = $_.from.name -replace ' ', ''
                                $instruction = $matches.instruction

                                if ($from -ne $name) {
                                    Write-Verbose "Attempting to run ScriptBlock for $from ($instruction)"
                                    try {
                                        $reply = Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $from,$instruction 

                                        if ($reply) {
                                            if($reply.GetType().Name -eq 'PoshbotHTMLOutput') {
                                                Send-HipChatMessage -Message $reply.content -Room $Room -From $Name -Token $Token -MessageFormat html -HTMLPreformatted
                                            } else {
                                                Send-HipChatMessage -Message $reply -Room $Room -From $Name -Token $Token -MessageFormat Text
                                            }
                                        } else {
                                            Send-HipChatMessage -Message "@$from (problem) No reply to your instruction" -Room $Room -From $Name -Token $Token -MessageFormat Text
                                        }
                                    }

                                    catch {
                                        Write-Error "Problem invoking scriptblock for message from @$from $_"
                                        Send-HipChatMessage -Message "@$from (problem) Error executing command" -Room $Room -From $Name -Token $Token -MessageFormat Text
                                    }
                                } else {
                                    Write-Verbose "Ignore messages from $Name to $Name"
                                }
                            } else {
                                Write-Verbose "Hash already stored"
                            }
                }
                Start-Sleep -Seconds $Sleep
            }
    }

    end {}
}
#endregion


#region Brain
function Import-PoshbotBrain {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        $Brain
    )

    begin {
        
    }

    process {
        if (-not (Test-Path $script:PoshbotBrains.$Brain)) {
            New-Variable -Name "PoshbotBrain_$Brain" -Value @{} -Scope Script -Force
        } else {
            $brain_contents = @{}
            $brain_from_json = (Get-Content $script:PoshbotBrains.$Brain) -join "`n" | 
                ConvertFrom-Json 

            $brain_from_json | Get-Member -MemberType NoteProperty | 
                ForEach-Object {
                    $brain_contents.$($_.Name) = $brain_from_json.$($_.Name)
                }
            New-Variable -Name "PoshbotBrain_$Brain" -Value $brain_contents -Scope Script -Force
        }
    }


    end {}
}

function Save-PoshbotBrain {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        $Brain
    )

    begin {
        
        if (-not (Test-Path -IsValid $script:PoshbotBrains.$Brain)) {
            throw "Invalid path $($script:PoshbotBrains.$Brain)"
        }
    }

    process {
        Get-Variable -Name "PoshbotBrain_$Brain" -Scope Script -ValueOnly | ConvertTo-Json | Out-File -FilePath $script:PoshbotBrains.$Brain
    }

    end {}
}

function Get-PoshbotBrainValue {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        $Brain,
        [Parameter(Mandatory=$true)]
        $Key
    )

    begin {}

    process {
        (Get-Variable -Name "PoshbotBrain_$Brain").Value.$Key 
    }

    end {}
}

function Set-PoshbotBrainValue {
[CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        $Brain,
        [Parameter(Mandatory=$true)]
        $Key,
        [Parameter()]
        $Value
    )

    begin {}

    process {
        (Get-Variable -Name "PoshbotBrain_$Brain").Value.$Key = $Value
        Save-PoshbotBrain -Brain $Brain 
    }

    end {}
}

function Initialize-PoshbotBrain {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        $Path,
        [Parameter(Mandatory=$true)]
        $Brain
    )

    begin {
        $brain_path = Join-Path -Path $Path -ChildPath "$Brain.BRAIN"
        if ((Test-Path -Path $brain_path -IsValid)) {
            $script:PoshbotBrains.$Brain = $brain_path
        }
        
    }

    process {
        
    } 

    end {}
}

#endregion
