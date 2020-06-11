module RAMLSharpTest.URIParameters

open System
open System.Web
open System.Collections.Generic
open RAMLSharp
open RAMLSharp.Models
open System.Web.Http.Description
open System.Web.Http.Routing
open System.Diagnostics.CodeAnalysis
open System.Web.Http.Controllers
open Fakes
open Moq

open NUnit.Framework

[<ExcludeFromCodeCoverage>]
let init() = 
    let routes = new List<RouteModel>()
    routes.Add(new RouteModel("api/test", "get", null, null, null, null, null, null, null))

    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", "application/json", "test", routes)
    let descriptions = new List<ApiDescription>()
    let sampleApiParameterDescription = new ApiParameterDescription()
    sampleApiParameterDescription.Name <- "Value1"
    sampleApiParameterDescription.Source <- ApiParameterSource.FromUri
    sampleApiParameterDescription.Documentation <- ""
    let mockHttpParameterDescriptor = new Mock<HttpParameterDescriptor>()
    let mockRoute = new Mock<IHttpRoute>()
    (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute)

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, Complex Objects returns all public properties`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    sampleDescription.ParameterDescriptions.Add(sampleApiParameterDescription)

    mockHttpParameterDescriptor.Setup(fun p -> p.IsOptional).Returns(true) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.DefaultValue).Returns(null) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.ParameterType).Returns(typeof<FakeComplex>) |> ignore

    sampleApiParameterDescription.ParameterDescriptor <- mockHttpParameterDescriptor.Object

    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");

    Assert.IsTrue(result.ToString().Contains("      Field1:"));
    Assert.IsTrue(result.ToString().Contains("      Field2:"));
    Assert.IsTrue(result.ToString().Contains("      Field3:"));
    Assert.IsTrue(result.ToString().Contains("        type: integer"));
    Assert.IsTrue(result.ToString().Contains("        type: string"));
    Assert.IsTrue(result.ToString().Contains("        type: date"));

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, Primitive returns itself`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    sampleDescription.ParameterDescriptions.Add(sampleApiParameterDescription)

    mockHttpParameterDescriptor.Setup(fun p -> p.IsOptional).Returns(true) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.DefaultValue).Returns(null) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.ParameterType).Returns(typeof<string>) |> ignore

    sampleApiParameterDescription.ParameterDescriptor <- mockHttpParameterDescriptor.Object

    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");

    Assert.IsTrue(result.ToString().Contains("      Value1:"));
    Assert.IsTrue(result.ToString().Contains("        type: string"));

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, Inherited Properties returns all public properties`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    sampleDescription.ParameterDescriptions.Add(sampleApiParameterDescription)

    mockHttpParameterDescriptor.Setup(fun p -> p.IsOptional).Returns(true) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.DefaultValue).Returns(null) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.ParameterType).Returns(typeof<FakeInheritedComplex>) |> ignore

    sampleApiParameterDescription.ParameterDescriptor <- mockHttpParameterDescriptor.Object

    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");

    Assert.IsTrue(result.ToString().Contains("      Field1:"));
    Assert.IsTrue(result.ToString().Contains("      Field2:"));
    Assert.IsTrue(result.ToString().Contains("      Field3:"));
    Assert.IsTrue(result.ToString().Contains("      Field4:"));
    Assert.IsTrue(result.ToString().Contains("        type: integer"));
    Assert.IsTrue(result.ToString().Contains("        type: string"));
    Assert.IsTrue(result.ToString().Contains("        type: date"));

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, Nested Object returns first level properties`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    sampleDescription.ParameterDescriptions.Add(sampleApiParameterDescription)

    mockHttpParameterDescriptor.Setup(fun p -> p.IsOptional).Returns(true) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.DefaultValue).Returns(null) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.ParameterType).Returns(typeof<FakeNestedComplex>) |> ignore

    sampleApiParameterDescription.ParameterDescriptor <- mockHttpParameterDescriptor.Object

    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");

    Assert.IsTrue(result.ToString().Contains("      Field5:"));
    Assert.IsTrue(not(result.ToString().Contains("      Field1:")))
    Assert.IsTrue(not(result.ToString().Contains("      Field2:")))
    Assert.IsTrue(not(result.ToString().Contains("      Field3:")))
    Assert.IsTrue(not(result.ToString().Contains("        type: integer")))
    Assert.IsTrue(result.ToString().Contains("        type: string"))
    Assert.IsTrue(not(result.ToString().Contains("        type: date")))

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, if null ParameterDescriptor then skips`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    
    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    
    Assert.IsFalse(String.IsNullOrEmpty(result.ToString()))

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``For UriParameters, if null parameter then skips`` () =
    let (expectedModel, descriptions, sampleApiParameterDescription, mockHttpParameterDescriptor, mockRoute) = init()

    let sampleDescription = new ApiDescription()
    sampleDescription.HttpMethod <- new System.Net.Http.HttpMethod("get")
    mockRoute.Setup(fun p -> p.RouteTemplate).Returns("api/test") |> ignore
    sampleDescription.Route <- mockRoute.Object
    sampleDescription.ParameterDescriptions.Add(sampleApiParameterDescription)

    mockHttpParameterDescriptor.Setup(fun p -> p.IsOptional).Returns(true) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.DefaultValue).Returns(null) |> ignore
    mockHttpParameterDescriptor.Setup(fun p -> p.ParameterType).Returns<Type>(null) |> ignore

    sampleApiParameterDescription.ParameterDescriptor <- mockHttpParameterDescriptor.Object

    descriptions = new List<ApiDescription>() |> ignore
    descriptions.Add(sampleDescription)

    let subject = new RAMLMapper(descriptions);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    
    Assert.IsFalse(String.IsNullOrEmpty(result.ToString()))