module RippleTool.UI.Integration

open System
open System.Threading
open Chiron
open RippleTool
open RippleTool.Encoding
open RippleTool.Types

//-------------------------------------------------------------------------------------------------

type private Agent<'T> = MailboxProcessor<'T>

type private State<'T> =
    | Get of AsyncReplyChannel<'T>
    | Set of 'T

let private handleTrackState (event : Event<'T>) state = function
    | Get channel
        ->
        state |> channel.Reply
        state
    | Set state
        ->
        state |> event.Trigger
        state

let private agentTrackState event state = Agent.Start(fun inbox ->
    let rec loop state =
        async {
            let! message = inbox.Receive()
            return! message |> handleTrackState event state |> loop
    }
    loop state)

let private hookup (event : Event<'T>) (handler : Action<'T>) =

    let context = SynchronizationContext.Current

    let handler value =
        let callback obj = handler.Invoke(value)
        let callback = SendOrPostCallback(callback)
        context.Post(callback, value)

    Observable.subscribe handler event.Publish

//-------------------------------------------------------------------------------------------------

let private eventExecuteCommandException = new Event<Exception>()
let private eventExecuteCommandBeginning = new Event<obj>()
let private eventExecuteCommandFinishing = new Event<obj>()
let private eventExecuteCommandReq = new Event<string>()
let private eventExecuteCommandRes = new Event<string>()
let private agentExecuteCommandReq = agentTrackState eventExecuteCommandReq null
let private agentExecuteCommandRes = agentTrackState eventExecuteCommandRes null

let private agentExecuteCommand = Agent.Start(fun inbox ->
    async {
        while true do
            let! req = inbox.Receive()
            eventExecuteCommandBeginning.Trigger()
            agentExecuteCommandReq.Post(Set req)
            let! res = Command.execute Config.serverUri req
            agentExecuteCommandRes.Post(Set res)
            eventExecuteCommandFinishing.Trigger()
    })

agentExecuteCommand.Error |> Event.add eventExecuteCommandException.Trigger

//-------------------------------------------------------------------------------------------------

let hookupEventExecuteCommandException handler = handler |> hookup eventExecuteCommandException
let hookupEventExecuteCommandBeginning handler = handler |> hookup eventExecuteCommandBeginning
let hookupEventExecuteCommandFinishing handler = handler |> hookup eventExecuteCommandFinishing
let hookupEventExecuteCommandReq handler = handler |> hookup eventExecuteCommandReq
let hookupEventExecuteCommandRes handler = handler |> hookup eventExecuteCommandRes

let executeRawJson =
    agentExecuteCommand.Post

let executeCommand =
    agentExecuteCommand.Post << Command.serialize

let executeSubmitTransaction =
    let toSubmit blob = Submit { Id = None; TransactionBlob = Binary.toHex blob }
    executeCommand << toSubmit << Transaction.sign Config.secretKey

let getJsonReq () =
    agentExecuteCommandReq.PostAndReply(Get)

let getJsonRes () =
    agentExecuteCommandRes.PostAndReply(Get)

let setJsonReq json =
    agentExecuteCommandReq.Post(Set json)

let setJsonRes json =
    agentExecuteCommandRes.Post(Set json)

let formatJson =
    Json.parse >> Json.formatWith JsonFormattingOptions.Pretty
