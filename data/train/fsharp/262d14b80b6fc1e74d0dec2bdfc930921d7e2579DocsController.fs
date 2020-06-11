namespace Controllers

open Newtonsoft.Json.Linq
open System.IO
open System.Net
open System.Net.Http
open System.Web.Http
open Serilog

type DocsController() =
    inherit ApiController()

    member x.Get() =
        Log.Information("Received GET request for API documentation")
        use stream = x.GetType().Assembly.GetManifestResourceStream("api.json")
        use streamReader = new StreamReader(stream)
        let content = streamReader.ReadToEnd()
        let docs = JObject.Parse(content);        
        x.Request.CreateResponse(HttpStatusCode.OK, docs, "application/json")