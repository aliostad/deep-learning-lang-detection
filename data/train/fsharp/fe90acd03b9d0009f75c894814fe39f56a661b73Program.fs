module Program

open System
open System.Threading
open Model
open System.Collections.Generic
open System.Threading.Tasks
open ThreadedHandler

let messagePrinter = fun (msg : Message) ->
    let order = match msg with
    | OrderPlaced order -> order
    | OrderCooked order -> order
    | OrderPriced order -> order
    | OrderPaid order -> order

    printf ">>> Served %d\r\n" order.TableNumber
    ()



// Waiter functions

let placeOrder = fun (tableNumber : int) ->
    let order = 
        {
            TableNumber = tableNumber
            SubTotal = 0.0
            Tax = 0.0
            Total = 0.0
            Ingredients = ""
            OrderId = Guid.NewGuid()
            Items = List.Empty
            IsPaid = false
            CreatedOn = DateTime.Now

            Id = Guid.NewGuid()
            CorrId = Guid.NewGuid()
            CauseId = Guid.Empty
        };
    publish (OrderPlaced order)


// Cook functions

let cookFood (name : string) (timeToCook : int) (msg : Message) =
    match msg with
    | OrderPlaced order ->


        let newOrder =
                 { order with
                    Ingredients = "Spaghetti"
                    
                    Id = Guid.NewGuid()
                    CauseId = order.Id
                 }
    //    printf "%s is cooking...\r\n" name
        Thread.Sleep(timeToCook)

        publish (OrderCooked newOrder)
    | _ -> ()


// Assistant Manager functions

let priceOrder (msg : Message) =


    match msg with
    | OrderCooked order ->
    
        let priced = { order with
            SubTotal = 12.2
            Total = 12.2 * 0.2
            Tax = 0.2

            Id = Guid.NewGuid()
            CauseId = order.Id
        }

    //    printf "Pricing...\r\n"
        Thread.Sleep(500)

        publish (OrderPriced priced)
    | _ -> ()

    
// Cashier functions

let payOrder (msg : Message) =
    
    match msg with
    | OrderPriced order ->

        let paid = { order with
            IsPaid = true

            Id = Guid.NewGuid()
            CauseId = order.Id
        }

    //    printf "Paying...\r\n"

        Thread.Sleep(100)

        publish (OrderPaid paid)
    | _ -> ()


let isExpired = fun (order: Order) (ttl : int) ->
    (order.CreatedOn.AddMilliseconds (float ttl)) < DateTime.Now


// Repeater
let repeater = fun (nextHandles : List<Handle>) (order: Order) ->
    for handle in nextHandles do
        handle order

// Round Robin
let roundRobin = fun (nextHandles : Queue<Handle>) (order: Order) ->

    let cook = nextHandles.Dequeue()

    cook order

    nextHandles.Enqueue cook  

let threadedHandler = fun (orderQueue: Queue<Order>) (order: Order) ->
    orderQueue.Enqueue order

let startThread = fun (handler: Handle) (orderQueue : Queue<Order>) ->
    let task = Task.Factory.StartNew((fun () ->
        match (orderQueue.Count > 0) with
        | true -> handler(orderQueue.Dequeue())
        | false -> Thread.Sleep(1)
    ), TaskCreationOptions.LongRunning)

    ()

let rec moreFairHandler = fun (handlers : Queue<ThreadedHandler>) (msg: Message) ->
    let handler = handlers.Dequeue()
    handlers.Enqueue handler

    match handler.Count < 5 with
    | true ->
        handler.Handle msg
    | false ->
        Thread.Sleep(1)
        moreFairHandler handlers msg


let ttlHandler (ttl: int) (msgHandler: (Message -> unit)) (msg : Message) =
    let order = match msg with
        | (OrderPlaced order) -> Some order
        | (OrderCooked order) -> Some order
        | (OrderPriced order) -> Some order
        | (OrderPaid order) -> Some order
        | _ -> None

    match order with
    | Some o when isExpired o ttl ->
        printf "Dropped %d\r\n" o.TableNumber
        ()
    | Some o ->
        msgHandler msg
    | _ -> ()


let rec monitor = fun (handlers : ThreadedHandler list) ->
    for handler in handlers do
        printf "%s has %d jobs\r\n" handler.Name handler.Count

    Thread.Sleep(1000)
    monitor handlers



[<EntryPoint>]
let main argv =
    let orderQueue = new Queue<Order>()
    let threadedHandlerWithQueue = threadedHandler orderQueue

    let oneSecondTtl = ttlHandler 10000

    let cashier = payOrder |> oneSecondTtl
    let cashierT = new ThreadedHandler(cashier, "Cashier")

    let assistantManager = priceOrder  |> oneSecondTtl
    let assistantManagerT = new ThreadedHandler(assistantManager, "Assistant Manager")

    let r = new Random(13)
    
    let hank = cookFood "Hank" (r.Next(0, 4000)) |> oneSecondTtl
    let hankT = new ThreadedHandler(hank, "Hank")

    let tom = cookFood "Tom" (r.Next(0, 4000)) |> oneSecondTtl
    let tomT = new ThreadedHandler(tom, "Tom")

    let suzy = cookFood "Suzy" (r.Next(0, 4000))  |> oneSecondTtl
    let suzyT = new ThreadedHandler(suzy, "Suzy")
    
    let toMonitor = [
        suzyT
        tomT
        hankT
        cashierT
        assistantManagerT
        ]

    Task.Factory.StartNew((fun () -> monitor toMonitor), TaskCreationOptions.LongRunning)
        |> ignore

    let cooksQueue = new Queue<ThreadedHandler>([hankT; tomT; suzyT])
    let cooks = moreFairHandler cooksQueue

    subscribeByTopic Topic.OrderPlacedTopic cooks
    subscribeByTopic Topic.OrderCookedTopic assistantManagerT.Handle
    subscribeByTopic Topic.OrderPricedTopic cashierT.Handle
    subscribeByTopic Topic.OrderPaidTopic messagePrinter
    
//    subscribeByCorrelationId specialId messagePrinter

    for agent in toMonitor do 
        agent.Start()
    
    let waiter = placeOrder 
    for i in 0 .. 100 do 
        waiter i

    Console.ReadLine() |> ignore


    0 // return an integer exit code

    

    
