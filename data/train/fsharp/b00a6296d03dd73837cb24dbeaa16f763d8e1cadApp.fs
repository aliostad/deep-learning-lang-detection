open Suave
open Suave.Web
open Suave.Http
open Suave.Http.Applicatives
open Suave.Http.RequestErrors
open Rop
open Errors
open PrimitiveTypes
open PrimitiveTypes.Id
open State
open Suave.Http.Successful
open FriendList

let transformer = {
  ZeroState = FriendList.State.Zero
  Reducer = FriendList.reducer
  Producer = FriendList.producer 
}

let cmdHandler = State.createHandler(transformer, Db.loadState, Db.saveState)

let createApp (handler:Command * Option<Id> -> Result<Id*Event,Error>) = 
  choose [
    GET >>= path "/" >>= OK "Hi!"
    POST >>= choose [
      path "/friendslist" >>= warbler(fun _ ->
        match handler(Command.CreateFriendList, None) with
        | Success (id,event) -> id |> Id.toStr |> OK 
        | Failure e          -> BAD_REQUEST ""
      )
    ]
  ]

let app = createApp cmdHandler
startWebServer defaultConfig app