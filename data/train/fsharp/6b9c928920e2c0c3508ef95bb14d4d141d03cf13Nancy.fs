namespace EasySales.Common.Nancy
open Autofac
open Nancy
open Nancy.Bootstrapper
open Nancy.Authentication.Stateless
open System.Security.Claims
open EasySales.Common.Auth
open System
open System.Runtime.CompilerServices

[<Extension>]
type NancyExtensions =
    [<Extension>]
    static member SetupTokenAuthentication(pipelines: IPipelines, container: ILifetimeScope) = 
        let jwtTokenHandler = container.Resolve<IJwtTokenHandler>()
        let config = StatelessAuthenticationConfiguration(fun ctx -> 
                                                                let token = jwtTokenHandler.ParseFromHeader(ctx.Request.Headers.Authorization)
                                                                let authres = token |> Option.bind(fun tk -> jwtTokenHandler.Parse(tk))
                                                                match authres with 
                                                                | Some jwt -> EasySalesIdentity(jwt.Subject) :> ClaimsPrincipal
                                                                | None -> null
                                                            )
        StatelessAuthentication.Enable(pipelines, config)
