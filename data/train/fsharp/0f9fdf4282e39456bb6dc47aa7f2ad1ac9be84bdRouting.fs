namespace Figment

[<AutoOpen>]
module Routing =

    open System
    open System.Reflection
    open System.Text.RegularExpressions
    open System.Web
    open System.Web.Mvc
    open System.Web.Routing
    open Binding
    open Helpers
    open Extensions
    open Microsoft.FSharp.Reflection
    open RoutingConstraints
    open RouteHandlerHelpers

    type HttpMethod = GET | POST | HEAD | DELETE | PUT

    type ActionRegistration = {
        routeName: string
        action: FAction
        route: RouteBase
    } with
        static member make(routeName, action, route) = 
            {routeName = routeName; action = action; route = route}

    type RouteCollection with
        member private this.GetDefaultRouteValueDictionary() =
            RouteValueDictionary(dict ["controller", box "Views"; "action", box "figment"])
        member private this.MapAction(routeConstraint: RouteConstraint, handler: IRouteHandler) = 
            let route = {new RouteBase() with
                            override x.GetRouteData ctx = 
                                let data = RouteData(routeHandler = handler, route = x)
                                for d in this.GetDefaultRouteValueDictionary() do
                                    data.Values.Add(d.Key, d.Value)
                                if routeConstraint (ctx, data)
                                    then data
                                    else null
                            override this.GetVirtualPath(ctx, values) = null}
            this.Add(route)
            route

        member this.MapAction(routeConstraint: RouteConstraint, action: FAction) = 
            let handler = buildActionRouteHandler action
            let route = this.MapAction(routeConstraint, handler)
            ()

        member this.MapAction(routeConstraint: RouteConstraint, action: FAsyncAction) = 
            let handler = buildAsyncActionRouteHandler action
            let route = this.MapAction(routeConstraint, handler)
            ()

        member private this.MapWithMethod(url, routeName, httpMethod, handler) = 
            let httpMethodConstraint = HttpMethodConstraint([| httpMethod |])
            let constraints = RouteValueDictionary(dict [("httpMethod", box httpMethodConstraint)])
            let route = Route(Regex.Replace(url, "^/", ""), this.GetDefaultRouteValueDictionary(), constraints, handler)
            this.Add(routeName, route)
            route

        member this.MapWithMethod(url, routeName, httpMethod, action: FAction) =
            let handler = buildActionRouteHandler action
            let route = this.MapWithMethod(url, routeName, httpMethod, handler)
            ()

        member this.MapWithMethod(url, routeName, httpMethod, action: FAsyncAction) =
            let handler = buildAsyncActionRouteHandler action
            let route = this.MapWithMethod(url, routeName, httpMethod, handler)
            ()

        member this.MapGet(url, routeName, action: FAction) =
            this.MapWithMethod(url, routeName, "GET", action)

        member this.MapGet(url, routeName, action: FAsyncAction) =
            this.MapWithMethod(url, routeName, "GET", action)

        member this.MapPost(url, routeName, action: FAction) =
            this.MapWithMethod(url, routeName, "POST", action)

        member this.MapPost(url, routeName, action: FAsyncAction) =
            this.MapWithMethod(url, routeName, "POST", action)

    let inline action (routeConstraint: RouteConstraint) (action: FAction) = 
        RouteTable.Routes.MapAction(routeConstraint, action)

    let inline asyncAction (routeConstraint: RouteConstraint) (action: FAsyncAction) = 
        RouteTable.Routes.MapAction(routeConstraint, action)

    let inline get url (action: FAction) =
        RouteTable.Routes.MapGet(url, null, action)

    let inline getn url routeName (action: FAction) =
        RouteTable.Routes.MapGet(url, routeName, action)

    let stripFormatting s =
        let parameters = ref []
        let eval (rxMatch: Match) = 
            let name = rxMatch.Groups.Groups.[1].Value
            if rxMatch.Groups.Groups.[2].Captures.Count > 0
                then parameters := name::!parameters
            sprintf "{%s}" name
        let replace = Regex.Replace(s, "{([^:}]+)(:%[^}]+)?}", eval)
        let parameters = List.rev !parameters
        (replace, parameters)

    let rec bindAll (fTypes: Type list) (parameters: string list) (ctx: ControllerContext) =
        match fTypes with
        | [] -> failwith "no function types!"
        | hd::[] -> []
        | hd::tl -> 
            match parameters with
            | p::ps ->
                let v = bindSingleParameterNG hd p ctx.Controller.ValueProvider ctx
                v::bindAll tl ps ctx
            | [] -> failwith "empty parameters"

    let getnf (fmt: PrintfFormat<'a -> 'b, unit, unit, FAction>) routeName (action: 'a -> 'b) =
        let url, parameters = stripFormatting fmt.Value
        let args = FSharpType.GetFlattenedFunctionElements(action.GetType())
        let realAction ctx = 
            let values = bindAll args parameters ctx
            let a = FSharpValue.InvokeFunction action values :?> FAction
            a ctx
        getn url routeName realAction

    let inline getf (fmt: PrintfFormat<'a -> 'b, unit, unit, FAction>) (action: 'a -> 'b) = 
        getnf fmt null action

    let inline post url (action: FAction) =
        RouteTable.Routes.MapPost(url, null, action)

    let register (httpMethod: HttpMethod) url action =
        match httpMethod with
        | GET -> get url action
        | POST -> post url action
        | _ -> failwith "Not supported"

    let inline clear () =
        RouteTable.Routes.Clear()
