namespace FRest.Server

open System
open System.Web.Http
open System.Web.Http.SelfHost

open FRest.Contracts

module SelfHosting = 

    [<CLIMutable>]
    type Route = { controller : string; action : string }

    let setupHandlerInjection (handler : Handler.T) (config : #HttpConfiguration) =
        let resolve (oldResolver : Dependencies.IDependencyResolver) handler (t : System.Type) : obj =
            try
            if t = typeof<MyApiController> then
                new MyApiController (handler) :> _
            else
                oldResolver.GetService t
            with
            | _ as err -> 
                failwith err.Message
        let scope oldResolver =
            { new Dependencies.IDependencyScope with
                member __.GetService (serviceType : System.Type) =
                    resolve oldResolver handler serviceType
                member i.GetServices (serviceType : System.Type) =
                    Seq.singleton <| i.GetService(serviceType)
                member __.Dispose() = ()
            }
        let resolver oldResolver =
            { new Dependencies.IDependencyResolver with
                member __.BeginScope() = scope oldResolver
                member __.GetService (serviceType : System.Type) =
                    resolve oldResolver handler serviceType
                member i.GetServices (serviceType : System.Type) =
                    Seq.singleton <| i.GetService(serviceType)
                member __.Dispose() = ()
            }
        config.DependencyResolver <- resolver config.DependencyResolver
        config

    let configureFormatters (config : #HttpConfiguration) =
        config.Formatters
                .XmlFormatter
                .UseXmlSerializer <- true
        config.Formatters
                .JsonFormatter
                .SerializerSettings
                .ContractResolver
                    <- Newtonsoft
                        .Json
                        .Serialization
                        .CamelCasePropertyNamesContractResolver()
        config

    let setupRoutes (config : #HttpConfiguration) =
        config.Routes.MapHttpRoute (
            "default",
            "{action}",
            { controller = "MyApi"; action = "Echo" } )
        |> ignore
        config


    let hostService (handler : Handler.T) (url : string) = 
        let config = 
            new HttpSelfHostConfiguration(url)
            |> configureFormatters
            |> setupHandlerInjection handler
            |> setupRoutes

        let server = new HttpSelfHostServer(config)
        server.OpenAsync().Wait()

        { new IDisposable with
            member __.Dispose() = 
                server.CloseAsync().Wait()
                server.Dispose()
                config.Dispose()
        }

    let hostServiceAt (handler : Handler.T) url =
        hostService handler url

    let hostLocalService (handler : Handler.T) (port : int) =
        sprintf "http://localhost:%d" port
        |> hostServiceAt handler
