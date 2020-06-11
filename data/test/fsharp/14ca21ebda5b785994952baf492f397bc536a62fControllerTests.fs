namespace FRest.Tests

open Moq
open Xunit
open System.Web.Http
open System.Net.Http

open FRest
open FRest.Contracts

module ``API Controller Tests`` =

    let awaitTask (t : System.Threading.Tasks.Task<'a>) : 'a =
        if not <| t.Wait (1000) then failwith "tasks did not finish in time" else
        t.Result

    let getResponse (response : HttpResponseMessage) : 'a =
        let v = ref Unchecked.defaultof<'a>
        Assert.True (response.TryGetContentValue<'a> v)
        !v

    let addConfig (controller : ApiController) =
        let config = new HttpConfiguration()
        controller.Configuration <- config
        controller.Request <- new HttpRequestMessage()
        controller.Request.Properties.[Hosting.HttpPropertyKeys.HttpConfigurationKey] <- config;
        

    module ``Controller MyApi `` =

        let setupController handler =
            let controller = new Server.MyApiController (handler)
            addConfig (controller :> ApiController)
            controller

        module ``Action Echo `` =

            [<Fact>]
            let ``with msg="Hello" should reply with the same Echo``() = 
                use controller = setupController Handler.initial

                let response : Messages.Echo = 
                    controller.Echo "Hello"
                    |> awaitTask
                    |> getResponse

                Assert.Equal ("Hello", response.message)        
