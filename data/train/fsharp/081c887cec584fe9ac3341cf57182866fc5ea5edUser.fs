// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module User

open System
open Wireclub.Boundary.Models

let fetch slug =
    Api.get<UserProfile> (sprintf "api/users/%s" slug)

let block slug =
    Api.req<bool> (sprintf "users/%s/block" slug) "post" [ "status", "true"; "partial", "true"  ]

let unblock slug =
    Api.req<bool> (sprintf "users/%s/unblock" slug) "post" [ "status", "true"; "partial", "true" ]

let addFriend slug =
    Api.req<bool> (sprintf "users/%s/addFriend" slug) "post" [ "status", "true"; "partial", "true" ]

let removeFriend slug =
    Api.req<bool> (sprintf "users/%s/removeFriend" slug) "post" [ "status", "true"; "partial", "true" ]

let entityBySlug slug =
    Api.get<Entity> ("/users/" + slug + "/entityData")

   
