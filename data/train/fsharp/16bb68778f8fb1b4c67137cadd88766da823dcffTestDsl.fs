module TestDsl

open System
open System.Reflection
open System.Net.Http
open System.Web.Http
open System.Web.Http.Hosting
open Ploeh.AutoFixture
open Ploeh.AutoFixture.AutoFoq
open Ploeh.AutoFixture.Kernel
open Ploeh.AutoFixture.Xunit

type HttpRequestMessageCustomization() =
    interface ICustomization with
        member this.Customize fixture =
            fixture.Customize<HttpRequestMessage>(fun c -> 
                c
                    .Without(fun x -> x.Content)
                    .Do(fun (x:HttpRequestMessage) -> x.Properties.[HttpPropertyKeys.HttpConfigurationKey] <- new HttpConfiguration()) 
                :> ISpecimenBuilder ) |> ignore
 
type ApiControllerSpecification() =
    interface IRequestSpecification with
        member this.IsSatisfiedBy request =
            match request with
            | :? Type as requestType -> typeof<ApiController>.IsAssignableFrom requestType 
            | _ -> false
 
type ApiControllerFiller() =
    interface ISpecimenCommand with
        member this.Execute (specimen,context) =
            if specimen = null  then raise <| ArgumentNullException "specimen"
            if context = null   then raise <| ArgumentNullException "context"
            match specimen with
            | :? ApiController as target -> 
                target.Request <- context.Resolve typeof<HttpRequestMessage> :?> HttpRequestMessage
            | _ -> raise <| ArgumentException( "The specimen must be an instance of ApiController.",  "specimen")
 
type ApiControllerCustomization() =
    interface ICustomization with
        member this.Customize fixture = 
            fixture.Customizations.Add(
                FilteringSpecimenBuilder(
                    Postprocessor(
                        MethodInvoker( ModestConstructorQuery()),
                        ApiControllerFiller()),
                    ApiControllerSpecification())) |> ignore

type TestConventions() =
    inherit CompositeCustomization(
        HttpRequestMessageCustomization(),
        ApiControllerCustomization(),
        AutoFoqCustomization())

type TestConventionsAttribute() =
    inherit AutoDataAttribute(Fixture().Customize(TestConventions()))