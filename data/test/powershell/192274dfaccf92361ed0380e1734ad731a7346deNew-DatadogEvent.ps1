function New-DataDogEvent {
    <#
    .Synopsis
        This function creates a new event in Datadog using the REST API
    .Example
        new-DataDogEvent -title "A new Apache event" -text "Alert, Apache is down" -ApiKey "a380b2d7af02b3fa720eb20512345678"
    .Parameter title
        Provide a title for the event
    .Parameter text
        Provide a text for the event
    .Parameter ApiKey
        Provide your API key for authentication, see at https://app.datadoghq.com/account/settings#api
    .Notes
        NAME: new-DataDogEvent
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true
        ,Position=1
        ,HelpMessage="Provide a title for the event")]
        [String]$title
        ,
        [Parameter(Mandatory=$true
        ,Position=2
        ,HelpMessage="Provide a text for the event")]
        [String]$text
        ,
        [Parameter(Mandatory=$true
        ,Position=3
        ,HelpMessage="Provide your API key ")]
        [String]$ApiKey
    )
    Process {
        #create an array, add the mandatory 'title' and 'text' arguments, then convert to json
        $obj=@{}
        $obj.add("title",$title)
        $obj.add("text",$text)
        $json=$obj | ConvertTo-Json

        #set the proper Header and forge the URL
        $ContentType="application/json"
        $DDUrl="https://app.datadoghq.com/api/v1/events?api_key=$ApiKey"

        Invoke-RestMethod -Method Post -ContentType $ContentType -Uri $DDUrl -Body $json
    }
}


