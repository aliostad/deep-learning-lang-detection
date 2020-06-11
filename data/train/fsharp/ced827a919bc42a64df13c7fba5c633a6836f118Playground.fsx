#load "Coffeebucks/Api.fsx"

open System
open ReactiveDomain.Interpreters.IO
open Coffeebucks
open Coffeebucks.Domain
open Coffeebucks.Interpreters


// subscribe to events
EventBus.subscribe (fun (id,e) -> async {printfn "Handling event: (%A), %A" id e; return ()})


let order = { 
    Order.Items = 
        [
            {SKU = "Iced Tea - Medium"
             UnitPrice = 3.99m
             Quantity = 2m }
        ]}

let newItem1 = 
    {SKU = "Americano - Small"
     UnitPrice = 1.49m
     Quantity = 1m }

let newItem2 = 
    {SKU = "Bottled Water"
     UnitPrice = 1.99m
     Quantity = 2m }



let result1 =
    io {

        let orderId = Guid "1d71b3b9-79ec-4c2b-8125-4401e7cea8a7"
        
        do! Api.placeOrder (orderId, order) 
        do! Api.addMoreItems (orderId, [newItem1])
        do! Api.addMoreItems (orderId, [newItem2])
        do! Api.removeItems (orderId, ["Americano - Small"])
    }
    |> Async.RunSynchronously

match result1 with
| Error err -> err |> printfn "Error: %A"
| _ -> ()


let result2 =
    io {

        let saleOrderId = Guid "7d44b144-3eb6-4222-bcb3-81e62e2e7333"
        
        do! Api.placeOrder (saleOrderId, order) 
        do! Api.addMoreItems (saleOrderId, [newItem1])
        do! Api.addMoreItems (saleOrderId, [newItem2])
    }
    |> Async.RunSynchronously

match result2 with
| Error err -> err |> printfn "Error: %A"
| _ -> ()



// list produced events in the store
InMemoryEventStore.store