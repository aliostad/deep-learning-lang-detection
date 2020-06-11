module RAMLSharpTest.GenerateAPIDocumentation

open System
open System.Web
open System.Collections.Generic
open RAMLSharp
open RAMLSharp.Models
open System.Web.Http.Description
open System.Web.Http.Routing
open System.Diagnostics.CodeAnalysis
open Moq

open NUnit.Framework

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper one API Description, it should generate a RAML with 1 API``() =
    let mockRoute = new Mock<IHttpRoute>()
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    let api = new ApiDescription()
    api.HttpMethod <- new System.Net.Http.HttpMethod("get")
    api.RelativePath <- "api/test"
    api.Route <- mockRoute.Object

    let routes = new List<RouteModel>()
    routes.Add(new RouteModel("api/test", "get", null, null, null, null, null, null, null))
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", "application/json", "test", routes)          
    let model = new List<ApiDescription>()
    model.Add(api)

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")