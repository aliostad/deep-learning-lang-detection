namespace CIPHERPrototype

open WebSharper
open WebSharper.JavaScript
open CIPHERHtml

[<JavaScript>]
module DynNode =
 
    type Props    = { nodeF      : unit -> CipherNode
                      subscribe  : (unit -> unit) -> unit }
    type Model    = App.Dummy
    let init      = App.DummyNew
    type Message  = Dummy
    let update (props: Props) (msg: Message)  model = model

    let view (props: Props) (model: Model) (processMessages: Message -> unit) =
        props.subscribe (fun () -> Dummy |> processMessages) 
        props.nodeF()

    let app = App.App(init, update, view)

    let node nodeF sub = app.node { nodeF = nodeF ; subscribe = sub }

