

namespace Functions
open System
open Owin
open System.Web.Http
open Autofac
open Autofac.Integration.WebApi
open WeaponRepository


type public Startup() = 
    member this.Configuration (appBuilder : IAppBuilder) = 
        let builder = new ContainerBuilder()
        
        // Configure Web API for self-host. 
        let config = new HttpConfiguration()
        config.MapHttpAttributeRoutes()

        builder.RegisterType<WeaponsController>().WithParameter("getSingleWeapon", WeaponRepository.getWeapon).InstancePerRequest() |> ignore

        let container = builder.Build()
        config.DependencyResolver <- new AutofacWebApiDependencyResolver(container) :> Dependencies.IDependencyResolver
        appBuilder.UseWebApi(config) |> ignore

