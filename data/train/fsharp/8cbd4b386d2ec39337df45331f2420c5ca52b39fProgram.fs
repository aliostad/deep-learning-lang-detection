open System
open System.IO
open System.Security.Claims
open System.Collections.Generic
open System.Threading
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Http.Features
open Microsoft.AspNetCore.Authentication
open Microsoft.AspNetCore.Authentication.Cookies
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection
open Giraffe.Tasks
open Giraffe.HttpContextExtensions
open Giraffe.HttpHandlers
open Giraffe.Middleware
open Dapper
// open Giraffe.Razor.HttpHandlers
// open Giraffe.Razor.Middleware
// open SampleApp.Models
// open SampleApp.HtmlViews

open datab

type OptionHandler<'T>() =
    inherit SqlMapper.TypeHandler<option<'T>>()

    override __.SetValue(param, value) = 
        let valueOrNull = 
            match value with
            | Some x -> box x
            | None -> null

        param.Value <- valueOrNull    

    override __.Parse value =
        if isNull value || value = box DBNull.Value 
        then None
        else Some (value :?> 'T)

// ---------------------------------
// Error handler
// ---------------------------------

let errorHandler (ex : Exception) (logger : ILogger) =
    logger.LogError(EventId(), ex, "An unhandled exception has occurred while executing the request.")
    clearResponse >=> setStatusCode 500 >=> text ex.Message

// ---------------------------------
// Web app
// ---------------------------------

let authScheme = CookieAuthenticationDefaults.AuthenticationScheme

let accessDenied = setStatusCode 401 >=> text "Access Denied"

let mustBeUser = requiresAuthentication accessDenied

let mustBeAdmin =
    requiresAuthentication accessDenied
    >=> requiresRole "Admin" accessDenied

let loginHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            let issuer = "http://localhost:5000"
            let claims =
                [
                    Claim(ClaimTypes.Name,      "John",  ClaimValueTypes.String, issuer)
                    Claim(ClaimTypes.Surname,   "Doe",   ClaimValueTypes.String, issuer)
                    Claim(ClaimTypes.Role,      "Admin", ClaimValueTypes.String, issuer)
                ]
            let identity = ClaimsIdentity(claims, authScheme)
            let user     = ClaimsPrincipal(identity)

            do! ctx.SignInAsync(authScheme, user)

            return! text "Successfully logged in" next ctx
        }

let userHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        text ctx.User.Identity.Name next ctx

let newTokenHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        let token = datab.JwtGenerator.getToken "Admin" "Admin"
        text token next ctx

let calcHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            // let! user = datab.RepoUser.getUser connection "mxManager"
            // return! json user next ctx
            let repo = datab.RepoUser.getUser
            use connection = datab.RepoBase.getConnection()
            do! connection.OpenAsync ()
            use (tx: Npgsql.NpgsqlTransaction) = connection.BeginTransaction ()
            let! user = datab.UserService.getUser repo connection "mxManager"
            tx.Commit ()
            return! json user next ctx
        }

let showUserHandler id =
    mustBeAdmin >=>
    text (sprintf "User ID: %i" id)

let time() = System.DateTime.Now.ToString()

[<CLIMutable>]
type Car =
    {
        Name   : string
        Make   : string
        Wheels : int
        Built  : DateTime
    }

let submitCar =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            let! car = ctx.BindModel<Car>()
            return! json car next ctx
        }

let smallFileUploadHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            return!
                (match ctx.Request.HasFormContentType with
                | false -> setStatusCode 400 >=> text "Bad request"
                | true  ->
                    ctx.Request.Form.Files
                    |> Seq.fold (fun acc file -> sprintf "%s\n%s" acc file.FileName) ""
                    |> text) next ctx
        }

let largeFileUploadHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            let formFeature = ctx.Features.Get<IFormFeature>()
            let! form = formFeature.ReadFormAsync CancellationToken.None
            return!
                (form.Files
                |> Seq.fold (fun acc file -> sprintf "%s\n%s" acc file.FileName) ""
                |> text) next ctx
        }

let webApp =
    choose [
        GET >=>
            choose [
                route  "/"           >=> text "index"
                route  "/ping"       >=> text "pong"
                route  "/error"      >=> (fun _ _ -> failwith "Something went wrong!")
                route  "/login"      >=> loginHandler
                route  "/logout"     >=> signOff authScheme >=> text "Successfully logged out."
                route  "/user"       >=> mustBeUser >=> userHandler
                route  "/calc"       >=> calcHandler
                route  "/token"      >=> newTokenHandler
                // routef "/user/%i"    showUserHandler
                // route  "/razor"      >=> razorHtmlView "Person" { Name = "Razor" }
                // route  "/razorHello" >=> razorHtmlView "Hello" ""
                // route  "/fileupload" >=> razorHtmlView "FileUpload" ""
                // route  "/person"     >=> (personView { Name = "Html Node" } |> renderHtml)
                // route  "/once"       >=> (time() |> text)
                // route  "/everytime"  >=> warbler (fun _ -> (time() |> text))
            ]
        POST >=>
            choose [
                route "/small-upload" >=> smallFileUploadHandler
                route "/large-upload" >=> largeFileUploadHandler ]
        route "/car" >=> submitCar
        setStatusCode 404 >=> text "Not Found" ]

// ---------------------------------
// Main
// ---------------------------------

let cookieAuth (o : CookieAuthenticationOptions) =
    do
        o.Cookie.HttpOnly     <- true
        o.Cookie.SecurePolicy <- CookieSecurePolicy.SameAsRequest
        o.SlidingExpiration   <- true
        o.ExpireTimeSpan      <- TimeSpan.FromDays 7.0

let configureApp (app : IApplicationBuilder) =
    app.UseGiraffeErrorHandler errorHandler
    app.UseStaticFiles() |> ignore
    app.UseAuthentication() |> ignore
    app.UseGiraffe webApp

let configureServices (services : IServiceCollection) =
    let sp  = services.BuildServiceProvider()
    let env = sp.GetService<IHostingEnvironment>()
    let viewsFolderPath = Path.Combine(env.ContentRootPath, "Views")

    services
        .AddAuthentication(authScheme)
        .AddCookie(cookieAuth)
    |> ignore

    services.AddDataProtection()            |> ignore
//    services.AddRazorEngine viewsFolderPath |> ignore

let configureLogging (loggerBuilder : ILoggingBuilder) =
    loggerBuilder.AddFilter(fun lvl -> lvl.Equals LogLevel.Error)
                 .AddConsole()
                 .AddDebug() |> ignore

[<EntryPoint>]
let main argv =

    do datab.RepoAdoBase.getData


    // SqlMapper.AddTypeHandler (OptionHandler<string>())
    // SqlMapper.AddTypeHandler (OptionHandler<int>())

    // let contentRoot = Directory.GetCurrentDirectory()
    // let webRoot     = Path.Combine(contentRoot, "WebRoot")
    // WebHostBuilder()
    //     .UseKestrel()
    //     .UseContentRoot(contentRoot)
    //     .UseWebRoot(webRoot)
    //     .Configure(Action<IApplicationBuilder> configureApp)
    //     .ConfigureServices(configureServices)
    //     .ConfigureLogging(configureLogging)
    //     .Build()
    //     .Run()
    0

// open System
// open datab

// [<EntryPoint>]
// let main argv =
//     let userList = UserService.getUser RepoUser.getUser "mxManager" |> Async.RunSynchronously
//     userList |> printfn "%A"

//     let testUser : Models.User = {
//         Id = 3;
//         Username = "xxx";
//         Password = "tttt";
//         Active = true;
//         Role = "r";
//         UserFacilityIdLista = Some "lll"
//     }

//     UserService.getUser (fun x -> async { return Seq.ofList [testUser]}) "mxManager" 
//     |> Async.RunSynchronously
//     |> printfn "%A"

//     0
