namespace ProcessingServer.Handling

open System.IO
open System.Xml
open System.Xml.Linq
open System.Runtime.Serialization

type IHandlerContext =
    abstract member Data : System.Xml.Linq.XElement
    abstract member Trace : string -> unit

type ITaskHandler =
    abstract member CanHandle : IHandlerContext -> bool
    abstract member Handle : IHandlerContext -> unit   

[<AbstractClass>]
type SimpleTaskHandler<'a>() as this =

    let canHandle (ctx : IHandlerContext) =    
        let ser = new DataContractSerializer(typeof<'a>)                                    
        let reader = ctx.Data.CreateReader()
        ser.IsStartObject(reader)

    let handle (ctx : IHandlerContext) =
        let ser = new DataContractSerializer(typeof<'a>)                                    
        let reader = ctx.Data.CreateReader()
        let a = ser.ReadObject(reader) :?> 'a
        this.Handle(a)        
    
    interface ITaskHandler with
        member x.CanHandle(ctx) = canHandle(ctx)
        member x.Handle(ctx) = handle(ctx)

    abstract member Handle : 'a -> unit