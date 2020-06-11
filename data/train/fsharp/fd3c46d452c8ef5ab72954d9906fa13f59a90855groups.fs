module groups


open System
open System.Runtime.Serialization

open Suave // always open suave
open Suave.Http
open Suave.Http.Applicatives

open Suave.Http.Successful // for OK-result
open Suave.Web // for config


module Navigation =
    let list = "/api/groups/list"
    let detail = "/api/groups/detail"
    let create = "/api/groups/create"
    let terminate = "/api/groups/terminate"
    let invite = "/api/groups/invite"
    let join = "/api/groups/join"
    let quit = "/api/groups/quit"
    let kickBan = "/api/groups/kickBan"