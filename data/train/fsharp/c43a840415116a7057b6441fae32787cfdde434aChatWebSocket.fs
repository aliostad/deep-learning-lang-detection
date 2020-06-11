namespace ChatHub

open System.Web
open Microsoft.Web.WebSockets
open System.Collections.Generic

open Protocol

type WebSocketChatHandler () =
    inherit WebSocketHandler ()

    static let chats = Dictionary()
    static let waitingList = ResizeArray()

    let addAndTryBeginChat (me : WebSocketChatHandler) = 
        match waitingList |> Seq.tryFind(fun _ -> true) with
        | Some other -> 
            chats.[other] <- me
            chats.[me] <- other
            Join |> encodeServerProtocol |> other.Send
            Join |> encodeServerProtocol |> me.Send
            waitingList.Remove(other) |> ignore
        | _ -> 
            waitingList.Add(me)
    
    let tryRemove (me : WebSocketChatHandler) =
        if not <| waitingList.Remove(me) then
            match chats.TryGetValue(me) with
            | true, other ->
                other.Close()
                chats.Remove(me) |> ignore
            | _ ->
                ()

            chats.Remove(me) |> ignore

    let tryInputting other =
        Written |> encodeServerProtocol |> (other : WebSocketChatHandler).Send

    let trySpeak msg other = 
        Listen msg |> encodeServerProtocol |> (other : WebSocketChatHandler).Send

    let brancketMe this f =
        lock chats (fun () -> f this)

    let brancketOther this f =
        lock chats (fun () ->
            match chats.TryGetValue(this) with
            | (true, other) ->
                f other
            | _ ->
                failwith "チャット中じゃないのに発言しようとしました。")

    override this.OnOpen () = brancketMe this addAndTryBeginChat

    override this.OnClose() = brancketMe this tryRemove

    override this.OnMessage (message : string) = 
        match message |> decodeClientProtocol with
        | Ping -> ()
        | Write -> 
            brancketOther this <| tryInputting
        | Speak msg -> 
            brancketOther this <| trySpeak msg
type ChatWebSocket() = 
    interface IHttpHandler with
        member this.ProcessRequest context =
            if context.IsWebSocketRequest then
                context.AcceptWebSocketRequest(new WebSocketChatHandler())
        member this.IsReusable = true
