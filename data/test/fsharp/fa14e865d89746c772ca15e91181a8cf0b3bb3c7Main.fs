namespace LibraryWithSitelet

open System
open System.IO
open System.Web
open IntelliFactory.WebSharper.Sitelets
open IntelliFactory.Html
open IntelliFactory.WebSharper
open IntelliFactory.WebSharper.Formlet
open PerfectShuffle.WebsharperExtensions

type NestedAction =
| Foo
| Bar of string
| Upload

module UploadHandler =
  open IntelliFactory.WebSharper.Sitelets
  
  let private extractFilesFromRequest inputFieldName (requestContext:System.Web.HttpRequest) =
    let fileDict = requestContext.Files
    
    let files =
      fileDict.AllKeys
      |> Seq.filter (fun key -> key = inputFieldName)
      |> Seq.map (fun key -> fileDict.Get(key))
    
    files

  let UploadContentFactory inputFieldName (redirectUrlFactory:Context<'a> -> string) (fileHandler:System.Web.HttpPostedFile -> unit) =
    
    let content =
      Content.CustomContent (fun ctx ->
        let request = System.Web.HttpContext.Current.Request
        let files = extractFilesFromRequest inputFieldName request
        
        files |> Seq.iter fileHandler
        
        let redirectUrl = redirectUrlFactory ctx

        {
          Status = Http.Status.Custom 301 (Some "Moved Permanently")
          Headers = [Http.Header.Custom "Location" redirectUrl]
          WriteBody = ignore
        }
        )

    content  

module NestedSite =
  
  let sitelet (actionMap : 'a -> NestedAction) (templateWrapper:(Context<NestedAction> -> Content.HtmlElement list) -> Content<'a>) : Sitelet<'a> =
  
    let fooContent (ctx:Context<NestedAction>) =
      [
        Div [Text "Foo page"]
      ]
    
    let barContent (ctx:Context<NestedAction>) =
      [
        Div [Text "Bar page"]
      ]

    Sitelet.Infer <| fun action ->
     match actionMap action with
     | Foo -> templateWrapper fooContent
     | Bar x -> templateWrapper barContent
     | Upload -> UploadHandler.UploadContentFactory "file" (fun _ -> "/success") (fun file -> () (*Save to disk etc here...*))



