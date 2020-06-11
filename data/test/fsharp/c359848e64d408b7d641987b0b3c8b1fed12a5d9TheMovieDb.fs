module MovieNews.Data.TheMovieDb
open FSharp.Data

type MovieSearch = JsonProvider<"MovieSearch.json">
type MovieCast = JsonProvider<"MovieCast.json">
type MovieDetails = JsonProvider<"MovieDetails.json">

let apiKey = "6ce0ef5b176501f8c07c634dfa933cff"
let searchUrl =
  "http://api.themoviedb.org/3/search/movie"
let detailsUrl id = 
  sprintf "http://api.themoviedb.org/3/movie/%d" id
let creditsUrl id = 
  sprintf "http://api.themoviedb.org/3/movie/%d/credits" id

// This throttler allows at most 20 requests per second.
let throttler =
  Utils.createThrottle 50

let tryGetMovieId title = async {
    let! jsonResponse = 
      throttler
        searchUrl
        ["api_key",apiKey; "query", title]

    let searchRes = MovieSearch.Parse(jsonResponse)
    return 
      searchRes.Results
      |> Seq.tryFind (fun res -> 
          res.Title = title)
      |> Option.map (fun res -> res.Id)
  }

let getMovieDetails id = async {
    let! jsonResponse =
      throttler
        (detailsUrl id)
        ["api_key",apiKey]

    let details = MovieDetails.Parse(jsonResponse)
    return
      { Homepage = details.Homepage
        Genres = [ for g in details.Genres -> g.Name ]
        Overview = details.Overview
        Companies = 
          [ for p in details.ProductionCompanies -> p.Name ]
        Poster = details.PosterPath
        Countries = 
          [ for c in details.ProductionCountries -> c.Name ]
        Released = details.ReleaseDate
        AverageVote = details.VoteAverage }
  }

let getMovieCast id = async {
    let! jsonResponse = 
      throttler
        (creditsUrl id) 
        ["api_key", apiKey]

    let cast = MovieCast.Parse(jsonResponse)
    return
      [ for c in cast.Cast ->
          { Actor = c.Name
            Character = c.Character } ]
  }

let getMovieInfoByName name = async {
    let! optId = tryGetMovieId name
    match optId with
    | None -> return None
    | Some id ->
      let! cast = getMovieCast id
      let! details = getMovieDetails id
      return Some(details, cast)
  }