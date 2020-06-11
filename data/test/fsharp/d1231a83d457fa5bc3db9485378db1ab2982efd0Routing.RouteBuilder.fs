namespace Deep.Routing

open Deep

[<AutoOpen>]
module RouteFinder =

    open Deep
    open System.Reflection

    type Routes with

        static member AddMarkedActions (assemblies : Assembly seq) (routes : routes) =
            assemblies
            |> Function.findByAttribute<RouteAttribute>
            |> Seq.map
                (fun mi ->
                    let attr = mi |> Function.getAttribute<RouteAttribute>
                    {
                        HttpMethod = attr.HttpMethod
                        Pattern = attr.RoutePattern
                        Handler = new FunctionRouteHandler(mi) :> IRouteHandler
                        Filter = None
                        Priority = attr.Priority
                        Defaults = Map.empty
                    })
            |> fun r -> routes |> Seq.append r |> List.ofSeq

type RouteBuilderConfig(config : Config) =
    inherit AssemblyConfig()
    interface IConfigSection
    override c.GetAssemblyNames() =
        config.SelectAs<string[]>("RouteBuilder.Assemblies")

type RouteBuilder(builder : routes -> routes, config : RouteBuilderConfig) =
    let config = config :> IAssemblyConfig
    let assemblies = config.GetAssemblies()
    let routes = 
        match assemblies.Length with
        | 0 -> []
        | _ -> [] |> Routes.AddMarkedActions assemblies
        |> builder

    interface IRouteBuilder with
        override b.Routes = routes

    new(config : RouteBuilderConfig) = RouteBuilder(id, config)