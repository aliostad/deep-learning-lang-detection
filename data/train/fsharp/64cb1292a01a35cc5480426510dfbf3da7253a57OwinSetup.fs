namespace TodoMvcBackend

module OwinSetup = 
    open Newtonsoft.Json.Serialization
    open Owin
    open System.Web.Http
    
    let useWebApi (app : IAppBuilder) = 
        let config = 
            let config = new HttpConfiguration()
            config.Formatters.Remove config.Formatters.XmlFormatter |> ignore
            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- DefaultContractResolver()
            config.Formatters.Insert(0, new JsonValueFormatter())
            config.MapHttpAttributeRoutes()
            config
        app.UseWebApi config
    
    let configure (app : IAppBuilder) = app |> useWebApi
