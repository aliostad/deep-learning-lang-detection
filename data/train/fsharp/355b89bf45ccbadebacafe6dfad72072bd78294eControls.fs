module Controls

open MonoTouch.UIKit
open MonoTouch.Foundation

let button localizationKey clickHandler = 
    let btn = UIButton.FromType(UIButtonType.System) 
    btn.SetTitle(localize localizationKey, UIControlState.Normal) 
    btn.TouchUpInside.Add clickHandler

    btn.BackgroundColor <- Colors.buttonBackground
    btn.SetTitleColor(Colors.buttonText, UIControlState.Normal)
    btn.Font <- Fonts.button
    btn.Layer.CornerRadius <- 2.f
    btn.ContentEdgeInsets <- new UIEdgeInsets(10.f,10.f,10.f,10.f)
    btn

     

let label localizationKey = 
    let lbl = new UILabel()
    lbl.Text <- localize localizationKey 
    lbl.Font <- Fonts.label
    lbl        

let textview() =
    let tv = new UITextView()
    tv

 
let barButtonItemWithImage imageName (clickHandler:obj->System.EventArgs->unit) =
    let image = UIImage.FromBundle(imageName)
    let barButtonItem = new UIBarButtonItem(image,UIBarButtonItemStyle.Plain, clickHandler)
    barButtonItem

let barButtinItemWithText localizationKey (clickHandler:obj->System.EventArgs->unit) =
    new UIBarButtonItem(localize localizationKey, UIBarButtonItemStyle.Plain, clickHandler)