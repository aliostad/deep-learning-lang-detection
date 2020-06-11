namespace GrauhundReisen.Funktional

open Commands
open Domain

module CommandHandler = 
    let handleOrderBooking store handle (c : OrderBooking) = 
        Booking.order c.Id c.FirstName c.LastName c.Email c.CreditCardType c.CreditCardNumber c.Destination
        |> Aggregate.getChanges
        |> List.iter (fun event -> 
               store c.Id event
               handle c.Id event)
    
    let handleChangeBooking retrieve store handle (c : ChangeBooking) = 
        retrieve c.Id
        |> Aggregate.fromHistory
        |> Booking.changeCreditCardNumber c.CreditCardNumber
        |> Booking.changeEMail c.Email
        |> Aggregate.getChanges
        |> List.iter (fun event -> 
               store c.Id event
               handle c.Id event)
    
    type Booking(es : EventStore.StoreAdapter, handler : EventHandlers.Booking) = 
        let handle = handler.Handle
        let store = es.Store
        let retrieve = es.RetrieveFor
        member this.Handle(cmd : OrderBooking) = handleOrderBooking store handle cmd
        member this.Handle(cmd : ChangeBooking) = handleChangeBooking retrieve store handle cmd
