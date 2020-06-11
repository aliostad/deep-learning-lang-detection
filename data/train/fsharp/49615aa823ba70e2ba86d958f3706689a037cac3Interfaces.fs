namespace InteractiveProvider.Interfaces

type IInteractiveState=
    abstract member DisplayText : string
    abstract member DisplayOptions : (string * obj) list

type IInteractiveServer = 
    abstract member NewState : IInteractiveState
    abstract member ProcessResponse : IInteractiveState * obj -> IInteractiveState

type InteractiveState<'a> =
    { displayOptions : 'a -> (string * obj) list 
      displayText : 'a -> string 
      processResponse : 'a * obj -> IInteractiveState
      state : 'a }
    member x.ProcessResponse o = x.processResponse (x.state, o)
    interface IInteractiveState with
        member x.DisplayOptions =  x.displayOptions x.state
        member x.DisplayText = x.displayText x.state


open System 

[<AutoOpen>]
module Utils =
    type System.String with
        member x.ValueOption() = if String.IsNullOrWhiteSpace x then None else Some x 
    let rnd =  System.Random(System.DateTime.Now.Millisecond)
    let wrapAndSplit (text:string) =
        let text = 
            text.Split([|Environment.NewLine|], StringSplitOptions.None)
            |> Array.map(fun s -> String.Format("<para>{0}</para>", s.Replace(" "," ")))
            |> fun t ->  String.Join("\r\n", t)
        String.Format("<summary>{0}</summary>", text)
