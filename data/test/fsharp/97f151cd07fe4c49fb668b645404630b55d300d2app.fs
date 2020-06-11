module App

open System
open Fable.Core
open Fable.Import
open Abstractions 
open Abstractions.Operators

module R = Fable.Helpers.React
module P = Fable.Helpers.React.Props  

type ViewModel = {
    MessageList : MessageList.Model 
}
with static member Empty = {MessageList = MessageList.Model.Empty} 
     static member _MessageList =  ((fun x -> x.MessageList), (fun t x -> {x with MessageList = t}))

let state = ref <| State.init ViewModel.Empty
   
let msgListCurosr = 
    ViewModel._MessageList
    |> Cursor.create state

let handler a t = 
    let state = msgListCurosr.Getter ()
    let state' = {Message.Date = DateTime.Now; Message.Text = t; Message.Author = a} :: state.Messages |> List.rev
    msgListCurosr.Setter {MessageList.Messages = state'}
    ()

ReactDom.render(  
    R.div [] [
        R.com<MessageList.Component,_,_> msgListCurosr []
        R.com<MessageForm.Component,_,_> {MessageForm.Handler = handler} []
    ],
    Browser.document.getElementById "content"
)  
|> ignore