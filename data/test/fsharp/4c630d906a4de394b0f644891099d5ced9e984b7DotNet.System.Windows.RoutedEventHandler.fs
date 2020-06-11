
namespace DotNet.System.Windows

module RoutedEventHandler = 
    
    open Data.Typeable
    open DotNet.System.Object    
    open DotNet.System.Windows.RoutedEventArgs
    
    // Type definition
    type RoutedEventHandler = System.Windows.RoutedEventHandler  
    type ZCTSubRoutedEventHandler<'aayD> = ZCDSubRoutedEventHandler of 'aayD    
    let zdfTypeableRoutedEventHandler : Lazy<ZCTTypeable<RoutedEventHandler>> = lazy (fun _ -> typeof<RoutedEventHandler>)
    let zdfSubObjectRoutedEventHandler : Lazy<ZCTSubObject<RoutedEventHandler>>= lazy ZCDSubObject (null)
    let zdfSubRoutedEventHandlerRoutedEventHandler : Lazy<ZCTSubRoutedEventHandler<RoutedEventHandler>> = lazy ZCDSubRoutedEventHandler (null)
    
    let private transform : (Lazy<Object> -> Lazy<RoutedEventArgs> -> GHC.IOBase.IO<unit>) -> (obj -> RoutedEventArgs -> unit) =
        fun f ->
            fun o e ->
                GHC.IOBase.unsafePerformIO (f (lazy o) (lazy e))
                
    // Methods
    let newRoutedEventHandler : ((Lazy<Object> -> Lazy<RoutedEventArgs> -> GHC.IOBase.IO<unit>) -> GHC.IOBase.IO<RoutedEventHandler>) = 
        fun handler ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (new RoutedEventHandler(transform handler))) 
            