namespace Piter.Samples.Booking.HttpApi

open System.Net
open System.Net.Http
open System.Web.Http

[<CLIMutable>]
type MakeReservationRendition = {
    Date : string
    Name : string
    Email : string
    Quantity : int }

type HomeController() =
    inherit ApiController()
    member this.Get() = new HttpResponseMessage()

type ReservationController() = 
    inherit ApiController()
    member this.Post (rendition : MakeReservationRendition) = 
        new HttpResponseMessage(HttpStatusCode.Accepted)

