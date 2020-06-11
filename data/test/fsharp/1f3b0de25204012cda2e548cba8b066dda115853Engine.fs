namespace Machete

open System
open System.Collections.Generic
open Machete.Core
open Machete.Runtime
open Machete.Compiler

type internal Message =
| ExecuteScript of string * AsyncReplyChannel<obj>
| ExecuteScriptToDynamic of string * AsyncReplyChannel<IDynamic> 
| RegisterOutputHandler of Action<string> 

type Engine () = 

    let environment = new Environment()
    let compiler = new CompilerService(environment)
    let handlers = Dictionary<Action<string>, MailboxProcessor<Action<string>>>()


    let checkOutput (inbox:MailboxProcessor<Action<string>>) = async {
        let! handler = inbox.Receive ()
        while true do
            try
                let str = environment.Output.Take()
                handler.Invoke str
            with | e -> ()
    }  

    let proccessMessages (inbox:MailboxProcessor<Message>) = async {
        do! Async.SwitchToNewThread ()
        while true do
            try
                let! msg = inbox.Receive ()
                match msg with
                | RegisterOutputHandler (handler) ->
                    let agent = MailboxProcessor.Start checkOutput
                    agent.Post handler
                    handlers.Add (handler, agent)    
                | ExecuteScript (script, channel) ->
                    try
                        let executableCode = compiler.CompileGlobalCode script
                        let result = environment.Execute executableCode
                        let result = 
                            match result.Value with
                            | :? IBoolean as r -> r.BaseValue :> obj
                            | :? INumber as r -> r.BaseValue :> obj
                            | :? IString as r -> r.BaseValue :> obj
                            | _ -> result.ToString() :> obj
                        channel.Reply result
                    with | e ->
                        channel.Reply e
                | ExecuteScriptToDynamic (script, channel) ->
                    try
                        let executableCode = compiler.CompileGlobalCode script
                        let result = environment.Execute executableCode
                        channel.Reply result
                    with | e ->
                        channel.Reply (environment.CreateString e.Message)
            with | e -> ()
    }
    
    let agent = lazy(MailboxProcessor.Start proccessMessages)

    let buildExecuteScriptMessage script channel = 
        ExecuteScript (script, channel)

    member this.ExecuteScriptToDynamic (script:string) =
        agent.Value.PostAndReply (fun channel -> ExecuteScriptToDynamic (script, channel))

    member this.ExecuteScript (script:string) =
        agent.Value.PostAndReply (buildExecuteScriptMessage script)

    member this.ExecuteScript (script:string, timeout:int) =
        agent.Value.PostAndReply (buildExecuteScriptMessage script, timeout)
        
    member this.ExecuteScriptAsync (script:string) =
        agent.Value.PostAndAsyncReply (buildExecuteScriptMessage script)

    member this.ExecuteScriptAsync (script:string, timeout:int) =
        agent.Value.PostAndAsyncReply (buildExecuteScriptMessage script, timeout)
            
    member this.ExecuteScriptAsTask (script:string) =
        agent.Value.PostAndAsyncReply (buildExecuteScriptMessage script) |> Async.StartAsTask 

    member this.ExecuteScriptAsTask (script:string, timeout:int) =
        agent.Value.PostAndAsyncReply (buildExecuteScriptMessage script, timeout) |> Async.StartAsTask 
        
    member this.RegisterOutputHandler (handler:Action<string>) =
        agent.Value.Post (RegisterOutputHandler handler)