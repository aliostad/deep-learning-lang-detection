// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module Credits

open System
open Wireclub.Models
open Wireclub.Boundary.Models
open Wireclub.Boundary.Settings
open Newtonsoft.Json
open System.Net.Http

let bundles () =
    Api.req<CreditBundles> "api/credits/bundles" "get" []

let appStoreTransaction (data:(string * string) list) (receipt:string) =
    Api.req<AppStoreTransactionResponse>
        "api/credits/appStoreTransaction"
        "post"
        (List.concat [
            data |> List.map (fun (k, _) -> "keys", k)
            data |> List.map (fun (_, v) -> "values", v)
            [ "receipt", receipt ]
        ])
