namespace YuyukoBot.Handlers

module CommandHandler = 

    //TODO: CommandHandler

    open Discord.Commands
    open Discord.WebSocket
    open System.Threading.Tasks
    open System
    open System.Reflection

    let mutable private _discord:DiscordSocketClient = null
    let mutable private _commands:CommandService = null
    let mutable private _provider:IServiceProvider = null

    let InitializeAsync(provider:IServiceProvider):Async<unit> = async {
        _provider <- provider
        _commands.AddModulesAsync(Assembly.GetEntryAssembly()) |> ignore
        Task.CompletedTask |> ignore
        }
