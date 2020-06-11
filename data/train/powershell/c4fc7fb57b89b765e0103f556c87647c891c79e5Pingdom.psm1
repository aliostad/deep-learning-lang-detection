Set-Variable -Name pingdom_api -Value "" -Option Constant
Set-Variable -Name pingdom_user -Value "" -Option Constant
Set-Variable -Name pingdom_credentials -Value ([System.Management.Automation.PSCredential]::Empty) -Option AllScope

$pingdom_urls = New-Object PSObject -Property @{
    Checks="https://api.pingdom.com/api/2.0/checks"
    CheckDetails="https://api.pingdom.com/api/2.0/checks/{0}"
    Contacts="https://api.pingdom.com/api/2.0/contacts"
    ContactDetails="https://api.pingdom.com/api/2.0/contacts/{0}"
    RawApiRequest="https://api.pingdom.com/api/2.0/{0}"
}

$pingdom_output = New-Object PSObject -Property @{
}

$pingdom_error_data = New-Object PSObject -Property @{ 
    NoAppName="No Pingdom Check was found of Name : {0}."  
    NoAppId="No Pingdom Check was found of ID : {0}."
}

function __ConvertFrom-Json
{
    param(
        [Parameter(ValueFromPipeline=$true,Position=0)]
        [string] $json
    )

    begin {
        $state = New-Object PSObject -Property @{
            ValueState = $false
            ArrayState = $false
            StringStart = $false
            SaveArray = $false
        }

        $json_state = New-Object PSObject -Property @{
            Space = " "
            Comma = ","
            Quote = '"'
            NewObject = "(New-Object PSObject "
            OpenParenthesis = "@("
            CloseParenthesis = ")"
            NewProperty = '| Add-Member -Passthru NoteProperty "'
        }

        function Convert-Character
        {
            param( [string] $c )

            switch -regex ($c) {
                '{' { 
                    $state.SaveArray = $state.ArrayState
                    $state.ValueState = $state.StringStart = $state.ArrayState = $false				
                    return  $json_state.NewObject
                }

                '}' { 
                    $state.ArrayState  = $state.SaveArray 
                    return $json_state.CloseParenthesis
                }

                '"' {
                    if( !$state.StringStart -and !$state.ValueState -and !$state.ArrayState ) {
                        $str = $json_state.NewProperty
                    }
                    else { 
                        $str = $json_state.Quote
                    }
                    $state.StringStart = $true
                    return $str
                    
                }

                ':' { 
                    if($state.ValueState) { return $c } 
                    else { $state.ValueState = $true; return $json_state.Space }
                }

                ',' {
                    if($state.ArrayState) { return $json_state.Comma }
                    else { $state.ValueState = $state.StringStart = $false }
                }
                	
                '\[' { 
                    $state.ArrayState = $true
                    return $json_state.OpenParenthesis
                }
                
                '\]' { 
                    $state.ArrayState = $false 
                    return $json_state.CloseParenthesis
                }
                
                "[a-z0-9A-Z/@.?()%=&\- ]" { return $c }
                "[\t\r\n]" {}
            }
        }
    	
    }

    process { 
        $result = New-Object -TypeName "System.Text.StringBuilder"
        foreach($c in $json.ToCharArray()) { 
            [void] $result.Append((Convert-Character $c))
        }
    }

    end {
        return (Invoke-Expression $result)
    }
}

function __Get-PingdomWebClient
{
    $web_client = New-Object System.Net.WebClient
    $web_client.Headers.Add("App-Key", $pingdom_api)

    if($pingdom_credentials -eq [System.Management.Automation.PSCredential]::Empty) {
        $pingdom_credentials = Get-Credential $pingdom_user 
    }
    $web_client.Credentials = $pingdom_credentials
    
    return $web_client
}

function __Update-PingdomAppMonitoring
{
    param(
        [Parameter(Mandatory=$true)]
        [string] $id,
        [Parameter(Mandatory=$true)]
        [string] $state
    )

    if( $id -eq 0 ) { return }
    
    Write-Verbose "[ $(Get-Date) ] - Setting Pingdom URL Monitoring for Application Id - $id - to $state . . ."

    $wc = __Get-PingdomWebClient
	$result = $wc.UploadString(($pingdom_urls.CheckDetails -f $id), "PUT", ("paused={0}" -f $state)) 
    return ( $result )
}

function __Convert-UnixTimeStamp
{
    param( [string] $seconds)
    return ( [TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($seconds)) )
}

function Get-PingdomRawApiRequest
{
    param(
        [Parameter(Mandatory=$true)]
        [string] $api
    )

    $wc = __Get-PingdomWebClient
    $response = $wc.DownloadString($pingdom_urls.RawApiRequest -f $api) | __ConvertFrom-Json 
    return $response
}

function Get-PingdomChecks
{
    $wc = __Get-PingdomWebClient
    $checks = $wc.DownloadString($pingdom_urls.Checks) | __ConvertFrom-Json | Select-Object -ExpandProperty Checks 
    
    $pingdom_checks = @()
    foreach ($check in $checks) {
	    $pingdom_checks += (New-Object PSObject -Property @{
            Name = $check.Name
            HostName = $check.HostName
            ID = $check.id
            Type = $check.Type 
            Status = $check.Status
            LastErrorTime =  (__Convert-UnixTimeStamp -seconds $check.lasterrortime)
            LastTestTime =  (__Convert-UnixTimeStamp -seconds $check.lasttesttime)
            Created =  (__Convert-UnixTimeStamp -seconds $check.created)
        })
    }
    
    return $pingdom_checks
}

function Get-PingdomCheckDetails
{
    param(
        [Parameter(ParameterSetName="Name",Mandatory=$true)]
        [string] $name,

        [Parameter(ParameterSetName="ID",Mandatory=$true)]
        [int] $id,

        [Parameter(ParameterSetName="Object",Mandatory=$true, ValueFromPipeline=$true)]
        [System.Management.Automation.PSObject] $check
    )

    begin { 
        $pingdom_check_details = @()
    }

    process {
        if($PsCmdlet.ParameterSetName -eq "Name") {
            $id = Get-PingdomChecks | Where { $_.Name -eq $Name } | Select -ExpandProperty Id

            if(!$id) {
                throw ($pingdom_error_data.NoAppName -f $name)
            }
        }elseif($PsCmdlet.ParameterSetName -eq "Object" ) {
            $id = $check.Id
        }

        $wc = __Get-PingdomWebClient
        $response = $wc.DownloadString(($pingdom_urls.CheckDetails -f $id)) | __ConvertFrom-Json | Select-Object -ExpandProperty Check

        if(!$response) {
            throw ($pingdom_error_data.NoAppId -f $id)
        }

        $tmp = New-Object PSObject -Property @{
            Name = $response.Name
            HostName = $response.HostName
            ID = $response.id
            UrlMonitor = $response.Type.Http.Url
            Status = $response.Status
            LastErrorTime =  (__Convert-UnixTimeStamp -seconds $response.lasterrortime)
            LastTestTime =  (__Convert-UnixTimeStamp -seconds $response.lasttesttime)
            Created =  (__Convert-UnixTimeStamp -seconds $response.created)
            SendToEmail = $response.SendToEmail
            SendToSMS = $response.SendToSMS
            SendToTwitter = $response.SendToTwitter
            Contacts = (Get-PingdomContact -id $response.contactids)
        }

        $pingdom_check_details += $tmp

    }
    end {
        return $pingdom_check_details
    }
}

function Get-PingdomContact
{
    param(
        [string] $id
    )

    $wc = __Get-PingdomWebClient
    $contact_names = [string]::join(";", ($wc.DownloadString($pingdom_urls.ContactDetails -f $id) | __ConvertFrom-Json | Select-Object -ExpandProperty Contacts | Select -ExpandProperty Name))
    
    return $contact_names
}

function Get-PingdomContacts
{
    $wc = __Get-PingdomWebClient
    $contacts = $wc.DownloadString($pingdom_urls.Contacts) | __ConvertFrom-Json | Select-Object -ExpandProperty Contacts 
    
    $pingdom_contacts = @()
    foreach ($contact in $contacts) {
	    $pingdom_contacts += (New-Object PSObject -Property @{
            Name = $contact.Name
            ID = $contact.id
            Email = $contact.Email
            Twitter = $contact.directtwitter
            Type = $contact.Type
            CellPhone = $contact.CellPhone
        })
    }
    
    return $pingdom_contacts
}

function Enable-PingdomAppMonitoring
{
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $id
    )

    begin {
        Set-Variable -Name state -Value "false" -Option Constant
        Set-Variable -Name result 
    }
    process {
        $result = __Update-PingdomAppMonitoring -id $id -state $state
    }
    end {
        Write-Verbose -Message ("Return Result - {0}" -f $result)
    }
}

function Disable-PingdomAppMonitoring
{
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $id
    )

    begin {
        Set-Variable -Name state -Value "true" -Option Constant
        Set-Variable -Name result 
    }
    process {
        $result = __Update-PingdomAppMonitoring -id $id -state $state
    }
    end {
        Write-Verbose -Message ("Return Result - {0}" -f $result)
    }
}

Export-ModuleMember -Function Enable-PingdomAppMonitoring, Disable-PingdomAppMonitoring, Get-PingdomChecks, Get-PingdomCheckDetails, Get-PingdomContacts, Get-PingdomContact, Get-PingdomRawApiRequest