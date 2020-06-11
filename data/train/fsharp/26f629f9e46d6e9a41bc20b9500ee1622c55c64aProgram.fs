open NLog.Config
open NLog.Targets
open NLog
open MassTransit
open MassTransit.NLogIntegration
open MassTransit.RabbitMqTransport
open System
open NLog.Layouts
open MassTransitContracts
open System.Threading.Tasks
open System.Threading

type ProcessFileResultConsumer() =
    static let log = LogManager.GetCurrentClassLogger()
    static let count = ref 0
    
    interface IConsumer<ProcessFileResult> with
        member __.Consume ctx =
            async {
                let count = Interlocked.Increment count
                if count % 100 = 0 then
                    log.Info(sprintf "%d results have been received." count)
            } |> Async.StartAsTask :> Task

[<EntryPoint>]
let main argv = 
    LogManager.Configuration <-
        let config = LoggingConfiguration()
        let consoleTarget = new ColoredConsoleTarget(Layout = Layout.op_Implicit "${date:format=HH\:mm\:ss} ${level} ${logger} ${message}")
        config.AddTarget("console", consoleTarget)
        config.AddRule(LogLevel.Info, LogLevel.Fatal, consoleTarget)
        config

    let bus = 
        Bus.Factory.CreateUsingRabbitMq(fun cfg ->
            cfg.UseNLog()
            
            let host =
                cfg.Host(Uri "rabbitmq://localhost", fun (h: IRabbitMqHostConfigurator) ->
                    h.Username("guest")
                    h.Password("guest"))
            
            cfg.ReceiveEndpoint(host, "process_file_results", fun cfg ->
                cfg.Consumer<ProcessFileResultConsumer>()
            )
        )
    
    bus.Start()
    let log = LogManager.GetLogger "Client"
    let serverUri = Uri "rabbitmq://localhost/process_file_commands"
    let endpoint = bus.GetSendEndpoint(serverUri).Result
    
    let command =
        { CommandId = NewId.NextGuid()
          Timestamp = DateTime.UtcNow
          TaskId = 0L
          Path = Some @"c:\foo\bar.txt"
          Hash = Md5 (Guid.NewGuid().ToByteArray())
          Size = 1L 
          ReplayAddress = Uri "rabbitmq://localhost/process_file_results" }

    // endless loop sending the same command as fast as possible
    let rec loop count =
        async {
            do! endpoint.Send command |> Async.AwaitTask
            if count % 100 = 0 then log.Info(sprintf "%d commands have been sent" count)        
            return! loop (count + 1)
        }
    
    loop 0 |> Async.RunSynchronously
    Console.ReadKey() |> ignore
    0