
namespace DotNet.System.Windows.Controls

module Button =                
              
    open Data.Typeable
    open DotNet.System.Object
    open DotNet.System.Windows.RoutedEventHandler
    open DotNet.System.Windows.Controls.ContentControl
    open DotNet.System.Windows.FrameworkElement
    
    // Type definition
    type Button = System.Windows.Controls.Button  
    type ZCTSubButton<'aayD> = ZCDSubButton of 'aayD    
    let zdfTypeableButton : Lazy<ZCTTypeable<Button>> = lazy (fun _ -> typeof<Button>)
    let zdfSubFrameworkElementButton : Lazy<ZCTSubFrameworkElement<Button>> = lazy ZCDSubFrameworkElement (null)
    let zdfSubContentControlButton : Lazy<ZCTSubContentControl<Button>>= lazy ZCDSubContentControl (null)
    let zdfSubObjectButton : Lazy<ZCTSubObject<Button>>= lazy ZCDSubObject (null)
    let zdfSubButtonButton : Lazy<ZCTSubButton<Button>> = lazy ZCDSubButton (null)    

    // Methods    
    let newButton : unit -> GHC.IOBase.IO<Button> = 
        fun handler ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (new Button())) 

    let addClick<'cayy when 'cayy :> Button> : Lazy<ZCTSubButton<'cayy>> -> Lazy<RoutedEventHandler> -> Lazy<'cayy> -> GHC.IOBase.IO<unit> = 
        fun _ handler control ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (control.Force()).Click.AddHandler (handler.Force()))
                    
    let removeClick<'cayy when 'cayy :> Button> : Lazy<ZCTSubButton<'cayy>> -> Lazy<RoutedEventHandler> -> Lazy<'cayy> -> GHC.IOBase.IO<unit> = 
        fun _ handler control ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (control.Force()).Click.RemoveHandler (handler.Force()))