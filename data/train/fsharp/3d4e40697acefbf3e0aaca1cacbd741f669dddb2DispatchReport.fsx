
#r "lib/BookingEvents.dll"

open BookingEvents

// Dispatch want a list of unconfirmed bookings
type BookingConfirmationStatus = Unconfirmed | Confirmed

// Signature of event handler
type DispatchBookingEventHandler = BookingConfirmationStatus option -> BookingEvent -> BookingConfirmationStatus option

// Event handler
let dispatchBookingEventHandler status (event : BookingEvents.BookingEvent ) = 

    match status with
    | None -> 
        Some Unconfirmed
    | Some currentStatus ->
        match event with
        | Confirmation _ -> Some Confirmed
        | _ -> status

// Gets the latest booking status
let bookingStatus id = 
    id
    |> BookingEventsDb.getBookingEvents
    |> Seq.fold(dispatchBookingEventHandler) None

printfn "Lastest booking status is %A" (bookingStatus 123)

// Gets the booking status after "eventCount" events
let bookingStatusAt eventCount id = 
    id
    |> BookingEventsDb.getBookingEvents
    |> Seq.take eventCount
    |> Seq.fold(dispatchBookingEventHandler) None

[ 0 .. 4 ]
|> Seq.iter(
    fun i -> 
        123
        |> bookingStatusAt i
        |> printfn "Booking status after %i events: %A" i)