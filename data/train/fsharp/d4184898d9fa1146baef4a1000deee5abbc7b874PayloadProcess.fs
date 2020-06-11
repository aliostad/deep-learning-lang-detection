namespace Pdg.Splorr.MerchantsAndTraders.Web.Controllers

open System
open System.Globalization
open System.Linq
open System.Security.Claims
open System.Threading.Tasks
open System.Web
open System.Web.Mvc
open System.Web.Routing
open Microsoft.AspNet.Identity
open Microsoft.AspNet.Identity.Owin
open Microsoft.Owin.Security
open Pdg.Splorr.MerchantsAndTraders.DataLayer
open Pdg.Splorr.MerchantsAndTraders.Web
open Pdg.Splorr.MerchantsAndTraders.Web.Models
open FSharp.Interop.Dynamic

module PayloadProcess =
    type Payload<'TEntity> =
    | InProcess of 'TEntity
    | Final of ActionResult

    let bind processFunction payload =
        match payload with
        | InProcess s -> processFunction s
        | Final f -> Final f

    let (>>=) payload processFunction =
        bind processFunction payload

    let finalize (finalizer:'TEntity->ActionResult) (payload:Payload<'TEntity>) : ActionResult =
        match payload with
        | InProcess s -> s |> finalizer
        | Final f -> f