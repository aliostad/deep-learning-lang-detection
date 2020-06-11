namespace Example

open System.Web.Http
open System.Net
open System.Net.Http
open Example.Outputs
open Example.CryptoHelpers

type PingController() = 
    inherit ApiController() 

    [<Route("api/ping")>]
    [<HttpGet>]
    member this.Get() = 
        // sprintf "%A" this.Request |> log
        "Hello World!"

type PersonController() = 
    inherit ApiController()

    [<Route("api/people/{personId}")>]
    [<HttpGet>]
    member this.Get(personId) = 
        {   Id = personId
            Person.Name = "Bob"
            Age = 40
            Products = [{Descr = "Best Product"; Price = 34.95M }]}

    [<Route("api/people/{personId}")>]
    [<HttpPost>]
    member this.Post([<FromBody>] personInput:Person) =
        // TODO: Validate input and send a command to the domain 
        this.Request.CreateResponse(HttpStatusCode.Created)

type LogInController() = 
    inherit ApiController() 

    [<Route("api/login")>]
    [<HttpPost>]
    member this.Post([<FromBody>] loginInput: Login) = 
        printfn "%A" loginInput
        match loginInput with
        | { Username = "John"; Pwd = "Password1" } ->
            createToken (loginInput.Username, (Handlers.getIpAddress this.Request))
        | _ -> ""


    

