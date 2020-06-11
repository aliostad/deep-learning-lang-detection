namespace Protocol

type BroadCastMessage = {Sender:string; Message:string}
type PrivateMessage = {Recipient:string; Message:string}
type LoginMessage = {Name:string}
type LoginErrorMessage = {Message:string}
type LoginSuccessMessage = {Message:string}
type private Message = {Message:System.Type; Handle:obj -> Async<unit>}

//type Message<'a> = {Message:System.Type; MessageHandler:'a -> Async<unit>}

module MessageHandling =
   
    type Message<'a>(handler) =
        let messageType = typeof<'a>
        member this.Message = messageType
        member this.Handle: msg:'a -> Async<unit> = handler

    let mutable private messages:Message list = []
    
    let settings = let s = new Newtonsoft.Json.JsonSerializerSettings()
                   s.TypeNameHandling <- Newtonsoft.Json.TypeNameHandling.All
                   s
    
    let serialize msg =
        Newtonsoft.Json.JsonConvert.SerializeObject(msg,settings)

    let deserialize serializedMessage =
        Newtonsoft.Json.JsonConvert.DeserializeObject(serializedMessage, settings)

    let private toUntyped (message:Message<'a>) =
        { Message=message.Message; Handle=fun (arg:obj) -> message.Handle (arg :?> 'a) }

    let private tryGetMessage msg =
                messages
                |> List.tryFind (fun msg -> msg.Message = msg.GetType())

    let registerMessage msg =
        messages <- (msg |> toUntyped) :: messages
    
    let getHandler serializedMessage =
        let msg = serializedMessage |> deserialize
        match msg |> tryGetMessage with
        | Some message -> message.Handle msg
        | None -> failwith "unknow message" 
   

//    let Messages = [ {message=typeof<BroadCastMessage>; handler= toUntyped broadCastHandler }
//                     {message=typeof<PrivateMessage>; handler=logHandler }
//                     {message=typeof<LoginMessage>; handler=logHandler }
//                     {message=typeof<LoginErrorMessage>; handler=logHandler }
//                     {message=typeof<LoginSuccessMessage>; handler=logHandler }]

    

//    let getMsgHandler jsonString =
//        let deserializedMsg = Newtonsoft.Json.JsonConvert.DeserializeObject(jsonString, settings);
//        (getMessageByType deserializedMsg).MessageHandler deserializedMsg
//    
//
//    let handleMessage broadcastHandler privateHandler loginHandler loginErrorHandler loginSuccessHandler senderId jsonString =
//                try
//                    match Newtonsoft.Json.JsonConvert.DeserializeObject<MessageType>(jsonString, settings) with
//                    | Broadcast (_, msg)        -> broadcastHandler senderId msg
//                    | Private (recieverId, msg) -> privateHandler recieverId senderId msg
//                    | Login Id                  -> loginHandler Id
//                    | LoginError msg            -> loginErrorHandler msg
//                    | LoginSuccess msg          -> loginSuccessHandler msg
//
//                with
//                |   ex -> 
//                    printfn "%s" (ex.ToString())
//                    failwith ex.Message
     

    