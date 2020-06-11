namespace Nomad.Authentication

open Nomad
open HttpHandler
open System.Security.Claims

module HttpHandler =
    /// Creates an http handler that challenges the user to authenticate before allowing them access to the supplied http handler
    let requireAuth (authenticationScheme : string) handler =
        InternalHandlers.askContext
        |> bind (fun ctx -> 
            if not <| isNull ctx.User && ctx.User.Identity.IsAuthenticated then
                handler
            else
                liftAsync << Async.awaitPlainTask <| ctx.Authentication.ChallengeAsync(authenticationScheme))

    /// Creates an http handler that, given a method for validating some credentials and the credentials themselves, validates the supplied credentials and, if they are successfully validated, signs the user in.
    let signIn (authenticationScheme : string) claimsPrincipalCreator credentials =
        InternalHandlers.askContext
        |> bind (fun ctx ->
            match claimsPrincipalCreator credentials with
            |Ok principal -> 
                ctx.Authentication.SignInAsync(authenticationScheme, principal)
                |> Async.awaitPlainTask
                |> liftAsync
            |Error err ->
                ctx.Authentication.ChallengeAsync(authenticationScheme)
                |> Async.awaitPlainTask
                |> liftAsync)