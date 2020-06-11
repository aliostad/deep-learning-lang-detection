namespace Booking.Api

open System
open System.Net.Http
open System.Web.Http
open System.Web.Http.Dispatcher
open System.Web.Http.Controllers
open Newtonsoft.Json.Serialization
open global.Owin
open Booking.Api.Controllers
open Booking.Api.Envelope
open Booking.Api.Reservations

type Route = { 
    controller : string
    id : RouteParameter }

type Agent<'T> = Microsoft.FSharp.Control.MailboxProcessor<'T>

type CompositionRoot() =
    let seatingCapacity = 10
    let reservations = 
        System.Collections.Concurrent.ConcurrentBag<Envelope<Reservation>>()

    let agent = new Agent<Envelope<MakeReservation>>(fun inbox ->
        let rec loop() =
            async {
                let! cmd = inbox.Receive()
                let rs = reservations |> ToReservations
                let handle = Handle seatingCapacity rs
                let newReservation = handle cmd

                match newReservation with
                | Some(r) -> reservations.Add r
                | _ -> ()

                return! loop()
            }

        loop()
    )

    do agent.Start()

    interface IHttpControllerActivator with
        member this.Create(request, controllerDescriptor, controllerType) =
            match controllerType with
            | t when t = typeof<HomeController> -> new HomeController() :> IHttpController
            | t when t = typeof<ReservationsController> ->
                let c = new ReservationsController()
                let sub = c.Subscribe agent.Post
                // unsubscribe when controller is disposed of
                request.RegisterForDispose(sub)

                c :> IHttpController
            | _ -> raise <| ArgumentException(sprintf "Unknown controller type requested: %O" controllerType, "controllerType")

type Startup() =
    member this.Configuration(appBuilder : IAppBuilder) =
        let config = new HttpConfiguration()

        config.Services.Replace(
            typeof<IHttpControllerActivator>,
            CompositionRoot()
        )

        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <-
            new CamelCasePropertyNamesContractResolver()

        config.Routes.MapHttpRoute(
            "DefaultApi",
            "api/{controller}/{id}",
            { controller = "Home"; id = RouteParameter.Optional }
        ) |> ignore

        appBuilder.UseWebApi(config) |> ignore
