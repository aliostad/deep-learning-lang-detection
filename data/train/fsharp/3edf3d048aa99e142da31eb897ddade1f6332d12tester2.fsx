type ApplicationUser = IUser<string>
type ApplicationUserKey = string
type LoginViewModel = {Email:string; Password:string; RememberMe:bool}


module ControllerHelpers = 

    /// given a login info and a signInManager, return the login info on success or None otherwise
    let signInChecker (model : LoginViewModel) (signInManager:SignInManager<ApplicationUser,ApplicationUserKey>) =
         async {
            let! result = Async.AwaitTask(signInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, false))
            match result with
            | SignInStatus.Success -> return (Some model)
            | _ ->  return None
            }

    /// given an optional login, create a message and call the appropriate continuation
    let convertLoginResultToHttpResult okHandler errorHandler login :IHttpActionResult =   
        match login with
        | Some credentials -> 
            let message = sprintf "signed in as %s" credentials.Email
            okHandler message 
        | None -> 
            let message = sprintf "failed to sign in"
            errorHandler message 

        

type AuthenticationController() =
    inherit ApiController()


    let signInManager = new SignInManager<ApplicationUser,ApplicationUserKey>(null,null)
    member this.SignInManager = signInManager 

    /// Make an IHttpActionResult
    member this.MakeIHttpActionResult statusCode msg = 
        this.Content(statusCode,msg) :> IHttpActionResult 

    [<HttpPost>]
    [<AllowAnonymous>]
    [<Route("Login")>]
    member this.Login (model : LoginViewModel) : Task<IHttpActionResult> =

        // helper methods
        let okHandler msg = this.MakeIHttpActionResult HttpStatusCode.OK msg
        let errorHandler msg = this.MakeIHttpActionResult HttpStatusCode.Forbidden msg

        async {
            let! signIn = ControllerHelpers.signInChecker model this.SignInManager
            let httpResult =
                signIn 
                |> ControllerHelpers.convertLoginResultToHttpResult okHandler errorHandler
            return httpResult 
            } |> Async.StartAsTask

