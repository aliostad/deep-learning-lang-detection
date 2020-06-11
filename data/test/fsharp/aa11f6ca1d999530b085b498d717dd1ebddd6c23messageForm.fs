[<RequireQualifiedAccess>]
module MessageForm

module R = Fable.Helpers.React
module P = Fable.Helpers.React.Props
open Abstractions
open Fable.Core
 
type Handler = {Handler: string -> string -> unit}

type Component(handler)= 
    inherit R.Component<Handler, obj>(handler)

    let mutable author = None
    let mutable text = None 
    
    let handleSay e = 
        let av = author?getValue $ ()
        let tv =  text?getValue $ ()
        handler.Handler (av.ToString().Trim() ) (tv.ToString().Trim())
        author?setValue $ "" |>ignore
        text?setValue $ "" |> ignore

    member x.render () = 
        let inputAuthor = R.input [P.ClassName "nametextBox"; P.Type "text"; P.Ref (fun e -> author <- Some  e)] []
        let inputText = R.input [P.ClassName "messageTextBox"; P.Type "text"; P.Ref (fun e -> text <- Some  e)] []
        let button = R.button [P.ClassName "sayButton"; P.Type "submit"; P.Label "Say"; P.Value <| Case1 "Post"; P.OnMouseDown handleSay] []

        R.div [P.ClassName "messageList" ] [inputAuthor; inputText; button]
           