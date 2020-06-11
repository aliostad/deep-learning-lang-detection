module MessageQueue
open System
open System.Threading
open System.Threading.Tasks
open FrameNode

// data structure for message pump

type MessagePump = 
    | EndConsumer of Node
    | Messager of Node * MessagePump

type MaybeBuilder() =
    let bind value func =
        match value with
            | Some(x) -> func x
            | _ -> None

    let wrap value = Some(value)

    member this.Bind(x, f) = bind x f
    member this.Delay(f) = f()
    member this.Return(x) = wrap x
    member this.ReturnFrom(x) = x
    member this.Combine(a, b) = if Option.isSome a then a
                                else b 
    member this.Zero(a) = None
    

type MessageHandler(chain:MessagePump) = 
    let chain = chain

    let maybe = MaybeBuilder()

    let chainCompletedEvent = new Event<Data>()

    // If all nodes processed the chain
    // we'll return bool option true, otherwise we'll return None
    let processNodesFunc pump initialData =   
            let rec processNodesFunc' pump initialData = 
                    maybe{
                        match pump with 
                            | MessagePump.EndConsumer(i) -> 
                                         // got to the end so we can say we processed a chain
                                        let! consumerMessage = i.processData(initialData)
                                        return consumerMessage
                            | MessagePump.Messager(curr, nextNode) -> 
                                        let! nextMessage = curr.processData initialData
                                        return! processNodesFunc' nextNode nextMessage
                    }    
                                     
            processNodesFunc' pump initialData

    // curry the execution chain 
    let executeChain data = processNodesFunc chain data    

    let testResult ret = 
        if Option.isSome (ret) then 
            true
        else
            false

     // process a chain instance function
    let agent = 
        let taskFactory = new TaskFactory()

        MailboxProcessor.Start(fun item -> 
            let rec recvLoop _ = 
                async{
                    let! (postedData:Data) = item.Receive()
                    
                    Console.WriteLine("        RECEIVED: {0}", postedData.getValue.ToString())

                    let result = executeChain postedData
                    if testResult result then
                        chainCompletedEvent.Trigger (Option.get result)

                    return! recvLoop()
                }  
            recvLoop()
        )
                             
    member this.queueData data = 
        agent.Post data

    member this.chainCompleted = chainCompletedEvent.Publish

    member this.queuSize _ = agent.CurrentQueueLength
