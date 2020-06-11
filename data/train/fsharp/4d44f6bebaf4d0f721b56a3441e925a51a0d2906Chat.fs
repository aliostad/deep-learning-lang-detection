// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

    
module Chat

open System
open Wireclub.Boundary.Models
open Wireclub.Boundary.Chat
open Newtonsoft.Json
open Newtonsoft.Json.Linq

let directory () =
    Api.req<ChatDirectoryViewModel> "chat/directory" "get" []

let join slug update = async {
        let! resp = Api.req<JoinResult> ("chat/room/" + slug + "/join") "post" [ "update", if update then "true" else "false" ]
        let resp =
            match resp with
            | Api.ApiOk result ->
                try
                    let events = 
                        ChannelClient.deserializeEventList (JsonConvert.DeserializeObject result.Events :?> JToken) result.Channel.Id

                    Api.ApiOk (result, events)
                with
                | ex -> Api.Exception ex
            | Api.BadRequest result -> Api.BadRequest result
            | Api.Unauthorized -> Api.Unauthorized
            | Api.Timeout -> Api.Timeout
            | Api.HttpError (code, desc) -> Api.HttpError (code, desc)
            | Api.Deserialization (ex, key) -> Api.Deserialization (ex, key)
            | Api.Exception ex -> Api.Exception ex
        return resp
    }

let keepAlive slug =
    Api.req<unit> ("/api/chat/keepAlive/" + slug) "post" [ ]

let leave slug =
    Api.req<string> ("/chat/room/" + slug + "/leaveRoom") "post" [ ]

let send slug line =
    Api.req<ChannelPostResult> ("/chat/room/" + slug + "/send2") "post" [ "line", line ]

let entityBySlug slug =
    Api.req<Entity> ("/chat/room/" + slug + "/entityData") "get" [ ]

let star slug = 
    Api.req<bool> ("/chat/room/" + slug + "/star") "post" [ ]

let unstar slug = 
    Api.req<bool> ("/chat/room/" + slug + "/unstar") "post" [ ]

let report () = ()

let getAd () = ()

let changePreferences (font:int) (color:int) =
    Api.req<unit> "chat/changePreferences" "post" [
            "font", font.ToString()
            "color", color.ToString()
        ]
