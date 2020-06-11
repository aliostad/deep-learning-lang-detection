#r "../packages/FSharp.Data.2.2.5/lib/net40/Fsharp.Data.dll"

open FSharp.Data

let apiKey = "1b0ffdcf0305781a94a4d20a142d5cf8"

let searchUrl = "http://api.themoviedb.org/3/search/movie"
let detailsUrl id = 
    sprintf "http://api.themoviedb.org/3/movie/%d" id
let creditsUrl id = 
    sprintf "http://api.themoviedb.org/3/movie/%d/credits" id

type MovieSearch = JsonProvider<"MovieSearchSample.json">
type MovieDetails = JsonProvider<"MovieDetailsSample.json">
type MovieCast = JsonProvider<"MovieCastSample.json">

type Cast = 
    { Actor: string
      Character: string }

type Details = 
    { Homepage: string
      Genres: seq<string>
      Overview: string
      Companies: seq<string>
      Poster: string
      Countries: seq<string>
      Released: System.DateTime
      AverageVote: decimal}

let tryGetMovieId title = 
    let jsonResponse= 
        Http.RequestString(searchUrl,
            query = ["api_key", apiKey; "query", title],
            headers = [HttpRequestHeaders.Accept "application/json"])
    let searchRes = MovieSearch.Parse(jsonResponse)
    searchRes.Results
    |> Seq.tryFind(fun res ->
        res.Title = title)
    |> Option.map(fun res -> res.Id)

tryGetMovieId "Interstellar"

let getMovieDetails id = 
    let jsonResponse =
        Http.RequestString(detailsUrl id,
          query = ["api_key", apiKey],
          headers = [HttpRequestHeaders.Accept "application/json"])
    let details = MovieDetails.Parse(jsonResponse)
    { Homepage = details.Homepage
      Genres = [for v in details.Genres -> v.Name]
      Overview = details.Overview
      Companies = 
        [for v in details.ProductionCompanies -> v.Name]
      Poster = details.PosterPath
      Countries = 
        [for v in details.ProductionCountries -> v.Name]
      Released = details.ReleaseDate
      AverageVote = details.VoteAverage }

getMovieDetails 157336

let getMovieCast id =
    let jsonResponse = 
        Http.RequestString(creditsUrl id,
          query = ["api_key", apiKey],
          headers = [HttpRequestHeaders.Accept "application/json"])
    let cast = MovieCast.Parse(jsonResponse)
    [for v in cast.Cast ->
        { Actor = v.Name
          Character = v.Character }]

getMovieCast 157336