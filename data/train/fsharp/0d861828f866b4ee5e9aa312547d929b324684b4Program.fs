module VisitorTrack.Web.Program

open System
open System.IO
open System.Collections.Generic
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http
open Microsoft.Extensions.Logging
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.DependencyInjection
open Microsoft.AspNetCore.Authentication
open Microsoft.AspNetCore.Authentication.JwtBearer
open Microsoft.EntityFrameworkCore
open Giraffe.HttpHandlers
open Giraffe.Middleware
open VisitorTrack.Web.Dtos
open VisitorTrack.Web.DomainTypes
open VisitorTrack.Entities
open VisitorTrack.Web.Controllers
open System.Threading.Tasks
open Serilog
open Microsoft.IdentityModel.Tokens


let authorize = 
    requiresAuthentication (challenge JwtBearerDefaults.AuthenticationScheme)

let webApp =
    choose [
        GET >=>
            choose [
                route "/api/users" >=> authorize >=> UserController.getAll
                route "/api/checklisttypes" >=> CheckListTypeController.getAll
                route "/api/checklists" >=> CheckListController.getAll

                routef "/api/users/%i" UserController.findById
                routef "/api/checklisttypes/%i" CheckListTypeController.findById
                routef "/api/comments/%i" CommentController.findById
                routef "/api/checklists/%i" CheckListController.findById
                routef "/api/visitors/%i" VisitorController.findById
                routef "/api/visitors/%i/comments" CommentController.getByVisitorId
                routef "/api/visitors/%i/checklists" CheckListController.getByVisitorId
                routef "/api/visitors/search/%s" VisitorController.search
            ]
        DELETE >=>
            choose [
                routef "/api/users/%i" UserController.delete
                routef "/api/checklisttypes/%i" CheckListTypeController.delete
                routef "/api/comments/%i" CommentController.delete
                routef "/api/checklists/%i" CheckListController.delete
                routef "/api/visitors/%i" VisitorController.delete
            ]
        POST >=> 
            choose [
                route "/api/users" >=> UserController.insert
                route "/api/checklisttypes" >=> CheckListTypeController.insert
                route "/api/comments" >=> CommentController.insert
                route "/api/checklists" >=> CheckListController.insert
                route "/api/visitors" >=> VisitorController.insert
                route "/api/visitors/checklists" >=> CheckListController.insertCheckListItem
            ]
        PUT >=>
            choose [
                routef "/api/users/%i" UserController.update
                routef "/api/checklisttypes/%i" CheckListTypeController.update
                routef "/api/comments/%i" CommentController.update
                routef "/api/checklists/%i" CheckListController.update
                routef "/api/visitors/%i" VisitorController.update
            ]
        setStatusCode 404 >=> negotiate "Not Found" ]

let configuration =
        ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("settings.json", optional = false, reloadOnChange = true)
            .AddJsonFile("settings.release.json", optional = true)
            .AddEnvironmentVariables()
            .Build()

let errorHandler (ex : Exception) (logger : Microsoft.Extensions.Logging.ILogger) =
    logger.LogError(EventId(), ex, "An unhandled exception has occurred while executing the request.")
    clearResponse >=> setStatusCode 500 >=> negotiate ex.Message

let configureApp (app : IApplicationBuilder) =
    app.UseGiraffeErrorHandler errorHandler
    app.UseFileServer() |> ignore
    app.UseAuthentication() |> ignore
    app.UseGiraffe webApp

let configureServices (services : IServiceCollection) =
    let configureDb (options: DbContextOptionsBuilder) =
        options.UseSqlServer(configuration.GetConnectionString("Default")) |> ignore

    services
        .AddDbContext<VisitorTrackContext>(Action<DbContextOptionsBuilder> configureDb) |> ignore

    let appSettings = { SecretKey =  configuration.GetSection("AppSettings").["SecretKey"] }

    services.AddSingleton(appSettings) |> ignore

    let configureJwtBearer (options: JwtBearerOptions) =
        options.SaveToken                 <- true
        options.RequireHttpsMetadata      <- false
        options.IncludeErrorDetails       <- true
        options.Authority                 <- "http://localhost:5050/identity"
        options.Audience                  <- "visitor-track"
        options.ClaimsIssuer              <- "visitor-track"
        options.TokenValidationParameters <- TokenValidationParameters (
            ValidIssuer = "localhost.com"
        )

    let authenticationOptions (options : AuthenticationOptions) =
        options.DefaultAuthenticateScheme <- JwtBearerDefaults.AuthenticationScheme
        options.DefaultChallengeScheme    <- JwtBearerDefaults.AuthenticationScheme

    services
        .AddAuthentication(authenticationOptions)
        .AddJwtBearer(Action<JwtBearerOptions> configureJwtBearer) |> ignore

let configureLogging (builder : ILoggingBuilder) =
    let filter (logLevel : LogLevel) = 
        logLevel.Equals LogLevel.Debug

    builder
        .AddFilter(filter)
        .AddConsole()
        .AddDebug() |> ignore

[<EntryPoint>]
let main argv =
    let contentRoot = Directory.GetCurrentDirectory()
    let webRoot     = Path.Combine(contentRoot, "wwwroot")

    Log.Logger <- 
        LoggerConfiguration()
            .MinimumLevel
            .Debug()
            .WriteTo
            .RollingFile(contentRoot + "/bin/Logs/visitortrack-{Date}.txt")
            .CreateLogger()
    
    try
        try
            Log.Information("Configuring web host builder...");

            WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(contentRoot)
                .UseIISIntegration()
                .UseWebRoot(webRoot)
                .Configure(Action<IApplicationBuilder> configureApp)
                .ConfigureServices(configureServices)
                .ConfigureLogging(configureLogging)
                .UseSerilog()
                .Build()
                .Run()
            0
        with
            ex -> 
                Log.Fatal(ex, "Host terminated unexpectedly")
                1
    finally
        Log.CloseAndFlush()
    