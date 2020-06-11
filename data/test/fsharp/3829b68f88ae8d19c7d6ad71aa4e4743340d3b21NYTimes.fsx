#r "../packages/FSharp.Data.2.2.5/lib/net40/Fsharp.Data.dll"

open FSharp.Data

type NYT = 
    JsonProvider<"http://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=2ef8ce1a9c93a64599d9d00f80555ff3:8:72646066">

type Review = 
    { Published: System.DateTime
      Summary: string
      Link: string
      LinkText: string }

let baseUri = "http://api.nytimes.com/svc/movies/v2/reviews/search.json"
let apiKey = "2ef8ce1a9c93a64599d9d00f80555ff3:8:72646066"

let tryPickReviewByName name = 
    let q = ["api-key", apiKey; "query", name]

    let response = Http.RequestString(baseUri, q)
    let nyt = NYT.Parse response
    let reviewOpt = nyt.Results |> Seq.tryFind (fun v -> 
                        System.String.Equals(v.DisplayTitle, name, System.StringComparison.InvariantCultureIgnoreCase))

    match reviewOpt with
    | Some v -> 
        Some { Published = v.PublicationDate
               Summary = v.SummaryShort
               Link = v.Link.Url
               LinkText = v.Link.SuggestedLinkText}
    | None -> None

tryPickReviewByName "american sniper"