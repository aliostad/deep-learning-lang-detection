//----------------------------------------------------------------------------
//
// Copyright (c) 2013-2014 Ryan Riley (@panesofglass)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//----------------------------------------------------------------------------
namespace Taliesin

open System
open System.Collections.Generic
open System.IO
open System.Threading.Tasks
open Dyfrig

/// HTTP method handler interface
type IHttpMethodHandler =
    /// Returns the `OwinAppFunc` assigned to the handler.
    abstract Handler : OwinAppFunc
    /// Returns the HTTP method assigned to the handler.
    abstract Method  : string

/// Type mapping an `OwinAppFunc` to an HTTP method.
type HttpMethodHandler =
    | GET     of OwinAppFunc
    | HEAD    of OwinAppFunc
    | POST    of OwinAppFunc
    | PUT     of OwinAppFunc
    | PATCH   of OwinAppFunc
    | DELETE  of OwinAppFunc
    | TRACE   of OwinAppFunc
    | OPTIONS of OwinAppFunc
    | Custom  of string * OwinAppFunc
    with
    /// Returns the `OwinAppFunc` assigned to the handler.
    member x.Handler =
        match x with
        | GET h
        | HEAD h
        | POST h
        | PUT h
        | PATCH h
        | DELETE h
        | TRACE h
        | OPTIONS h
        | Custom(_, h) -> h
    /// Returns the HTTP method assigned to the handler.
    member x.Method =
        match x with
        | GET        _ -> "GET"
        | HEAD       _ -> "HEAD"
        | POST       _ -> "POST"
        | PUT        _ -> "PUT"
        | PATCH      _ -> "PATCH"
        | DELETE     _ -> "DELETE"
        | TRACE      _ -> "TRACE"
        | OPTIONS    _ -> "OPTIONS"
        | Custom(m, _) -> m
    interface IHttpMethodHandler with
        member x.Handler = x.Handler
        member x.Method  = x.Method

/// Alias `MailboxProcessor<'T>` as `Agent<'T>`.
type Agent<'T> = MailboxProcessor<'T>

/// Messages used by the HTTP resource agent.
type internal ResourceMessage =
    | Request of OwinEnv * TaskCompletionSource<unit>
    | SetHandler of IHttpMethodHandler
    | Shutdown

/// An HTTP resource agent.
type Resource(uriTemplate, handlers: IHttpMethodHandler list, methodNotAllowedHandler) =
    let allowedMethods = handlers |> List.map (fun h -> h.Method)
    let agent = Agent<ResourceMessage>.Start(fun inbox ->
        let rec loop allowedMethods (handlers: IHttpMethodHandler list) = async {
            let! msg = inbox.Receive()
            match msg with
            | Request(env, tcs) ->
                let env = Environment.toEnvironment env
                let owinEnv = env :> OwinEnv 
                let foundHandler =
                    handlers
                    |> List.tryFind (fun h -> h.Method = env.RequestMethod)
                let selectedHandler =
                    match foundHandler with
                    | Some(h) -> h.Handler
                    | None -> methodNotAllowedHandler allowedMethods
                do! selectedHandler.Invoke owinEnv |> Async.AwaitTask
                // TODO: Need to also capture excptions
                tcs.SetResult()
                return! loop allowedMethods handlers
            | SetHandler(handler) ->
                let foundMethod = allowedMethods |> List.tryFind ((=) handler.Method)
                let handlers' =
                    match foundMethod with
                    | Some m ->
                        let otherHandlers = 
                            handlers |> List.filter (fun h -> h.Method <> m)
                        handler :: otherHandlers
                    | None -> handlers
                return! loop allowedMethods handlers'
            | Shutdown -> ()
        }
            
        loop allowedMethods handlers
    )

    /// Connect the resource to the request event stream.
    /// This method applies a default filter to subscribe only to events
    /// matching the `Resource`'s `uriTemplate`.
    // NOTE: This should be internal if used in a type provider.
    abstract Connect : IObservable<OwinEnv * TaskCompletionSource<unit>> * (string -> OwinEnv * TaskCompletionSource<unit> -> bool) -> IDisposable
    default x.Connect(observable, uriMatcher) =
        let uriMatcher = uriMatcher uriTemplate
        (Observable.filter uriMatcher observable).Subscribe(x)

    /// Sets the handler for the specified `HttpMethod`.
    /// Ideally, we would expose methods matching the allowed methods.
    member x.SetHandler(handler) =
        agent.Post <| SetHandler(handler)

    /// Stops the resource agent.
    member x.Shutdown() = agent.Post Shutdown

    /// Implement `IObserver` to allow the `Resource` to subscribe to the request event stream.
    interface IObserver<OwinEnv * TaskCompletionSource<unit>> with
        member x.OnNext(value) = agent.Post <| Request value
        member x.OnError(exn) = () // Ignore host level errors.
        member x.OnCompleted() = agent.Post Shutdown


/// Type alias for URI templates
type IUriRouteTemplate =
    abstract UriTemplate : string

/// Defines the route for a specific resource
type RouteDef<'TName when 'TName :> IUriRouteTemplate> = 'TName * IHttpMethodHandler list

/// Defines the tree type for specifying resource routes
/// Example:
///     type Routes = Root | About | Customers | Customer
///     let spec =
///         RouteNode((Home, "", [GET]),
///         [
///             RouteLeaf(About, "about", [GET])
///             RouteNode((Customers, "customers", [GET; POST]),
///             [
///                 RouteLeaf(Customer, "{id}", [GET; PUT; DELETE])
///             ])
///         ])            
type RouteSpec<'TRoute when 'TRoute :> IUriRouteTemplate> =
    | RouteLeaf of RouteDef<'TRoute>
    | RouteNode of RouteDef<'TRoute> * RouteSpec<'TRoute> list

/// Default implementations of the 405 handler and URI matcher
[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module internal ResourceManager =
    open Dyfrig

    /// Default `405 Method Not Allowed` handler
    /// See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.6 
    let notAllowed (allowedMethods: string list) =
        Func<_,_>(fun env ->
            let env = Environment.toEnvironment env
            env.ResponseStatusCode <- 405
            env.ResponseHeaders.Add("Allow", allowedMethods |> List.toArray)
            let tcs = TaskCompletionSource<unit>()
            tcs.SetResult()
            tcs.Task :> Task)

    /// Default URI matching algorithm
    let uriMatcher uriTemplate (env, _) =
        let env = Environment.toEnvironment env
        match env.GetBaseUri(), env.GetRequestUri() with
        | Some baseUri, Some requestUri ->
            // TODO: Do this with F# rather than System.ServiceModel. This could easily use a Regex pattern.
            let template = UriTemplate(uriTemplate)
            let result = template.Match(Uri baseUri, Uri requestUri)
            // TODO: Return the match result as well as true/false, as we can retrieve parameter values this way.
            if result = null then false else
            // TODO: Investigate ways to avoid mutation.
            env.Add("taliesin.UriTemplateMatch", result) |> ignore
            true
        | _, _ -> false

    /// Helper function to reconstruct URI templates for each `Resource`
    let concatUriTemplate baseTemplate template =
        if String.IsNullOrEmpty baseTemplate then template else baseTemplate + "/" + template

    /// Helper function to construct a `Resource` and connect it to the specified `manager`.
    let addResource manager notAllowed resources subscriptions name uriTemplate allowedMethods =
        let resource = new Resource(uriTemplate, allowedMethods, notAllowed)
        let resources' = (name, resource) :: resources
        let subscriptions' = resource.Connect(manager, uriMatcher) :: subscriptions
        resources', subscriptions'

    /// Helper function to walk the `RouteSpec` and return the collected `Resource`s.
    let rec addResources manager notAllowed uriTemplate resources subscriptions = function
        | RouteNode((name, httpMethods), nestedRoutes) ->
            let uriTemplate' = concatUriTemplate uriTemplate name.UriTemplate
            let resources', subscriptions' = addResource manager notAllowed resources subscriptions name uriTemplate' httpMethods
            flattenResources manager notAllowed uriTemplate' resources' subscriptions' nestedRoutes
        | RouteLeaf(name, httpMethods) ->
            let uriTemplate' = concatUriTemplate uriTemplate name.UriTemplate
            addResource manager notAllowed resources subscriptions name uriTemplate' httpMethods

    /// Flattens the nested `Resource`s found in the `RouteSpec`.
    and flattenResources manager notAllowed uriTemplate resources subscriptions routes =
        match routes with
        | [] -> resources, subscriptions
        | route::routes ->
            let resources', subscriptions' = addResources manager notAllowed uriTemplate resources subscriptions route
            match routes with
            | [] -> resources', subscriptions'
            | _ -> flattenResources manager notAllowed uriTemplate resources' subscriptions' routes

/// Manages traffic flow within the application to specific routes.
/// Connect resource handlers using:
///     let app = ResourceManager<HttpRequestMessage, HttpResponseMessage, Routes>(spec)
///     app.[Root].SetHandler(GET, (fun request -> async { return response }))
/// A type provider could make this much nicer, e.g.:
///     let app = ResourceManager<"path/to/spec/as/string">
///     app.Root.Get(fun request -> async { return response })
type ResourceManager<'TRoute when 'TRoute : equality and 'TRoute :> IUriRouteTemplate>() =
    // Should this also be an Agent<'T>?
    // TODO: Implement load balancing on `Resource`s.
    inherit Dictionary<'TRoute, Resource>(HashIdentity.Structural)

    let onRequest = new Event<OwinEnv * TaskCompletionSource<unit>>()

    /// Initializes and starts the `ResourceManager` using the provided `RouteSpec`
    /// and optional `uriMatcher` algorithm and `methodNotAllowedHandler`.
    member x.Start(routeSpec: RouteSpec<_>, ?uriMatcher, ?methodNotAllowedHandler) =
        let uriMatcher = defaultArg uriMatcher ResourceManager.uriMatcher
        let methodNotAllowedHandler = defaultArg methodNotAllowedHandler ResourceManager.notAllowed
        // TODO: This should probably manage a supervising agent of its own.
        let resources, subscriptions = ResourceManager.addResources x methodNotAllowedHandler "" [] [] routeSpec
        // TODO: Improve performance by adding these directly rather than returning the list.
        for name, resource in resources do x.Add(name, resource)
        { new IDisposable with
            member __.Dispose() =
                // Dispose all current event subscriptions.
                for (disposable: IDisposable) in subscriptions do disposable.Dispose()
                // Shutdown all resource agents.
                for resource in x.Values do resource.Shutdown()
        }

    /// Invokes the `ResourceManager` with the provided `OwinEnv`.
    member x.Invoke env =
        let tcs = TaskCompletionSource<unit>()
        onRequest.Trigger(env, tcs)
        tcs.Task :> Task

    interface IObservable<OwinEnv * TaskCompletionSource<unit>> with
        /// Subscribes an `observer` to received requests.
        member x.Subscribe(observer) = onRequest.Publish.Subscribe(observer)
