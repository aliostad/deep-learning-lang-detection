// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open HttpClient
open FeedlyApi

[<EntryPoint>]
let main argv = 
    let request = FeedlyApi.opmlRequest
//    let request = createRequest Get "http://cloud.feedly.com/v3/profile"
//                    |> withHeader (Authorization ("OAuth " + FeedlyApi.accessTokenDev))
    printfn "%A" request.Headers
    let response = getResponse request
    printfn "%A" response.Headers
//    printfn "%s" <| Option.get response.EntityBody
    response.EntityBody
        |> Option.get
        |> fun body -> FeedlyApi.Opml.Parse(body)
        |> fun opml -> opml.Body.Outlines
        |> Seq.map (fun outline -> outline.XElement.Attribute(System.Xml.Linq.XName.Get("htmlUrl")).Value)
        |> printfn "%A"
    0 // return an integer exit code
