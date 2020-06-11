module Nlglff.Api

open System
open System.Collections.Generic
open FSharp.Data

let baseApiUrl = "http://nlglff-dev.azurewebsites.net/api/"

let filmsUrl = baseApiUrl + "films"
let sponsorsUrl = baseApiUrl + "sponsors"

type Films = JsonProvider<"http://nlglff-dev.azurewebsites.net/api/films", RootName="Film">
type Film = Films.Film
type Showtime = Films.Showtime



type Sponsors = JsonProvider<"http://nlglff-dev.azurewebsites.net/api/sponsors", RootName="Sponsor">
type Sponsor = Sponsors.Sponsor

let memoize name f =
    let dict = new System.Collections.Generic.Dictionary<_,_>()

    fun () ->
        match dict.TryGetValue(name) with
        | (true, v) -> v
        | _ ->
            let temp = f()
            dict.Add(name, temp)
            temp

let loadFilms = memoize "films" (fun () ->
    Films.Load(filmsUrl))

let loadSponsors = memoize "sponsors" (fun () ->
    Sponsors.Load(sponsorsUrl))

let sponsorsForYear year =
    loadSponsors () |> Array.filter (fun s -> s.Year = 2015)

let getDateTime (s: Showtime) =
    new DateTime (s.Date.Year, s.Date.Month, s.Date.Day, s.Time.Hour, s.Time.Minute, 0)
  
let getShowtimes (films: Film array) =
    films
    |> Array.toList
    |> List.fold (fun a e -> List.append a (Array.toList e.Showtimes |> List.map (fun s -> (e, s)))) []
    |> List.sortBy (fun s -> getDateTime (snd s))

let getNowPlaying c f =
     getShowtimes f
     |> List.find (fun s -> getDateTime (snd s) >= c)
