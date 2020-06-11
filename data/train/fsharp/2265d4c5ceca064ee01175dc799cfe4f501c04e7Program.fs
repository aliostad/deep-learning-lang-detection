open System
open System.Windows
open System.Windows.Controls


type StronglySharedValue<'a> (value:'a) =
  let mutable _value = value
  let changed = Event<'a>()
  member __.V = _value
  member __.Change value =
    _value <- value
    changed.Trigger _value
  member __.Changed = changed.Publish


type HandlerWithWeakReference<'a> = 
  {
    WeakReference : WeakReference
    Handler : obj -> 'a -> unit
  }


type WeaklySharedValue<'a>(value:'a) =
  let mutable _value = value
  let changed : ResizeArray<HandlerWithWeakReference<'a>> = ResizeArray()
  let trigger value =
    let deadHandlers = ResizeArray()
    for handler in changed do
      if handler.WeakReference.IsAlive then
        handler.Handler handler.WeakReference.Target _value
      else
        deadHandlers.Add handler
    for handler in deadHandlers do
      changed.Remove handler |> ignore
    deadHandlers.Clear()

  member __.V = _value
  member __.Change value =
    _value <- value
    trigger _value
  member __.Changed(target:'b) (handler: 'b->'a->unit) =
    let downCastToTargetType(obj:obj) : 'b = downcast obj
    { 
      WeakReference = WeakReference target
      Handler       = downCastToTargetType >> handler
    }
    |> changed.Add


let stackPanel = StackPanel()
let window = Window(Content=stackPanel)

let append x = stackPanel.Children.Add x |> ignore 

let button = Button(Content="Show or Collapse") 
button |> append 

let weakReferenceCountTextBlock = TextBlock(Text="WeakReference: ") 
weakReferenceCountTextBlock |> append

let strongCountTextBlock = TextBlock(Text="StrongReference: ")
strongCountTextBlock |> append



type WeakButton(weakCount :int WeaklySharedValue) as btn =
  inherit Button(Content="Weak")
  do
    btn.Click.Add <| fun _ ->
      weakCount.Change <| weakCount.V + 1

    weakCount.Changed btn <| fun btn count ->
      weakReferenceCountTextBlock.Text <- weakReferenceCountTextBlock.Text + string count



type StrongButton(strongCount :int StronglySharedValue) as btn =
  inherit Button(Content="Strong")
  do
    btn.Click.Add <| fun _ ->
      strongCount.Change <| strongCount.V + 1
    strongCount.Changed.Add <| fun count -> 
      strongCountTextBlock.Text <- strongCountTextBlock.Text + string count
           
let weakCount   = WeaklySharedValue 0
let strongCount = StronglySharedValue 0


let mutable isShown = false
button.Click.Add <| fun _ ->
  if isShown then             
    stackPanel.Children.RemoveAt 3 
    stackPanel.Children.RemoveAt 3
    weakReferenceCountTextBlock.Text <- weakReferenceCountTextBlock.Text + " "
    strongCountTextBlock.Text <- strongCountTextBlock.Text + " "

  else 
    new WeakButton(weakCount) |> append
    new StrongButton(strongCount) |> append

    GC.Collect()
    weakCount.Change weakCount.V
    strongCount.Change strongCount.V

  isShown <- not isShown


[<STAThread>][<EntryPoint>]
let main _ = Application().Run window