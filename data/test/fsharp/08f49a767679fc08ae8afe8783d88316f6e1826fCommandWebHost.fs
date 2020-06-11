namespace Sunergeo.Web.Commands

open System
open Sunergeo.Core
open Sunergeo.Web

open Routing

type RoutedCommand<'Command, 'AggregateId when 'Command :> ICommandBase<'AggregateId> and 'AggregateId : comparison> =
    RoutedType<'Command, unit>
    
type CommandHandler = RoutedTypeRequestHandler<unit>

open System.Threading.Tasks
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Http
open Sunergeo.Logging
open Microsoft.Extensions.DependencyInjection

type CommandWebHostStartupConfig<'AggregateId, 'State, 'Events when 'AggregateId : comparison> = {
    Logger: Sunergeo.Logging.Logger
    ContextProvider: HttpContext -> Context
    Handlers: CommandHandler list
}

type CommandWebHostStartup<'AggregateId, 'State, 'Events when 'AggregateId : comparison> (config: CommandWebHostStartupConfig<'AggregateId, 'State, 'Events>) = 

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

                let commandHandler =
                    config.Handlers
                    |> List.tryPick
                        (fun handler ->
                            handler context ctx.Request
                        )
                        
                do! WebHost.runHandler
                        commandHandler
                        (fun _ -> None)
                        (fun logLevel message -> 
                            config.Logger logLevel (sprintf "%O -> %s" ctx.Request.Path message)
                        )
                        ctx.Response

            } |> Async.StartAsTask :> Task

        app.Run(RequestDelegate(reqHandler))

type CommandWebHostConfig<'AggregateId, 'State, 'Events> = {
    InstanceId: InstanceId
    Logger: Sunergeo.Logging.Logger
    Handlers: CommandHandler list
    BaseUri: Uri
}

module CommandWebHost =
    let toGeneralRoutedCommand<'Command, 'AggregateId when 'Command :> ICommandBase<'AggregateId> and 'AggregateId : comparison>
        (routedCommand: RoutedCommand<'Command, 'AggregateId>)
        :RoutedCommand<ICommandBase<'AggregateId>, 'AggregateId> =
        {
            RoutedCommand.PathAndQuery = routedCommand.PathAndQuery
            RoutedCommand.HttpMethod = routedCommand.HttpMethod
            RoutedCommand.Exec = 
                (fun (wrappedTarget: ICommandBase<'AggregateId>) (context: Context) ->
                    routedCommand.Exec (wrappedTarget :?> 'Command) context
                )
        }

    let create<'AggregateId, 'State, 'Events when 'AggregateId : comparison> (config: CommandWebHostConfig<'AggregateId, 'State, 'Events>): IWebHost =
            
        let startupConfig:CommandWebHostStartupConfig<'AggregateId, 'State, 'Events> =
            {
                Logger = config.Logger
                Handlers = config.Handlers
                ContextProvider = defaultContextProvider config.InstanceId
            }

        WebHostBuilder()
            .ConfigureServices(fun services -> services.AddSingleton<CommandWebHostStartupConfig<'AggregateId, 'State, 'Events>>(startupConfig) |> ignore)
            .UseKestrel()
            .UseStartup<CommandWebHostStartup<'AggregateId, 'State, 'Events>>()
            .UseUrls(config.BaseUri |> string)
            .Build()
      