namespace NotificationAPI

module Startup =

    open Owin
    open Microsoft.Owin
    open Microsoft.Owin.StaticFiles
    open Microsoft.Owin.FileSystems
    open System
    open System.Web.Http


    let useWebApi (config : HttpConfiguration) (app : IAppBuilder) = 
        app.UseWebApi(config)

    let useFileServer (opts : FileServerOptions) (app : IAppBuilder) = 
        app.UseFileServer(opts)

    let useStaticFiles (path: string) (app : IAppBuilder) = 
        app.UseStaticFiles(path)

    let configureApp (app : IAppBuilder) = 
        
        // web api config
        let config = new HttpConfiguration()
        config.MapHttpAttributeRoutes() // need this for the route attribute annotations to work
        let route = config.Routes.MapHttpRoute("DefaultApi", "api/{controller}/{id}")
        route.Defaults.Add("id", RouteParameter.Optional)
        
        // pick a serializer that isn't stupid
        config.Formatters.JsonFormatter.SerializerSettings.ContractResolver <- 
            Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver()
        
        // re-map '/' to where we want
        let opts = new FileServerOptions()
        opts.RequestPath <- PathString.Empty
        //opts.FileSystem <- new PhysicalFileSystem(".\site")
        // Need to deal with linux, and its different directory seperator
        let sitePath = sprintf ".%csite" System.IO.Path.DirectorySeparatorChar
        opts.FileSystem <- new PhysicalFileSystem(sitePath)

            
        // set up app
        app
        |> useWebApi config
        |> useFileServer opts
        |> ignore
        

    type public Startup() = 
        member x.Configuration (app : IAppBuilder) = 
            // just configuring : we can add auth into the pipeline if needed
            configureApp(app) |> ignore

    
