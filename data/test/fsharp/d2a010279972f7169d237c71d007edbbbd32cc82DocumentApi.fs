module TypedRouting.DocumentApi
open Microsoft.Owin

type Route = {
    Methods : Set<string>
    UriTemplate : string
}

type IBlueprintApi =
    abstract member GetRoutes : unit -> (Route * (IOwinContext -> Async<unit>)) list

// This would be auto-generated inside of the Blueprint type provider
type DocumentApi
    (
        ``GET /docs{?skip}`` : (int * IOwinContext) -> Async<unit>,
        ``GET /docs/{id}`` : (int * IOwinContext) -> Async<unit>
    ) =

    let ``GET /docs{?skip} Query`` (context : IOwinContext) : Async<unit> = async {
        // TODO: Parse arguments.
        do! ``GET /docs{?skip}`` (0, context)
    }

    let ``GET /docs/{id} Get`` (context : IOwinContext) : Async<unit> = async {
        // TODO: Parse arguments.
        do! ``GET /docs{?skip}`` (0, context)
    }

    interface IBlueprintApi with
        member x.GetRoutes () =
            [
                ({ Methods = [ "GET" ] |> Set.ofList; UriTemplate = "/docs{?skip}" }, ``GET /docs{?skip} Query``)
                ({ Methods = ["GET"] |> Set.ofList; UriTemplate = "/docs/{id}" }, ``GET /docs/{id} Get``)
            ]


// Example of Ideal usage:

//type DocumentApi = Blueprint<"DocumentApi.md">
let documentApi =
    DocumentApi
        (
            ``GET /docs{?skip}`` = fun (skip, context) -> async {
                    context.Response.ContentType <- "text/plain"
                    do! Async.AwaitIAsyncResult(context.Response.WriteAsync("Hello World!\r\nHello World!\r\nHello World!\r\nHello World!")) |> Async.Ignore
                }
            ,
            ``GET /docs/{id}`` = fun (id, context) -> async {
                    context.Response.ContentType <- "text/plain"
                    do! Async.AwaitIAsyncResult(context.Response.WriteAsync("Hello World!")) |> Async.Ignore
                }
        )


// Hacky example of a server configuration
module RouteTable =
    let create () : Map<Route, IOwinContext -> Async<unit>> =
        Map.empty

    let register routes table =
        let addRoute table (uriTemplate, handler) =
            table |> Map.add uriTemplate handler
        routes |> List.fold addRoute table

    let registerBlueprintApi (blueprintApi : IBlueprintApi) =
        register (blueprintApi.GetRoutes())

    let isRouteMatch route (context : IOwinContext) =
        route.Methods
        |> Set.contains ""

    let buildOwinHandler (table : Map<Route, IOwinContext -> Async<unit>>) (context : IOwinContext) (next : unit -> Async<unit>) : Async<unit> =
        let route =
            table
            |> Map.tryPick (fun k v -> if (context |> isRouteMatch k) then Some v else None)
        match route with
        | Some h ->
            async {
                do! h(context)
                do! next()
            }
        | None -> failwith "404"

let buildOwinHandler () =
    RouteTable.create ()
    |> RouteTable.registerBlueprintApi documentApi
    |> RouteTable.buildOwinHandler
