namespace Route4MeSdk.FSharp

open System
open System.Collections.Generic
open FSharpExt
open FSharp.Data
open Newtonsoft.Json
open Newtonsoft.Json.Linq

type ActivityQuery = {
    [<JsonProperty("route_id")>]
    RouteID :  string

    [<JsonProperty("device_id")>]
    DeviceID : string 

    [<JsonProperty("activity_type")>]
    Type :     ActivityType 

    [<JsonProperty("member_id")>]
    MemberID : int 

    [<JsonProperty("team")>]
    Team :   bool 

    [<JsonProperty("limit")>]
    Limit :  uint32 

    [<JsonProperty("offset")>]
    Offset : uint32 

    [<JsonProperty("start")>]
    Start :  uint32

    [<JsonProperty("end")>]
    End :    uint32 }

[<CLIMutable>]
type Activity = {
    [<JsonProperty("activity_id")>]
    Id : string 
    
    [<JsonProperty("activity_type")>]
    Type : ActivityType 
    
    [<JsonProperty("activity_timestamp")>]
    Timestamp : uint64
    
    [<JsonProperty("activity_message")>]
    Message : string
    
    [<JsonProperty("route_destination_id")>]
    RouteId : string
    
    [<JsonProperty("route_name")>]
    RouteName : string

    [<JsonProperty("note_id")>]
    NoteId : string

    [<JsonProperty("note_type")>]
    NoteType : string

    [<JsonProperty("note_contents")>]
    NoteContents : string

    [<JsonProperty("note_file")>]
    NoteFile : string

    [<JsonProperty("member")>]
    Member : Member }

    with
        static member Get(?routeId, ?deviceId, ?activityType:ActivityType, ?memberId, ?apiKey) =
            let query = 
                [ routeId |> Option.bind Option.ofString |> Option.map(fun value -> "route_id", value)
                  deviceId |> Option.bind Option.ofString |> Option.map(fun value -> "device_id", value) 
                  memberId |> Option.bind Option.ofString |> Option.map(fun value -> "member_id", value) 
                  activityType |> Option.map(fun value -> "activity_type", value.GetStringValue())
                ]
                |> List.choose id
            
            Api.Get(Url.V4.activityFeed, [], query, apiKey)
            |> Result.map(fun json -> 
                let dict = Api.Deserialize<Dictionary<string,obj>>(json)
                let results = dict.["results"] :?> JArray
                let itemsJson = results.ToString()
                Api.Deserialize<Activity[]>(results.ToString()))

        static member LogMessage(routeId, message, ?apiKey) = 
            let body = 
                [ "route_id", routeId
                  "activity_message", message
                  "activity_type", ActivityType.UserMessage.GetStringValue()
                ]
                |> dict
            
            Api.Post(Url.V4.activityFeed, [], [], apiKey, body)
            |> Result.map(fun json ->
                let dict = Api.Deserialize<Dictionary<string,obj>>(json)
                dict.["status"] :?> bool)