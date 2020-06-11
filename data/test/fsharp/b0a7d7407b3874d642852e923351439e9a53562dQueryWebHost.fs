namespace Sunergeo.Web.Queries

open System
open Sunergeo.Core
open Sunergeo.Web

open Routing

open System.Threading.Tasks
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Http
open Sunergeo.Logging
open Microsoft.Extensions.DependencyInjection;

type RoutedQuery<'Query> = RoutedType<'Query, obj>

type QueryHandler = RoutedTypeRequestHandler<obj>

type QueryWebHostStartupConfig = {
    Logger: Sunergeo.Logging.Logger
    ContextProvider: HttpContext -> Context
    Handlers: QueryHandler list
}

type QueryWebHostStartup (config: QueryWebHostStartupConfig) = 

    member x.Configure 
        (
            app: IApplicationBuilder, 
            hosting: IHostingEnvironment
        ): unit =

        let reqHandler (ctx: HttpContext) = 
            async {
                sprintf "Received %O" ctx.Request.Path
                |> config.Logger Sunergeo.Logging.LogLevel.Information

                let context = ctx |> config.ContextProvider

                let queryHandler =
                    config.Handlers
                    |> List.tryPick
                        (fun handler ->
                            handler context ctx.Request
                        )
                       
                do! WebHost.runHandler
                        queryHandler
                        (fun result ->
                            if result = null
                            then
                                null, StatusCodes.Status204NoContent
                            else
                                result, StatusCodes.Status200OK
                            |> Some
                        )
                        (fun logLevel message -> 
                            config.Logger logLevel (sprintf "%O -> %s" ctx.Request.Path message)
                        )
                        ctx.Response

            } |> Async.StartAsTask :> Task

        app.Run(RequestDelegate(reqHandler))
        

type QueryWebHostConfig = {
    InstanceId: InstanceId
    Logger: Sunergeo.Logging.Logger
    Handlers: QueryHandler list
    BaseUri: Uri
}

module QueryWebHost =
    let create (config: QueryWebHostConfig): IWebHost =
        let startupConfig =
            {
                QueryWebHostStartupConfig.Logger = config.Logger
                QueryWebHostStartupConfig.Handlers = config.Handlers
                QueryWebHostStartupConfig.ContextProvider = defaultContextProvider config.InstanceId
            }

        WebHostBuilder()
            .ConfigureServices(fun services -> services.AddSingleton<QueryWebHostStartupConfig>(startupConfig) |> ignore)
            .UseKestrel()
            .UseStartup<QueryWebHostStartup>()
            .UseUrls(config.BaseUri |> string)
            .Build()
      