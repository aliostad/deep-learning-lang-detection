namespace Rotix

open System
open System.Collections.Generic
open System.Reflection
open ChatExchangeDotNet

type internal EventRouter() =
    let handlerExecutors =
        Assembly.GetExecutingAssembly().GetType("Rotix.EventRouter").GetRuntimeMethods()
        |> Seq.filter (fun m ->
            m.Name.StartsWith("execute")
        )

    let getArgsInOrder (handlerMethParams : ParameterInfo[]) (args : IEnumerable<string * obj>) =
        let argsInOrder = List<obj>()
        handlerMethParams
        |> Array.iter (fun handlerParam ->
            try
                let arg =
                    args
                    |> Seq.find (fun a ->
                        fst a = handlerParam.Name
                    )
                argsInOrder.Add(snd arg)
            with
            | _ -> failwith <| "Could not find argument named: " + handlerParam.Name
        )
        argsInOrder
        |> Array.ofSeq

    let (|MsgFilterPass|MsgFilterFail|) (m : Message, h : ChatEventHandler) =
        if h.MessageFilterReg.IsMatch(m.Content) then
            MsgFilterPass
        else
            MsgFilterFail

    let checkArg (argName : string) (argObj : obj) (handler : ChatEventHandler) : string * obj =
        let argType = argObj.GetType()
        match handler.HasArg argName argType with
        | true -> argName, argObj
        | _ -> null, null

    let removeNullArgs (args : list<string * obj>) =
        args 
        |> Seq.filter (fun a ->
            fst a = null || snd a = null |> not
        )

    // Accepts the "raw" unsorted unfiltered arguments from a handler
    let invokeHandlerWithArgs (handler : ChatEventHandler) (rawArgs : list<string * obj>) =
        let cleanUnsortedArgs = removeNullArgs rawArgs
        let sortedArgs = getArgsInOrder handler.HandlerParams cleanUnsortedArgs
        handler.Handler.Invoke(handler, sortedArgs) |> ignore

    let executeInternalExceptionHandler (room : Room) (handler : ChatEventHandler) (e : Exception) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.InternalException handler
            checkArg "error" e handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeDataReceivedHandler (room : Room) (handler : ChatEventHandler) (d : string) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.DataReceived handler
            checkArg "data" d handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeMessagePostedHandler (room : Room) (handler : ChatEventHandler) (m : Message) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessagePosted handler
                checkArg "message" m handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeMessageEditedHandler (room : Room) (handler : ChatEventHandler) (m : Message) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessageEdited handler
                checkArg "message" m handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeUserEnteredHandler (room : Room) (handler : ChatEventHandler) (u : User) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.UserEntered handler
            checkArg "user" u handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeUserLeftHandler (room : Room) (handler : ChatEventHandler) (u : User) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.UserLeft handler
            checkArg "user" u handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeRoomMetaChangedHandler (room : Room) (handler : ChatEventHandler) (u : User) (n : string) (d : string) (t : string[]) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.RoomMetaChanged handler
            checkArg "user" u handler
            checkArg "name" n handler
            checkArg "desc" d handler
            checkArg "tags" t handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeMessageStarToggledHandler (room : Room) (handler : ChatEventHandler) (m : Message) (s : int) (p : int) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessageStarToggled handler
                checkArg "message" m handler
                checkArg "starCount" s handler
                checkArg "pinCount" p handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeUserMentionedHandler (room : Room) (handler : ChatEventHandler) (m : Message) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.UserMentioned handler
                checkArg "message" m handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeMessageDeletedHandler (room : Room) (handler : ChatEventHandler) (u : User) (i : int) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.MessageDeleted handler
            checkArg "user" u handler
            checkArg "messageId" i handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeUserAccessLevelChangedHandler (room : Room) (handler : ChatEventHandler) (g : User) (t : User) (l : UserRoomAccess) =
        let unsortedArgs = [
            checkArg "roomOfOrigin" room handler
            checkArg "triggeredEvent" EventType.UserAccessLevelChanged handler
            checkArg "grantedBy" g handler
            checkArg "targetUser" t handler
            checkArg "newAccessLevel" l handler
        ]
        invokeHandlerWithArgs handler unsortedArgs

    let executeMessageReplyHandler (room : Room) (handler : ChatEventHandler) (p : Message) (c : Message) =
        match c, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessageReply handler
                checkArg "parent" p handler
                checkArg "child" c handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeMessageMovedOutHandler (room : Room) (handler : ChatEventHandler) (m : Message) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessageMovedOut handler
                checkArg "message" m handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    let executeMessageMovedInHandler (room : Room) (handler : ChatEventHandler) (m : Message) =
        match m, handler with
        | MsgFilterFail -> ()
        | MsgFilterPass ->
            let unsortedArgs = [
                checkArg "roomOfOrigin" room handler
                checkArg "triggeredEvent" EventType.MessageMovedIn handler
                checkArg "message" m handler
            ]
            invokeHandlerWithArgs handler unsortedArgs

    member this.ConnectHandler (room : Room) eventType handler =
        handlerExecutors
        |> Seq.iter (fun m ->
            if m.Name.Replace("execute", "").Replace("Handler", "") = eventType.ToString() then
                m.Invoke(null, [| room :> obj; handler :> obj |]) |> ignore
        )

//TODO: Honour handler's priority.