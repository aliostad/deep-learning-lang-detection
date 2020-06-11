module MovieNews.Data.NYTReview
open FSharp.Data

type NYT = JsonProvider<"http://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=2ef8ce1a9c93a64599d9d00f80555ff3:8:72646066&query=paddington">

let baseUrl = "http://api.nytimes.com/svc/movies/v2/reviews/search.json"
let apiKey = "2ef8ce1a9c93a64599d9d00f80555ff3:8:72646066"

/// As in 'Netflix.fs', the following function takes the
/// response as input and so it can be easily tested.

let tryPickReviewByName name response =
  let nyt = NYT.Parse(response)
  let reviewOpt = nyt.Results |> Seq.tryFind (fun r ->
    System.String.Equals
      ( r.DisplayTitle, name, 
        System.StringComparison.InvariantCultureIgnoreCase) )

  reviewOpt |> Option.map (fun r ->
    { Published = r.PublicationDate
      Summary = r.SummaryShort
      Link = r.Link.Url
      LinkText = r.Link.SuggestedLinkText } )


// The New York times api allows at most five requests
// per second. The throttling agant will do just that.

let throttler =
  Utils.createThrottle 200

let tryDownloadReviewByNme name = async {
    let q = ["api-key", apiKey; "query", name]
    let! response = throttler baseUrl q
    return tryPickReviewByName name response
  }