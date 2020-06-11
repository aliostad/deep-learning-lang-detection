namespace PhoneCat.Web.Controllers


open System.Web.Http
open PhoneCat.Domain

type ManufacturersViewModel =
    {
        Name : string
    }

[<RoutePrefix("api/manufacturers")>]
type ManufacturersController
    (
        getManufacturerNames : seq<Phone> -> seq<ManufacturerName>,
        phones : seq<Phone>              
    ) = 
    inherit ApiController()

    [<Route("")>]
    member this.Get () =
      getManufacturerNames phones
      |> Seq.distinct
      |> Seq.map (fun name -> {Name = ManufacturerName.ToString name})