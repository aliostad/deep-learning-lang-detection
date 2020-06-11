
namespace DotNet.System.Windows.Forms

module Form = 

    open Data.Typeable
    open DotNet.System.Object
    open DotNet.System.EventHandler
    open DotNet.System.Windows.Forms.Control
    
    // Type definition
    type Form = System.Windows.Forms.Form    
    type ZCTSubForm<'aayD> = ZCDSubForm of 'aayD    
    let zdf1 : Lazy<ZCTTypeable<Form>> = lazy (fun _ -> typeof<Form>)
    let zdf2 : Lazy<ZCTSubObject<Form>> = lazy ZCDSubObject (null)
    let zdf3 : Lazy<ZCTSubControl<Form>> = lazy ZCDSubControl (null)
    let zdf4 : Lazy<ZCTSubForm<Form>> = lazy ZCDSubForm (null)
    
    let newForm : (unit -> GHC.IOBase.IO<Form>) = 
        fun _ ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (new Form()))
        
    let addLoad<'cayy when 'cayy :> Form> : Lazy<ZCTSubForm<'cayy>> -> Lazy<EventHandler> -> Lazy<'cayy> -> GHC.IOBase.IO<unit> = 
        fun _ handler control ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (control.Force()).Load.AddHandler (handler.Force()))
                    
    let removeLoad<'cayy when 'cayy :> Form> : Lazy<ZCTSubForm<'cayy>> -> Lazy<EventHandler> -> Lazy<'cayy> -> GHC.IOBase.IO<unit> = 
        fun _ handler control ->
            GHC.Base.hreturn GHC.Base.zdfMonadIO (lazy (control.Force()).Load.RemoveHandler (handler.Force()))
   
        