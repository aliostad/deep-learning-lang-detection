module App

open Fable.Core
open Fable.Import
open Elmish
open Fable.PowerPack
open System
open Fable.Core.JsInterop

open Common
open ClientModels
open Helpers

let handleError okHandler =
    function
    | Result.Ok v -> okHandler v
    | Result.Error e -> Noop

let handleApiRequest page request target dispatch =
    let requestId = System.Guid.NewGuid()
    RequestStarted(requestId, page) |> dispatch

    async {
        let! result = request()

        match result with
        | Result.Ok d ->
            RequestCompleted(requestId, page, target d) |> dispatch
        | Result.Error e ->
            Noop |> dispatch

    } |> Async.StartImmediate

module Cmd =
    let ofApiRequest page request target =
          Cmd.ofSub (handleApiRequest page request target)

let urlUpdate (api: Api.SampleDataApi) result (state : State) =
    match result with
    | Some page ->
        let state = { state with RequestedPage = page }

        match page with
        | PageRequest.Home ->
            { state with Page = Page.Home },
            Cmd.Empty

        | PageRequest.UserSearch ->
            state,
            Cmd.ofApiRequest page api.User.Search ServerResponce.UserSearch

        | PageRequest.ProductSearch ->
            state,
            Cmd.ofApiRequest page api.Product.Search ServerResponce.ProductSearch            

    | _ ->
        state,
        Cmd.Empty

let init api result =
    urlUpdate api result
        { Page = Page.Home 
          RequestedPage = PageRequest.Home
          Requests = [] }

let update api msg (state : State) =
    match msg with
    | RequestStarted(id, _) ->
        { state with Requests = state.Requests @ [ id ] },
        Cmd.Empty

    | RequestCompleted(id, requestedPage, serverResponce) ->
        let state = { state with Requests = state.Requests |> List.except [ id ] }

        match requestedPage = state.RequestedPage, serverResponce with
        | true, ServerResponce.UserSearch items ->
            { state with Page = Page.UserSearch { Items = items } },
            Cmd.Empty

        | true, ServerResponce.ProductSearch items ->
            { state with Page = Page.ProductSearch { Items = items } },
            Cmd.Empty            

        | false, x ->
            printfn "A request has finished but the page has changed: %A" x
            state, Cmd.Empty
        
    | Noop -> state, Cmd.Empty

open Elmish.React
open Elmish.Browser.UrlParser
open Elmish.Browser.Navigation

let run placeholderId =
    let api = ClientApi.clientApi

    Program.mkProgram (init api) (update api) Views.view
    |> Program.toNavigable (parseHash pageParser) (urlUpdate api)
    |> Program.withReact placeholderId
    |> Program.run 
