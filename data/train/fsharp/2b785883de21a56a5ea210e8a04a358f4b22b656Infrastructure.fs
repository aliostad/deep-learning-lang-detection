module Infrastructure

let composeCustomer (store:MemoryStore.Store) id = 
    store.get id |> Option.map ( Seq.fold Customer.apply Customer.State.Zero )

let store = MemoryStore.Create()

let getCustomer = composeCustomer store
let commitEvent = store.commit

type Handler<'T> = MailboxProcessor<'T>

type Envelope = 
    { id : int
      command : Customer.Commands }

let eventsHandler = 
    MailboxProcessor<Customer.Events>.Start(fun inbox -> 
        async { 
            while true do
                let! event = inbox.Receive()
                match event with
                | Customer.Created name -> printf "created %s" name
                | _ -> printf "some other event"
        })

let handler = 
    MailboxProcessor<Envelope>.Start(fun inbox -> 
        async {
            while true do
                let! msg = inbox.Receive()
                let state = getCustomer msg.id
                
                let event = 
                    match state with
                    | None -> Customer.exec Customer.State.Zero msg.command
                    | Some state -> Customer.exec state msg.command
                commitEvent (msg.id,event)
                eventsHandler.Post(event)
        })

//todo: projection
//multiple handlers


//handler.Post({ id = 10
//               command = Customer.Create("test") })
//handler.Post({ id = 11
//               command = Customer.Create("test2") })
//handler.Post({ id = 10
//               command = Customer.ChangeLicense(Customer.Saas) })
