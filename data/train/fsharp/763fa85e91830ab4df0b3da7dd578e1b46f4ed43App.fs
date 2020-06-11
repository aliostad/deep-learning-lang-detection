module GlobalPollenProject.Web.App

open System
open System.IO
open System.Text
open System.Security.Claims
open System.Collections.Generic
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Identity
open Microsoft.AspNetCore.Identity.EntityFrameworkCore
open Microsoft.AspNetCore.WebUtilities
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection

open Giraffe.Tasks
open Giraffe.HttpContextExtensions
open Giraffe.HttpHandlers
open Giraffe.Middleware
open Giraffe.Razor.HttpHandlers
open Giraffe.Razor.Middleware

open GlobalPollenProject.Core.Composition
open GlobalPollenProject.Shared.Identity
open GlobalPollenProject.Shared.Identity.Models
open GlobalPollenProject.Shared.Identity.Services
open GlobalPollenProject.App.UseCases
open ReadModels

open Handlers
open ModelValidation
open Account

/////////////////////////
/// Helpers
/////////////////////////

let accessDenied = setStatusCode 401 >=> razorHtmlView "AccessDenied" None
let mustBeLoggedIn : HttpHandler = requiresAuthentication (redirectTo false "/Account/Login")
let mustBeAdmin ctx = requiresRole "Admin" accessDenied ctx

let currentUserId (ctx:HttpContext) () =
    async {
        let manager = ctx.GetService<UserManager<ApplicationUser>>()
        let! user = manager.GetUserAsync(ctx.User) |> Async.AwaitTask
        return Guid.Parse user.Id
    } |> Async.RunSynchronously

let notFoundResult ctx =
    ctx |> (clearResponse >=> setStatusCode 400 >=> renderView "NotFound" None)

let prettyJson = Serialisation.serialise

let queryRequestToApiResponse<'a,'b> (appService:'a->Result<'b,ServiceError>) : HttpHandler =
    fun next ctx ->
        ctx
        |> bindQueryString<'a>
        |> bind validateModel
        |> bind appService
        |> toApiResult next ctx

////////////////////////
/// Routing lookups
////////////////////////

open System.IO

type TaxonLookup = { 
    OriginalId: int
    Rank: string
    Family: string
    Genus: string
    Species: string 
} with
    static member FromFile file = 
        file
        |> File.ReadAllLines
        |> Seq.skip 1
        |> Seq.map (fun s-> s.Split ',')
        |> Seq.map (fun a -> {OriginalId=int a.[0]; Rank=a.[1]; Family = a.[2]; Genus = a.[3]; Species = a.[4]})

let taxonLookup = TaxonLookup.FromFile @"Lookups/taxonlookup.csv"

let lookupNameFromOldTaxonId id =
    let old = taxonLookup |> Seq.tryFind(fun t -> t.OriginalId = id)
    match old with
    | Some t ->
        match t.Rank with
        | "Family" -> redirectTo true (sprintf "/Taxon/%s" t.Family)
        | "Genus" -> redirectTo true (sprintf "/Taxon/%s/%s" t.Family t.Genus)
        | "Species" -> redirectTo true (sprintf "/Taxon/%s/%s/%s" t.Family t.Genus t.Species)
        | _ -> notFoundResult
    | None -> notFoundResult

/////////////////////////
/// Custom HTTP Handlers
/////////////////////////

let slideViewHandler (id:string) : HttpHandler =
    fun next ctx ->
        let split = id.Split '/'
        match split.Length with
        | 2 -> 
            let col,slide = split.[0], split.[1] |> System.Net.WebUtility.UrlDecode
            Taxonomy.getSlide col slide
            |> toViewResult "MRC/Slide" next ctx
        | _ -> notFoundResult next ctx

let taxonDetail (taxon:string) next ctx =
    let (f,g,s) =
        let split = taxon.Split '/'
        match split.Length with
        | 1 -> split.[0],None,None
        | 2 -> split.[0],Some split.[1],None
        | 3 -> split.[0],Some split.[1],Some split.[2]
        | _ -> "",None,None
    Taxonomy.getByName f g s
    |> toViewResult "MRC/Taxon" next ctx

let taxonDetailById id next ctx =
    match System.Guid.TryParse id with
    | (true,g) ->
        g
        |> Taxonomy.getById
        |> toViewResult "MRC/Taxon" next ctx
    | (false,g) -> notFoundResult next ctx

let individualCollectionIndex next ctx =
    IndividualReference.list {Page = 1; PageSize = 20}
    |> toViewResult "Reference/Index" next ctx

let individualCollection (colId:string) version next ctx =
    IndividualReference.getDetail colId version
    |> toViewResult "Reference/View" next ctx

let individualCollectionLatest (colId:string) next ctx =
    let latestVer = IndividualReference.getLatestVersion colId
    match latestVer with
    | Ok v -> redirectTo false (sprintf "/Reference/%s/%i" colId v) next ctx
    | Error _ -> notFoundResult next ctx

let defaultIfNull (req:TaxonPageRequest) =
    match String.IsNullOrEmpty req.Rank with
    | true -> { Page = 1; PageSize = 50; Rank = "Genus"; Lex = "" }
    | false ->
        if req.PageSize = 0 then { req with PageSize = 50}
        else req

let pagedTaxonomyHandler next (ctx:HttpContext) =
    ctx.BindQueryString<TaxonPageRequest>()
    |> defaultIfNull
    |> Taxonomy.list
    |> toViewResult "MRC/Index" next ctx

let listCollectionsHandler next ctx =
    Digitise.myCollections (currentUserId ctx)
    |> toApiResult next ctx

let startCollectionHandler next (ctx:HttpContext) =
    bindJson<StartCollectionRequest> ctx
    |> bind validateModel
    |> Result.bind (Digitise.startNewCollection (currentUserId ctx))
    |> toApiResult next ctx

let publishCollectionHandler next (ctx:HttpContext) =
    let id = ctx.BindQueryString<IdQuery>().Id
    Digitise.publish (currentUserId ctx) id
    text "Ok" next ctx

let addSlideHandler next (ctx:HttpContext) =
    bindJson<SlideRecordRequest> ctx
    |> bind validateModel
    |> bind Digitise.addSlideRecord
    |> toApiResult next ctx

let voidSlideHandler next ctx =
    bindJson<VoidSlideRequest> ctx
    |> bind Digitise.voidSlide
    |> toApiResult next ctx

let addImageHandler next (ctx:HttpContext) =
    bindJson<SlideImageRequest> ctx
    |> Result.bind Digitise.uploadSlideImage
    |> toApiResult next ctx

let getCollectionHandler next (ctx:HttpContext) =
    ctx.BindQueryString<IdQuery>().Id.ToString()
    |> Digitise.getCollection
    |> toApiResult next ctx
    
let getCalibrationsHandler next (ctx:HttpContext) =
    Calibrations.getMyCalibrations (currentUserId ctx)
    |> toApiResult next ctx

let setupMicroscopeHandler next (ctx:HttpContext) =
    bindJson<AddMicroscopeRequest> ctx
    |> bind (Calibrations.setupMicroscope (currentUserId ctx))
    |> toApiResult next ctx

let calibrateHandler next (ctx:HttpContext) =
    bindJson<CalibrateRequest> ctx
    |> bind Calibrations.calibrateMagnification
    |> toApiResult next ctx

let listGrains next ctx =
    UnknownGrains.listUnknownGrains()
    |> toViewResult "Identify/Index" next ctx

let showGrainDetail id next ctx =
    UnknownGrains.getDetail id
    |> toViewResult "Identify/View" next ctx

let submitGrainHandler next (ctx:HttpContext) =
    bindJson<AddUnknownGrainRequest> ctx
    >>= UnknownGrains.submitUnknownGrain (currentUserId ctx)
    |> toApiResult next ctx

let submitIdentificationHandler next (ctx:HttpContext) =
    ctx.BindForm<IdentifyGrainRequest>()
    |> Async.AwaitTask
    |> Async.RunSynchronously
    |> UnknownGrains.identifyUnknownGrain (currentUserId ctx)
    |> toApiResult next ctx

let homeHandler next (ctx:HttpContext) =
    Statistic.getHomeStatistics()
    |> toViewResult "Home/Index" next ctx

let topUnknownGrainsHandler next (ctx:HttpContext) =
    UnknownGrains.getTopScoringUnknownGrains()
    |> toApiResult next ctx

let rebuildReadModelHandler next ctx =
    Admin.rebuildReadModel()
    text "Done" next ctx

let systemStatsHandler next ctx =
    Statistic.getSystemStats()
    |> toViewResult "Statistics/Index" next ctx

let userAdminHandler next ctx =
    Admin.listUsers()
    |> toViewResult "Admin/Users" next ctx

let curateIndexHandler next ctx =
    Curation.listPending()
    |> toViewResult "Admin/Curate" next ctx

let curateHandler next (ctx:HttpContext) =
    ctx.BindForm<CurateCollectionRequest>()
    |> Async.AwaitTask
    |> Async.RunSynchronously
    |> validateModel
    |> Result.bind (Curation.issueDecision (currentUserId ctx))
    |> ignore
    redirectTo true "/Admin/Curate" next ctx 


/////////////////////////
/// Routes
/////////////////////////

let webApp : HttpHandler =
    let publicApi =
        GET >=>
        choose [
            // route   "/backbone/match"           >=> queryRequestToApiResponse<BackboneSearchRequest,BackboneTaxon list> Backbone.tryMatch
            route   "/backbone/trace"           >=> queryRequestToApiResponse<BackboneSearchRequest,BackboneTaxon list> Backbone.tryTrace
            route   "/backbone/search"          >=> queryRequestToApiResponse<BackboneSearchRequest,string list> Backbone.searchNames
            route   "/taxon/search"             >=> queryRequestToApiResponse<TaxonAutocompleteRequest,TaxonAutocompleteItem list> Taxonomy.autocomplete
            route   "/grain/location"           >=> topUnknownGrainsHandler
        ]

    let digitiseApi =
        mustBeLoggedIn >=>
        choose [
            route   "/collection"               >=> getCollectionHandler
            route   "/collection/list"          >=> listCollectionsHandler
            route   "/collection/start"         >=> startCollectionHandler
            route   "/collection/publish"       >=> publishCollectionHandler
            route   "/collection/slide/add"     >=> addSlideHandler
            route   "/collection/slide/void"    >=> voidSlideHandler
            route   "/collection/slide/addimage">=> addImageHandler
            route   "/calibration/list"         >=> getCalibrationsHandler
            route   "/calibration/use"          >=> setupMicroscopeHandler
            route   "/calibration/use/mag"      >=> calibrateHandler
        ]

    let accountManagement =
        choose [
            POST >=> route  "/Login"                        >=> loginHandler "/"
            POST >=> route  "/ExternalLogin"                >=> externalLoginHandler
            POST >=> route  "/Register"                     >=> registerHandler
            POST >=> route  "/Logout"                       >=> mustBeLoggedIn >=> logoutHandler
            POST >=> route  "/ForgotPassword"               >=> mustBeLoggedIn >=> forgotPasswordHandler
            POST >=> route  "/ResetPassword"                >=> mustBeLoggedIn >=> resetPasswordHandler

            GET  >=> route  "/Login"                        >=> renderView "Account/Login" None
            GET  >=> route  "/Register"                     >=> renderView "Account/Register" None
            GET  >=> route  "/ResetPassword"                >=> resetPasswordView
            GET  >=> route  "/ResetPasswordConfirmation"    >=> renderView "Account/ResetPasswordConfirmation" None
            GET  >=> route  "/ForgotPassword"               >=> renderView "Account/ForgotPassword" None
            GET  >=> route  "/ConfirmEmail"                 >=> confirmEmailHandler
            // GET  >=> route  "/ExternalLoginCallback"        >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/ExternalLoginConfirmation"    >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/LinkLogin"                    >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/LinkLoginCallback"            >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/ManageLogins"                 >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/SetPassword"                  >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/ChangePassword"               >=> (fun x -> invalidOp "Not implemented")
            // GET  >=> route  "/RemoveLogin"                  >=> (fun x -> invalidOp "Not implemented")
        ]

    let masterReferenceCollection =
        GET >=> 
        choose [   
            route   ""                          >=> pagedTaxonomyHandler
            routef  "/View/%i"                  lookupNameFromOldTaxonId
            routef  "/Slide/%s"                 slideViewHandler
            routef  "/ID/%s"                    taxonDetailById
            routef  "/%s"                       taxonDetail
        ]

    let individualRefCollections =
        GET >=>
        choose [
            route   ""                          >=> individualCollectionIndex
            routef  "/%s/Latest/%s"             slideViewHandler
            routef  "/%s/Latest"                individualCollectionLatest
            routef  "/%s/%i/%s"                 slideViewHandler
            routef  "/%s/%i"                    (fun (id,v) -> individualCollection id v)
        ]

    let identify =
        choose [
            POST >=> route  "/Upload"           >=> submitGrainHandler
            POST >=> route  "/Identify"         >=> submitIdentificationHandler
            GET  >=> route  ""                  >=> listGrains
            GET  >=> route  "/Upload"           >=> mustBeLoggedIn >=> renderView "Identify/Add" None
            GET  >=> routef "/%s"               showGrainDetail
        ]

    let admin =
        choose [
            GET  >=> route "/Curate"            >=> curateIndexHandler
            POST >=> route "/Curate"            >=> curateHandler
            GET  >=> route "/Users"             >=> mustBeAdmin >=> userAdminHandler
            POST >=> routef "/GrantCuration/%s" grantCurationHandler
            GET  >=> route "/RebuildReadModel"  >=> mustBeAdmin >=> rebuildReadModelHandler
        ]

    // Main router
    choose [
        subRoute    "/api/v1"                   publicApi
        subRoute    "/api/v1/digitise"          digitiseApi
        subRoute    "/Account"                  accountManagement
        subRoute    "/Taxon"                    masterReferenceCollection
        subRoute    "/Reference"                individualRefCollections
        subRoute    "/Identify"                 identify
        subRoute    "/Admin"                    admin
        GET >=> 
        choose [
            route   "/"                         >=> homeHandler
            route   "/Guide"                    >=> renderView "Home/Guide" None
            route   "/Statistics"               >=> systemStatsHandler
            route   "/Digitise"                 >=> mustBeLoggedIn >=> renderView "Digitise/Index" None
            route   "/Api"                      >=> renderView "Home/Api" None
            route   "/Tools"                    >=> renderView "Tools/Index" None
        ]
        setStatusCode 404 >=> renderView "NotFound" None 
    ]
