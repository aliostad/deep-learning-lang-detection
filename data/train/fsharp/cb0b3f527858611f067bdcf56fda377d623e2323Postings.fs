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
            HttpContext.Current.Response.Cookies.Add(new HttpCookie("nrDefaultContentType", defaultContentType))
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
        let viewC shortName (contentType: string option) (defaultContentType: string) =
            Postings.byShortName shortName |> named "posting",
            defaultContentType |> named "contentType"
            
    module Manage =
        module Ad = 
            [<Bind("get /posting/ad/byname/{shortName}")>]
            [<RenderWith("Views/Posting/Ad/edit.django"); ReflectedDefinition>]
            let displayC() = ()

            type adForm = {
                heading: string
                tags: string
                detail: string
                published: string
            }

            [<Bind("post /posting/ad/byname/{shortName}")>]
            [<RenderWith("Views/Posting/Ad/edit.django"); ReflectedDefinition>]
            let updateC (data: adForm) shortName (posting: Entities.posting) (currentUser: Entities.user) = 
                (match normalize data.published with 
                 | "" -> Postings.save { posting with 
                                            userId = currentUser.id
                                            heading = data.heading
                                            shortname = Postings.makeShortName data.heading
                                            shorttext = Postings.makeShortText data.detail
                                            updatedOn = System.DateTime.Now
                                            contents = data.detail 
                                            tags = Tags.parseAndDedupe data.tags}
                 | _ -> Postings.save { posting with published = (data.published.ToLower() = "true") })
                 |> named "posting"