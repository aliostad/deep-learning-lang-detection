<#
.Synopsis
   Call the Convenus API to get the room status.
.DESCRIPTION
   Given a list of room, call the Convenus API to get the room status.
.EXAMPLE
   "bojackson@hudl.com", "gordie@hudl.com" | Get-RoomStatus
#>
function Get-RoomStatus
{
    [CmdletBinding()]
    Param
    (
        # List of room
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $Room
    )

    Begin
    {
        $result = @{}
    }
    Process
    {
        $url = "http://calendars/api/rooms/$Room/minutes/5"
        $status = Invoke-RestMethod $url
        $result += @{"$Room" = $status}
    }
    End
    {
        return $result
    }
}

$jsonFile = "C:\Temp\devices.json"
$jsonObj = Get-Content $jsonFile -Raw | ConvertFrom-Json
$rooms=@{}
foreach ($p in $jsonObj.rooms.psobject.properties.name){
    $rooms[$p]=$jsonObj.rooms.$p
}

$result = $rooms.Keys | Get-RoomStatus
foreach ($r in $result.GetEnumerator()){
    $deviceId = $rooms[$($r.Name)]
    $status = $r.Value
    $url = "https://api.spark.io/v1/devices/$deviceId/led"
    $postParams = @{access_token=$env:SparkCoreAccessToken;params="$status"}
    Invoke-RestMethod $url -Method Post -Body $postParams
}