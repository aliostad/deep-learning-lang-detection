#light

namespace NoRecruiters.Controllers

    open Bistro.FS.Controller
    open Bistro.FS.Definitions
    open Bistro.FS.Inference
    
    open Bistro.Controllers
    open Bistro.Controllers.Descriptor
    open Bistro.Controllers.Descriptor.Data
    open Bistro.Http
    
    open System.Text.RegularExpressions
    open System.Web
    
    open NoRecruiters.Enums
    open NoRecruiters.Enums.Content
    open NoRecruiters.Enums.User
    open NoRecruiters.Enums.Common
    
    open NoRecruiters.Data
    open NoRecruiters.Util

    module View =
        [<Bind("get /postings/{contentType}?{firstTime}"); ReflectedDefinition>]
        let firstTimeSearchC contentType firstTime defaultContentType = 
            let newContentType = if firstTime then contentType else defaultContentType
            HttpContext.Current.Response.Cookies.Add(new HttpCookie("nrDefaultContentType", newContentType))
            newContentType |> named "defaultContentType"
        
        [<Bind("get /postings/{contentType}?{firstTime}&{txtQuery}")>]
        [<RenderWith("Views/Posting/search.django"); ReflectedDefinition>]
        let searchC txtQuery currentTags contentType =
            let popularTags = 
                match currentTags with
                | Some l ->
                    Tags.rankedTags 15 |>
                    List.filter (fun e -> not <| List.exists ((=) e) l) 
                | None -> Tags.rankedTags 15
            
            popularTags, 
            contentType,
            (Postings.search txtQuery currentTags (Content.fromString contentType)) |> named "searchResults"
            
        [<Bind("get /ad/{shortName}")>]
        [<Bind("get /resume/{shortName}")>]
        [<RenderWith("Views/Posting/view.django"); ReflectedDefinition>]
        let viewC (shortName: string) (contentType: string option) (defaultContentType: string) =
             (match Postings.byShortName shortName with
              | Some p -> Postings.save {p with views = p.views + 1}
              | None -> Postings.empty() )|> named "posting",
             defaultContentType |> named "contentType"
        
        [<Bind("get /resume/preview/byname/{shortName}")>]
        [<RenderWith("Views/Posting/Resume/preview.django"); ReflectedDefinition>]
        let previewC (context: ictx)(shortName: string) (posting: Entities.posting option) =
            if posting.IsNone then
                context.Transfer("/posting/resume/byname/")
        
        
        [<Bind("get /posting/flag/{flagType}/{shortName}")>]
        [<RenderWith("Views/Posting/flag.django");ReflectedDefinition>]
        let flagC (flagType:string) (currentUser: Entities.user) (shortName: string) = 
                Actions.saveUserAction {Actions.empty() with 
                                            notifiedBy = currentUser
                                            notifiedOn = System.DateTime.Now
                                            flaggedPosting = match Postings.byShortName shortName with |Some p -> p |None->Postings.empty()
                                            actionType = Action.fromString flagType
                                        }
                |> named "currentAction"
            
    module Manage =
    
        module Ad = 

            [<Bind("get /posting/{contentType}/byname/{shortName}")>]
            [<RenderWith("Views/Posting/edit.django"); ReflectedDefinition>]
            let displayC (context: ictx) (contentType: string) (posting: Entities.posting option) = 
                match contentType with
                |"resume" -> context.Response.RenderWith("Views/Posting/Resume/edit.django")
                |"ad" -> context.Response.RenderWith("Views/Posting/Ad/edit.django")
                | _ -> context.Transfer("/static/bug")
                (match posting with 
                 | Some p -> List.map (fun (e: Entities.tag) -> e.tagText) p.tags
                 | None -> []) |> named "tags"

            [<FormData(false)>]
            type adForm = {
                heading: string
                tags: string
                detail: string
                published: string
            }

            [<Bind("post /posting/{contentType}/byname/{shortName}")>]
            [<RenderWith("Views/Posting/edit.django"); ReflectedDefinition>]
            let updateC (context: ictx) (data: adForm) (contentType: string)(shortName: string) (posting: Entities.posting option) (currentUser: Entities.user) = 
                let posting = 
                    match normalize data.published with 
                    | "" -> Postings.save { (match posting with | Some p -> p | None -> Postings.empty()) with 
                                             userId = currentUser.id
                                             heading = data.heading
                                             shortname = Postings.makeShortName data.heading
                                             shorttext = Postings.makeShortText data.detail
                                             updatedOn = System.DateTime.Now
                                             contents = data.detail 
                                             tags = Tags.parseAndDedupe data.tags
                                             contentType = Content.fromString contentType
                                             }
                    | _ -> Postings.save { (match posting with | Some p -> p | None -> failwith "Can't publish an empty posting") with 
                                            published = (data.published.ToLower() = "true") }
                match contentType with 
                | "ad" -> context.Transfer("/posting/manage")
                | "resume" -> context.Transfer("/resume/" + shortName)
                | _ -> context.Transfer("static/bug")

            [<Bind("get /posting/manage")>]
            [<RenderWith(@"Views\Posting\Ad\Manage\myAds.django"); ReflectedDefinition>]
            let manageC  (currentUser:Entities.user) = 
                let unpublished = Postings.byOwner currentUser false
                let published = Postings.byOwner currentUser true
                unpublished, published

        module Apply = 
            [<Bind("get /posting/apply/{contentType}/{shortName}")>]
            [<RenderWith("Views/Posting/apply.django"); ReflectedDefinition>]
            let applyDisplayC (context :ictx) (contentType: string) (shortName: string) (posting: Entities.posting) =
                match contentType with
                |"resume" -> context.Response.RenderWith("Views/Posting/Resume/apply.django")
                |"ad" -> context.Response.RenderWith("Views/Posting/Ad/apply.django")
                | _ -> context.Transfer("/static/bug")
                Postings.byShortName shortName |> named "posting"

            [<FormData(false)>]
            type applyForm = {
                comment: string
            }

            [<Bind("post /posting/apply/{contentType}/{shortName}")>]
            [<RenderWith("Views/Posting/applied.django"); ReflectedDefinition>]
            let applyC  (context:ictx)(contentType: string) (currentUser: Entities.user)  (comment:string form) (data: applyForm) (shortName: string)  = 

                match Postings.byShortName shortName with
                |Some p ->
                        let application = {Applications.empty() with 
                                            submittedPostingId = p.id
                                            submittedOn = System.DateTime.Now
                                            submittedBy = currentUser
                                            comment = data.comment
                                            submittedPosting = (match Postings.byId currentUser.postingId with
                                                                |Some submitted -> submitted
                                                                |None -> failwith ("No active posting to apply!")
                                                                         //context.Transfer("/static.bug")
                                                                         )
                                          }
                        Postings.save { p with applications = ( application:: p.applications  ) } |> named "posting"
                |None -> failwith("No posting by ShortName")


            [<Bind("get /posting/ad/applicants/byId/{adId}")>]
            [<RenderWith("Views/Posting/Ad/Manage/applicants.django"); ReflectedDefinition>]
            let viewApplicants (currentUser: Entities.user) =
                Postings.byOwner currentUser true |> named "postings"
        
