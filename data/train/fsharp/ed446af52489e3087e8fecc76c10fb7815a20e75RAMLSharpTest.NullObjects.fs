module RAMLSharpTest.NullObjects

open System
open System.Web
open System.Collections.Generic
open RAMLSharp
open RAMLSharp.Models
open System.Web.Http.Description
open System.Web.Http.Routing
open System.Diagnostics.CodeAnalysis

open NUnit.Framework

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null API Description should create a Basic RAML string`` () =
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", "application/json", "test", new List<RouteModel>())
    let list:IEnumerable<ApiDescription> = null

    let subject = new RAMLMapper(list)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper an Empty Api Description should generate a basic RAML string`` () = 
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", "application/json", "test", null)
    let list:IEnumerable<ApiDescription> = null
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null URI should create basic RAML string`` () = 
    let expectedModel = new RAMLModel("test", null, "1", "application/json", "test", new List<RouteModel>())
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(expectedModel.BaseUri, "test", "1", "application/json", "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null title should create basic RAML string`` () = 
    let expectedModel = new RAMLModel(null, new Uri("http://www.test.com"), "1", "application/json", "test", new List<RouteModel>())
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), expectedModel.Title, "1", "application/json", "test")
    let r = result.ToString()

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")
    Assert.IsTrue(result.ToString().Contains("title:"))

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null description should create basic RAML string`` () =
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", "application/json", null, new List<RouteModel>())
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", expectedModel.Description)

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")
    Assert.IsFalse(result.ToString().Contains("content:"))

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null version should create basic RAML string`` () =
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), null, "application/json", "test", new List<RouteModel>())
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", expectedModel.Version, "application/json", "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")
    Assert.IsFalse(result.ToString().Contains("version:"))

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a null base media type should create basic RAML string`` () = 
    let expectedModel = new RAMLModel("test", new Uri("http://www.test.com"), "1", null, "test", new List<RouteModel>())
    let model = new List<ApiDescription>()

    let subject = new RAMLMapper(model)
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", expectedModel.DefaultMediaType, "test")

    Assert.AreEqual(expectedModel.ToString(), result.ToString(), "The RAML string must be the same.")
    Assert.IsFalse(result.ToString().Contains("mediaType:"))