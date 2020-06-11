module NewMessageButtonMediator

open NewMessageButtonTypes
open NewMessageButtonHandlers
//Mediator calling the handler for the action
let handleAction
  mapItems
  state
  (action:NewMessageButtonTypes.Action) =
    match action with
      | New action ->
        let handler = 
          mapItems
            state
            action.index
        match action.``type`` with
          | Two message ->
              handler//call handler with state
                (handleTwo message) 
      | Org action ->
          MessageButtonMediator.handleAction 
            mapItems
            state
            action
   
let middleware =
  [
    fun
      (state:NewMessageButtonState) //module only cares about module state
      wrapper
      store //@todo: do not need whole store just somethign that has emit 
      // next
      (action:Action)
       ->
        match action with
          | Org a ->
            match a.``type`` with
              | MessageButtonTypes.One data ->
                  printfn 
                    "NewMessageButton middleware: the message is:%d" data
                  Some action
              | _ ->
                  Some action
            | _ ->
                Some action
    fun
      (state:NewMessageButtonState) //module only cares about module state
      wrapper
      store //@todo: do not need whole store just somethign that has emit 
      // next
      (action:Action)
       ->
        match action with
        | Org a ->
          match a.``type`` with
            | MessageButtonTypes.One data ->
                // startTimer ()
                Some action
            | _ -> Some action
        | New a ->
          match a.``type`` with
            | Two data ->
                // stopTimer state.[action.index]
                Some action
  ]