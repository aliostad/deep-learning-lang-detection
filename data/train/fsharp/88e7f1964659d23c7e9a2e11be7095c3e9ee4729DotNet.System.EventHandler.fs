
namespace DotNet.System

module EventHandler = 
    
    open Data.Typeable
    open DotNet.System.Object
    open DotNet.System.EventArgs
    
    // Type definition
    type EventHandler = System.EventHandler  
    type ZCTSubEventHandler<'aayD> = ZCDSubEventHandler of 'aayD    
    let zdfTypeableEventHandler : Lazy<ZCTTypeable<EventHandler>> = lazy (fun _ -> typeof<EventHandler>)
    let zdfSubObjectEventHandler : Lazy<ZCTSubObject<EventHandler>>= lazy ZCDSubObject (null)
    let zdfSubEventHandlerEventHandler : Lazy<ZCTSubEventHandler<EventHandler>> = lazy ZCDSubEventHandler (null)
    
    let private transform : (Lazy<Object> -> Lazy<EventArgs> -> GHC.IOBase.IO<unit>) -> (obj -> EventArgs -> unit) =
        fun f ->
            fun o e ->
                GHC.IOBase.unsafePerformIO (f (lazy o) (lazy e))
                
    // Methods
    let newEventHandler : ((Lazy<Object> -> Lazy<EventArgs> -> GHC.IOBase.IO<unit>) -> GHC.IOBase.IO<EventHandler>) = 
        fun handler ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (new EventHandler(transform handler)))            
            