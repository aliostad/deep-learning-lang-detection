namespace FSharpApp.Api.Controllers

open FSharpApp.Api.Helpers.ApiControllerExtensions
open FSharpApp.Core
open FSharpApp.Service;
open System.Web.Http
open System.Web.Http.Results

/// Retrieves values.
type CarController() =
    inherit ApiController()
    
    member x.Post(car: Car) =
      CarService.Create car
      |> Either.Match x.InternalServerErrorResult x.OkResult

    member x.Get(make: string) =
      CarService.Find (fun a -> a.Make = make)
      |> Either.Match x.BadRequestResult x.OkResult

    /// Gets all values.
    member x.Get() =
      CarService.GetAll()
      |> x.OkResult