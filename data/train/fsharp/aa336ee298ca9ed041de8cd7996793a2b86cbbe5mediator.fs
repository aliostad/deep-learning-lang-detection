module MessageButtonMediator

open MessageButtonTypes
let setup
  mapItems
  handlers=
    //Mediator calling the handler for the action
    let handleAction
      state
      (action:MessageButtonAction) =
        let handler = 
          mapItems
            state
            action.index
        match action.``type`` with
          | One message ->
              handler//call handler with state
                (handlers.handleOne message) 
          | Two message ->
              handler//call handler with state
                (handlers.handleTwo message) 
       
    let middleware =
      [
        handlers.logOne
        handlers.timer
      ]
    {
      handleAction=handleAction
      middleware=middleware
    }