#r @"../packages/FSharp.Data.2.3.3/lib/net40/FSharp.Data.dll"
open FSharp.Data

let apiKey = "104ca45141181f9e2407e992d43abee3"

let searchUrl = 
  "http://api.themoviedb.org/3/search/movie"

let detailsUrl id =
  sprintf "http://api.themoviedb.org/3/movie/%d" id

let creditUrl id =
  sprintf "http://api.themoviedb.org/3/movie/%d/credits" id

type MovieSearch = JsonProvider<"MovieSearch.json">
type MovieCast = JsonProvider<"MovieCast.json">
type MovieDetails = JsonProvider<"MovieDetails.json">

type Cast =
  {
    Actor : string
    Character : string
  }

type Details = 
  {
    Homepage : string
    Genres : seq<string>
    Overview : string
    Companies : seq<string>
    Poster : string
    Countries : seq<string>
    Released : System.DateTime
    AverageVote : decimal
  }

let tryGetMovieId title =
  let jsonResponse =
    Http.RequestString(
      searchUrl,
      query = ["api_key", apiKey; "query", title],
      headers = [HttpRequestHeaders.Accept "application/json"])
  let searchRes = MovieSearch.Parse(jsonResponse)
  searchRes.Results
  |> Seq.tryFind(fun res -> 
    res.Title = title)
  |> Option.map (fun res -> res.Id)

let getMovieDetails id =
  let jsonResponse = 
    Http.RequestString(
      detailsUrl id,
      query = ["api_key", apiKey],
      headers = [HttpRequestHeaders.Accept "application/json"])
  let details = MovieDetails.Parse(jsonResponse)
  {
    Homepage = details.Homepage
    Genres = [for g in details.Genres -> g.Name]
    Overview = details.Overview
    Companies = 
      [for p in details.ProductionCompanies -> p.Name]
    Poster = details.PosterPath
    Countries = 
      [for c in details.ProductionCompanies -> c.Name]
    Released = details.ReleaseDate
    AverageVote = details.VoteAverage
  }

let getMovieCast id=
  let jsonResponse = 
    Http.RequestString(
      creditUrl id,
      query = ["api_key", apiKey],
      headers = [HttpRequestHeaders.Accept "application/json"])
  let cast = MovieCast.Parse(jsonResponse)
  [for c in cast.Cast ->
    {
      Actor = c.Name
      Character = c.Character
    }
  ]


tryGetMovieId "Interstellar"
getMovieDetails 157336
getMovieCast 157336