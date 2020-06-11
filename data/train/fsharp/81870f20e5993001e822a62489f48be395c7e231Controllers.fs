namespace Booking.Api.Controllers

open System
open System.Net
open System.Net.Http
open System.Web.Http
open Booking.Api
open Booking.Api.Envelope
open System.Reactive.Subjects

type HomeController() =
    inherit ApiController()

    member this.Get() = 
        let message = new HttpResponseMessage()
        message.Content <- new StringContent("Booking api")

        message

type ReservationsController() =
    inherit ApiController()
    let subject = new Subject<Envelope<MakeReservation>>()

    member this.Post(rendition : MakeReservationRendition) =
        let cmd = 
            {
                MakeReservation.Date = DateTime.Parse rendition.Date
                Name = rendition.Name
                Email = rendition.Email
                Quantity = rendition.Quantity
            }
            |> EnvelopWithDefaults

        subject.OnNext cmd

        new HttpResponseMessage(HttpStatusCode.Accepted)

    override this.Dispose disposing =
        if disposing then subject.Dispose()
        base.Dispose disposing

    interface IObservable<Envelope<MakeReservation>> with
        member this.Subscribe observer = subject.Subscribe observer
