module TransMain
#r "../node_modules/fable-core/Fable.Core.dll"
#load "./appcontroller.fsx"
#load "./redux.fsx"

// define(
//   ["exports","common","./appcontroller"
//    ,"./todocontroller","./totalscontroller","./views/app","redux","riot","./transmain"
//   ]


open Fable.Core
open Fable.Import.Browser
open ActionCreator

type HandlerFunctions = {
  TodoHandler : TodoController.TodoState * Action -> TodoController.TodoState
  TotalsHandler : Totalscontroller.TotalsState * Action -> Totalscontroller.TotalsState
  AppHandler : AppController.ApplicationModel * Action -> AppController.ApplicationModel
}

let handlers = {
  TodoHandler = TodoController.appHandler
  TotalsHandler = Totalscontroller.appHandler
  AppHandler = AppController.appHandler
}

let applicationHandler (state:AppController.ApplicationModel) action =
  match action.``type`` with
    | TodoAction index ->
      { state 
        with TodoList = 
              state.TodoList
              |> Array.indexed
              |> Array.map  
                (fun (i,item) ->
                  if i = index then
                    (handlers.TodoHandler (item,action))
                  else
                    item)}
    | TotalsAction ->
        { state 
          with Totals = (handlers.TotalsHandler (state.Totals,action))}
    | AppAction ->
        handlers.AppHandler (state,action)
    | _ ->
        state

[<Import("*","../js/JSI")>]
module JSI =
  [<Pojo>]
  type HasGetStore = {
    getStore:unit -> Fable.Import.Store<AppController.ApplicationModel>
  }
  [<Pojo>]
  type HasUpdate = {
    update:AppController.ApplicationModel -> unit
  }

  let createStore:
    ( 
      (AppController.ApplicationModel -> Action -> AppController.ApplicationModel)
        -> AppController.ApplicationModel
        -> Fable.Import.Store<AppController.ApplicationModel>
    ) = jsNative
  let Mixin: HasGetStore -> unit = jsNative
  let Mount: string -> AppController.ApplicationModel -> array<HasUpdate> = jsNative

[<Import("*","../js/common")>]
module common =
  let setStore: 
    Fable.Import.Store<AppController.ApplicationModel> 
      -> unit = jsNative

let store = 
  JSI.createStore 
    applicationHandler
    AppController.defaultModel

common.setStore store

let mxa () = store
let mm:JSI.HasGetStore = {
  getStore = mxa
}
JSI.Mixin mm

let apps = JSI.Mount "app" AppController.defaultModel

store.subscribe
  (fun () ->
    apps.[0].update (store.getState ())
  )

[<Import("*","../js/views/app")>]
module app =
  let app:string = jsNative

