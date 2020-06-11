open System
open Newtonsoft.Json
open Newtonsoft.Json.Converters
open System.Collections.Generic

type IMessageHandler<'a> =
    abstract member Handle: 'a -> unit

type FooMessage() = 
    member val Name = "" with get, set

type FooHandler() = 
    interface IMessageHandler<FooMessage> with 
        member this.Handle(msg) = 
            printfn "FooHandle %s" msg.Name

type BarMessage() = 
    member val Age = 0 with get, set

type BarHandler() = 
    interface IMessageHandler<BarMessage> with 
        member this.Handle(msg) = 
            printfn "BarHandler is %d years old" msg.Age



type HandlerRegistry() =

    member val Handlers = new List<Type*obj>() 
        
    member this.Dispatch(msg: string) = 
        let parts = msg.Split([|";;;"|], 2, StringSplitOptions.None)
        let (t, json) = parts.[0], parts.[1]
        let msg_type = Type.GetType(t)
        let msg_obj = JsonConvert.DeserializeObject(json, msg_type)

        let handlers = this.Handlers |> Seq.filter (fun tup -> fst tup = msg_type ) |> Seq.map snd
        
        for h in handlers do
            let htype = h.GetType()
            let iface = htype.GetInterface("IMessageHandler`1")

            let meth = iface.GetMethods().[0]
            meth.Invoke(h, [|msg_obj|]) |> ignore
        
        ()

    member this.AddHandler(hnd: obj) =
        let ht = hnd.GetType()
        let intf = ht.GetInterfaces().[0]
        let msg_type = intf.GetGenericArguments().[0]

        this.Handlers.Add((msg_type, hnd));
        ()

let serialize obj =
    let t = obj.GetType()
    let n = t.FullName
    n + ";;;" + JsonConvert.SerializeObject obj

[<EntryPoint>]
let main argv = 
    printfn "%A" argv
    let fh = FooHandler() 

    let foo = FooMessage()
    foo.Name <- "Tauno"

    let bar = BarMessage()
    bar.Age <- 12

    let reg = HandlerRegistry()
    reg.AddHandler(fh)

    let bh = BarHandler()
    reg.AddHandler(bh)

    for msg in [serialize foo; serialize bar] do
        reg.Dispatch(msg)
        
    0 // return an integer exit code
