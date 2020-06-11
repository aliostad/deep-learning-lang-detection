module TheMovieDb

open FSharp.Data
open MovieData
open MovieData.Utils

let apiKey = "1b0ffdcf0305781a94a4d20a142d5cf8"

let searchUrl = "http://api.themoviedb.org/3/search/movie"
let detailsUrl id = 
    sprintf "http://api.themoviedb.org/3/movie/%d" id
let creditsUrl id = 
    sprintf "http://api.themoviedb.org/3/movie/%d/credits" id

type MovieSearch = JsonProvider<"MovieSearchSample.json">
type MovieDetails = JsonProvider<"MovieDetailsSample.json">
type MovieCast = JsonProvider<"MovieCastSample.json">

let throttler = createThrottler 50

let tryGetMovieId title = async {
        let! jsonResponse= 
            throttler 
                searchUrl
                ["api_key", apiKey; "query", title]
        let searchRes = MovieSearch.Parse(jsonResponse)
        return
            searchRes.Results
            |> Seq.tryFind(fun res ->
                res.Title = title)
            |> Option.map(fun res -> res.Id)
    }

let getMovieDetails id = async {
        let! jsonResponse =
            throttler
               (detailsUrl id)
               ["api_key", apiKey]
        let details = MovieDetails.Parse(jsonResponse)
        return
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
    }

let getMovieCast id = async {
        let! jsonResponse = 
           throttler
              (creditsUrl id)
              ["api_key", apiKey]
        let cast = MovieCast.Parse(jsonResponse)
        return
            [for v in cast.Cast ->
                { Actor = v.Name
                  Character = v.Character }]
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