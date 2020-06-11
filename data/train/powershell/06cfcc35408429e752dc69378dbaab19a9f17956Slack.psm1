
Function Send-SlackAlert
{
    param (
        [string]$Webhook,
        [string]$Channel="",
        [string]$SourceHost="",
        [string]$Source="",
        [string]$Severity="",
        [string]$Message,
        [string]$User="Powershell",
        [string]$IconURL="",
        [string]$Color="danger",
        [bool]$Codeblock=$true
    )

    if (($Webhook -eq "") -or ($Message -eq "")) {
        Write-Host "Usage: Send-Slackalert -Webhook ""<Webhook service ID>"" -Channel ""slack channel name (without #)"" -SourceHost ""<hostname>"" -Source ""<source name>"" -Severity ""<severity text>"" -User ""<user name>"" -IconURL ""<URL to png>"" -Color ""<name or RGB>"" -Codeblock ""<boolean>"" -Message ""<message>"""
        break
    }

    if ($Channel.StartsWith("#")) {
        $Channel=$Channel.TrimStart(1)
    }
    if ($Webhook.StartsWith("/")) {
        $Channel=$Channel.TrimStart(1)
    }

    if ($Codeblock) {
        $Message = "``````$Message``````"
    }
  
    $payload = @{channel="#$Channel";username="$User";icon_url="$IconURL";
        attachments=@(
            @{
                fallback="[$SourceHost][$Severity]";
                pretext="*Source: $Source*";
                text="$Message";
                color="$Color";
                mrkdwn_in=@("pretext","text");
                fields=@(
                    @{title="Host";value="$SourceHost";short=$true},
                    @{title="Severity";value="$Severity";short=$true}
                )
            }
        )
   }
      
    $payload =  [System.Text.Encoding]::UTF8.GetBytes($(convertTo-JSON -depth 6 $payload))
 
    Invoke-RestMethod -Uri "https://hooks.slack.com/services/$Webhook" -Method Post -Body ($payload)
}

Function Send-SlackMessage
{
    param (
        [string]$Webhook,
        [string]$Channel="",
        [string]$Message,
        [string]$User="Powershell",
        [string]$IconURL=""
    )

    if (($Webhook -eq "") -or ($Message -eq "")) {
        Write-Host "Usage: Send-SlackMessage -Webhook ""<Webhook service ID>"" -Channel ""slack channel name (without #)"" -User ""<user name>"" -IconURL ""<URL to png>"" -Message ""<message>"""
        break
    }

    if ($Channel.StartsWith("#")) {
        $Channel=$Channel.TrimStart(1)
    }
    if ($Webhook.StartsWith("/")) {
        $Channel=$Channel.TrimStart(1)
    }
  
    $payload = @{channel="#$Channel";username="$User";icon_url="$IconURL";text="$Message";color="good";}      
    $payload =  [System.Text.Encoding]::UTF8.GetBytes($(convertTo-JSON -depth 6 $payload))
 
    Invoke-RestMethod -Uri "https://hooks.slack.com/services/$Webhook" -Method Post -Body ($payload)
}

Export-ModuleMember -Function Send-SlackAlert
Export-ModuleMember -Function Send-SlackMessage
