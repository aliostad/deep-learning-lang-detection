namespace Example

open System.Web.Http
open System.Net
open System.Net.Http
open Example.Outputs

type PingController() =
    inherit ApiController()

    [<Route("api/ping")>]
    [<HttpGet>]
    member this.Get() =
        "Hello World!"

type PersonController() =
    inherit ApiController()

    [<Route("api/people/{personId}")>]
    [<HttpGet>]
    member this.Get(personId) =
        {   Id = personId
            Person.Name = "Bob"
            Age = 40
            Products = [{Descr = "Best Product"; Price = 34.95M }] }

    [<Route("api/people/{personId}")>]
    [<HttpPost>]
    member this.Post([<FromBody>] personInput:Person) =
        (*
            Many important things happen here
        *)
        this.Request.CreateResponse(HttpStatusCode.Created)