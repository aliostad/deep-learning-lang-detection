// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module PrivateChat

open System
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open Wireclub.Models
open Wireclub.Boundary
open Wireclub.Boundary.Chat
open ChannelEvent

let online () =
    Api.req<PrivateChatFriendsOnline> "privateChat/online" "get" []

let session id history update = async {
    let! resp = Api.req<SessionResponse> ("privateChat/session/" + id) "post" ["history", (if history then "true" else "false") ; "update", (if update then "true" else "false") ]
    return
        match resp with
        | Api.ApiOk result ->
            try
                let events = 
                    match result.Events with
                    | null | "" -> [||]
                    | events -> ChannelClient.deserializeEventList (JsonConvert.DeserializeObject events :?> JToken) result.UserId

                Api.ApiOk (result, events)
            with
            | ex -> Api.Exception ex
        | Api.BadRequest result -> Api.BadRequest result
        | Api.Unauthorized -> Api.Unauthorized
        | Api.Timeout -> Api.Timeout
        | Api.HttpError (code, desc) -> Api.HttpError (code, desc)
        | Api.Deserialization (ex, key) -> Api.Deserialization (ex, key)
        | Api.Exception ex -> Api.Exception ex
    }

let send receiver message = 
    Api.req<PrivateChatSendResponse> "privateChat/sendPrivateMessage3" "post" (
        [
            "receiver", receiver
            "line", message
        ])

let changeOnlineState (state:OnlineStateType) = 
    Api.req<unit> ("privateChat/changeOnlineState") "post" [ "state", string (int state) ]

let setMobile () =
    Api.req<unit> "api/settings/setMobile" "post" []

let updatePresence () =
    Api.req<unit> "home/presence" "post" []
