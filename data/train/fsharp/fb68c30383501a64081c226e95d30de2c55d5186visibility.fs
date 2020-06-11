module visibility


open System
open System.Runtime.Serialization

open Suave // always open suave
open Suave.Http
open Suave.Http.Applicatives

open Suave.Http.Successful // for OK-result
open Suave.Web // for config


module Navigation =
    let createViewableItem = "/api/visibility/createViewableItem"
    let sharePublic = "/api/visibility/sharePublic"
    let shareGroups = "/api/visibility/shareGroups"
    let shareIndividuals = "/api/visibility/shareIndividuals"
    let denyPublic = "/api/visibility/denyPublic"
    let denyGroups = "/api/visibility/denyGroups"
    let denyIndividuals = "/api/visibility/denyIndividuals"
    let allowSharingPublic = "/api/visibility/allowSharingPublic"
    let allowSharingGroup = "/api/visibility/allowSharingGroup"
    let allowSharingIndividuals = "/api/visibility/allowSharingIndividuals"
    

//    createViewableItem with initial rights to change it