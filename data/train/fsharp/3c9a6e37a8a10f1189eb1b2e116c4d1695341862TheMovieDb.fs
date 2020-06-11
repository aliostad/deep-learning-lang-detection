module MovieNews.Data.TheMovieDb

open FSharp.Data

let apiKey = "104ca45141181f9e2407e992d43abee3"

let searchUrl = "http://api.themoviedb.org/3/search/movie"

let detailsUrl id = sprintf "http://api.themoviedb.org/3/movie/%d" id

let creditUrl id = sprintf "http://api.themoviedb.org/3/movie/%d/credits" id

type MovieSearch = JsonProvider<"MovieSearch.json">
type MovieCast = JsonProvider<"MovieCast.json">
type MovieDetails = JsonProvider<"MovieDetails.json">

// 20 request per second
let throttler =
  Utils.createThrottler 50

let tryGetMovieId title = async {
  let! jsonResponse =
    throttler
      searchUrl
      ["api_key", apiKey; "query", title]
  let searchRes = MovieSearch.Parse(jsonResponse)
  return
    searchRes.Results
    |> Seq.tryFind(fun res ->
      res.Title = title)
    |> Option.map (fun res -> res.Id) }

let getMovieDetails id = async  {
  let! jsonResponse = 
    throttler
      (detailsUrl id)
      ["api_key", apiKey]

  let details = MovieDetails.Parse(jsonResponse)
  return
    {
      Homepage = details.Homepage
      Genres = [for g in details.Genres -> g.Name]
      Overview = details.Overview
      Companies = [for p in details.ProductionCompanies -> p.Name]
      Poster = details.PosterPath
      Countries = [for c in details.ProductionCompanies -> c.Name]
      Released = details.ReleaseDate
      AverageVote = details.VoteAverage
    }
  }

let getMovieCast id = async {
  let! jsonResponse = 
    throttler
      (creditUrl id)
      ["api_key", apiKey]
  let cast = MovieCast.Parse(jsonResponse)
  return
    [for c in cast.Cast ->
      {
        Actor = c.Name
        Character = c.Character
      }
    ] }

let getMovieInfoByName name = async {
  let! optId = tryGetMovieId name
  match optId with
  | None -> return None
  | Some id ->
    let! cast = getMovieCast id
    let! details = getMovieDetails id
    return Some(details, cast)
}
    