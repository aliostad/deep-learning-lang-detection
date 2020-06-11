module RAMLSharpTest.ConstructorInformation

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
let ``Give RAMLMapper a version, it should create a basic RAML with Version``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("version:"));

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a default media type, it should create a basic RAML with mediaType``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("mediaType:"));
      
[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a description, it should create a basic RAML with description``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("content:"));       

[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a Title, it should create a basic RAML with Title``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("title:")); 
    
[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a base URI, it should create a basic RAML with base URI``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("baseUri:")); 
        
[<Test>]
[<ExcludeFromCodeCoverage>]
let ``Give RAMLMapper a protocol, it should create a basic RAML with protocol``() =    
    let model = new List<ApiDescription>()
    let subject = new RAMLMapper(model);
    let result = subject.WebApiToRamlModel(new Uri("http://www.test.com"), "test", "1", "application/json", "test");
    Assert.IsTrue(result.ToString().Contains("protocols: [HTTP]")); 