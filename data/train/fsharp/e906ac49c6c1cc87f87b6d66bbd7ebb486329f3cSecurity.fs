#light

namespace NoRecruiters.Controllers

    open Bistro.FS.Controller
    open Bistro.FS.Definitions
    open Bistro.FS.Inference
    
    open Bistro.Controllers
    open Bistro.Controllers.Descriptor
    open Bistro.Controllers.Descriptor.Data
    open Bistro.Controllers.Security
    open Bistro.Http
    
    open System.Text.RegularExpressions
    open System.Web
    open System.Security.Principal
    
    open NoRecruiters.Enums
    open NoRecruiters.Enums.Content
    open NoRecruiters.Enums.User
    open NoRecruiters.Enums.Common
    
    open NoRecruiters.Data
    open NoRecruiters.Util

    module Security =

        type UserProfile() = 
            let mutable (data: Entities.user option) = None
            
            new (userData: Entities.user) as this = 
                UserProfile()
                then 
                    this.Data <- Some userData

            member x.Data with get() = data and set(d) = data <- d
            interface IIdentity with
                member x.AuthenticationType with get() = "FORMS"
                member x.IsAuthenticated with get() = data.IsSome
                member x.Name with get() = 
                                    match data with
                                    | Some d -> d.userName
                                    | None -> System.String.Empty

            interface IPrincipal with
                member x.Identity with get() = x :> IIdentity
                member x.IsInRole role =
                    match data with 
                    | Some d -> (List.tryFind ((=) role) d.roles).IsSome
                    | None -> false
                    
        [<Bind("get /posting/manage")>]
        [<Bind("get /posting/ad/applicants/byId/{adId}")>]
        [<Deny("*", OnFailure = FailAction.Redirect, Target = "/auth/signin")>]
        [<Allow("company"); SecurityController; ReflectedDefinition>]
        let companyFunctionAccessC (ctx: ictx) = ()

        [<Bind("/posting")>]
        [<Deny("?", OnFailure = FailAction.Redirect, Target = "/auth/signin"); SecurityController; ReflectedDefinition>]
        let generalFunctionAccessC (ctx: ictx) =  
            (if (ctx.CurrentUser.Identity.IsAuthenticated) then (ctx.CurrentUser :?> UserProfile).Data
             else None) |> named "currentUser"

        [<Bind("get ?/byname/{shortName}")>]
        [<Bind("?/byId/{postingId}"); ReflectedDefinition>]
        let dataAccessC shortName postingId (currentUser: Entities.user option) =
            match 
               (match currentUser with
                | None -> None
                | Some user ->
                    match normalize shortName, normalize postingId with
                    | "profile",_ -> 
                        match Postings.byId user.postingId with
                        | Some posting -> Some posting
                        | None -> Some <| Postings.empty()
                    | "new",_ | "", "" -> Some <| Postings.empty()
                    | "", _ -> Postings.byId postingId
                    | _ -> match Postings.byShortName shortName with | h::[] -> Some h | _ -> None) with
            | Some posting when not (posting.userId = currentUser.Value.id) ->
                raise (WebException(StatusCode.Forbidden, "unauthorized access"))
            | Some posting -> posting
            | None -> raise (WebException(StatusCode.NotFound, "posting not found"))
