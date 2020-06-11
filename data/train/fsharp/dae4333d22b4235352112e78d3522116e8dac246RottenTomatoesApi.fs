namespace RottenTomatoesApi

open System
open FSharp.Data
open RottenTomatoesApi.Models

module public Api = 
    [<Literal>]
    let private apiKey = "9jxtafnnd4kd87hp8n9rkbw7"
    
    [<Literal>]
    let private baseUrl = "http://api.rottentomatoes.com/api/public/v1.0/"
    
    module Providers = 
        module Movies = 
            [<Literal>]
            let private searchUrl = baseUrl + "movies.json?apikey=" + apiKey + "&q=Jack&"
            
            [<Literal>]
            let private boxOfficeUrl = baseUrl + "lists/movies/box_office.json?apikey=" + apiKey
            
            [<Literal>]
            let private inTheatersUrl = baseUrl + "lists/movies/in_theaters.json?apikey=" + apiKey
            
            [<Literal>]
            let private openingUrl = baseUrl + "lists/movies/opening.json?apikey=" + apiKey
            
            [<Literal>]
            let private upcomingUrl = baseUrl + "lists/movies/upcoming.json?apikey=" + apiKey
            
            type Search = JsonProvider<searchUrl>
            
            type BoxOffice = JsonProvider<boxOfficeUrl>
            
            type InTheaters = JsonProvider<inTheatersUrl>
            
            type Opening = JsonProvider<openingUrl>
            
            type Upcoming = JsonProvider<upcomingUrl>
        
        module Movie = 
            [<Literal>]
            let private detailsUrl = baseUrl + "movies/770672122.json?apikey=" + apiKey
            
            [<Literal>]
            let private castUrl = baseUrl + "movies/770672122/cast.json?apikey=" + apiKey
            
            [<Literal>]
            let private reviewsUrl = baseUrl + "movies/770672122/reviews.json?apikey=" + apiKey
            
            [<Literal>]
            let private similarUrl = baseUrl + "movies/770672122/similar.json?apikey=" + apiKey
            
            type Details = JsonProvider<detailsUrl>
            
            type Cast = JsonProvider<castUrl>
            
            type Reviews = JsonProvider<reviewsUrl>
            
            type Similar = JsonProvider<similarUrl>
        
        module DVDs = 
            [<Literal>]
            let private currentReleases = baseUrl + "lists/dvds/current_releases.json?apikey=" + apiKey
            
            [<Literal>]
            let private newReleasesUrl = baseUrl + "lists/dvds/new_releases.json?apikey=" + apiKey
            
            [<Literal>]
            let private upcomingUrl = baseUrl + "lists/dvds/upcoming.json?apikey=" + apiKey
            
            type CurrentReleases = JsonProvider<currentReleases>
            
            type NewReleases = JsonProvider<newReleasesUrl>
            
            type Upcoming = JsonProvider<upcomingUrl>
    
    module Movies = 
        let private searchUrl = sprintf "%smovies.json?apikey=%s&q=%s" baseUrl apiKey
        let private boxOfficeUrl = sprintf "%slists/movies/box_office.json?apikey=%s" baseUrl apiKey
        let private inTheatersUrl = sprintf "%slists/movies/in_theaters.json?apikey=%s" baseUrl apiKey
        let private openingUrl = sprintf "%slists/movies/opening.json?apikey=%s" baseUrl apiKey
        let private upcomingUrl = sprintf "%slists/movies/upcoming.json?apikey=%s" baseUrl apiKey
        
        let Search(query : string) = 
            let completeUrl = sprintf "%s" (searchUrl query)
            Providers.Movies.Search.Load(completeUrl)
        
        let GetBoxOffice() = Providers.Movies.BoxOffice.Load(boxOfficeUrl).Movies
        let GetInTheater() = Providers.Movies.InTheaters.Load(inTheatersUrl).Movies
        let GetOpening() = Providers.Movies.Opening.Load(openingUrl).Movies
        let GetUpcoming() = Providers.Movies.Upcoming.Load(upcomingUrl).Movies
    
    module Movie = 
        let private detailsUrl = sprintf "%smovies/%d.json?apikey=%s"
        let private reviewsUrl = sprintf "%smovies/%d/reviews.json?apikey=%s"
        let private similarUrl = sprintf "%smovies/%d/similar.json?apikey=%s"
        
        let GetDetails(id : int) = 
            let completeUrl = detailsUrl baseUrl id apiKey
            Providers.Movie.Details.Load(completeUrl)
        
        let GetReviews(id : int) = 
            let completeUrl = reviewsUrl baseUrl id apiKey
            Providers.Movie.Reviews.Load(completeUrl)
        
        let GetSimilar(id : int) = 
            let completeUrl = similarUrl baseUrl id apiKey
            Providers.Movie.Details.Load(completeUrl)
    
    module DVDs = 
        let private currentReleasesUrl = sprintf "%slists/dvds/current_releases.json?apikey=%s" baseUrl apiKey
        let private newReleasesUrl = sprintf "%slists/dvds/new_releases.json?apikey=%s" baseUrl apiKey
        let private upcomingUrl = sprintf "%slists/dvds/upcoming.json?apikey=%s" baseUrl apiKey

        let GetCurrentReleases() = Providers.DVDs.CurrentReleases.Load(currentReleasesUrl).Movies
        let GetNewReleases() = Providers.DVDs.NewReleases.Load(newReleasesUrl).Movies
        let GetUpcoming() = Providers.DVDs.Upcoming.Load(newReleasesUrl).Movies
    
    module Typed = 
        
        module Movies = 
            let GetBoxOffice() = 
                let movies = Movies.GetBoxOffice()
                let cast = movies |> Seq.map(fun m -> m.AbridgedCast |> Seq.map(fun c -> new CastMember(c.Name, c.Characters)))
                movies |> Seq.map (fun m -> 
                              { Title = m.Title
                                Year = m.Year
                                Poster = m.Posters.Original
                                MpaaRating = m.MpaaRating
                                Runtime = m.Runtime
                                CriticsConsensus = m.CriticsConsensus.JsonValue.ToString()
                                ReleaseDate = m.ReleaseDates.Theater.ToString()
                                Synopsis = m.Synopsis
                                AbridgedCast = m.AbridgedCast |> Seq.map(fun c ->  new CastMember(c.Name, c.Characters)) |> Seq.toArray
                                AlternateIDs = { IMDb = "" }
                                Ratings = 
                                    { CriticsRating = m.Ratings.CriticsRating
                                      CriticsScore = m.Ratings.CriticsScore
                                      AudienceRating = m.Ratings.AudienceRating
                                      AudienceScore = m.Ratings.AudienceScore } })
