//modules are compiled as static class
module MovieNews.Data.NYTReview
open FSharp.Data

type NYT = JsonProvider<"http://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=069f02d3adcd4d59a739c071aaa16a10">
let baseURL = "http://api.nytimes.com/svc/movies/v2/reviews/search.json"
let apiKey = "069f02d3adcd4d59a739c071aaa16a10"

type Review = 
    {
        Published : System.DateTime
        Summary : string
        Link : string
        LinkText : string
    }

let tryPickReview name =     
    let q = ["api-key", apiKey; "query", name]
    let response = Http.RequestString(baseURL, q)
    let nyt = NYT.Parse(response)
    let reviewOpt = nyt.Results |> Seq.tryFind (fun r -> 
        System.String.Equals(r.DisplayTitle, name, System.StringComparison.OrdinalIgnoreCase))
    reviewOpt |> Option.map (fun r ->          
        {  Published = r.PublicationDate
           Summary = r.SummaryShort
           Link = r.Link.Url
           LinkText = r.Link.SuggestedLinkText } )      