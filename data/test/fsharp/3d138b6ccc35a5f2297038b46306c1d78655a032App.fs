module SuaveMusicStore.App

open Suave
open Suave.Successful
open Suave.Operators
open Suave.Filters
open Suave.RequestErrors

open System.Diagnostics

let html container =
    OK (View.index container)
    >=> Writers.setMimeType "text/html; charset=utf-8"

let manage = warbler (fun _ ->
    Db.getContext()
    |> Db.getAlbumDetails
    |> View.manage
    |> html)

// warbler ensures that data will be fetched from the database whenever a new request comes
let overview = warbler (fun _ -> 
    Db.getContext() 
    |> Db.getGenres 
    |> List.map (fun g -> g.Name) 
    |> View.store 
    |> html)

let browse =
    request (fun r ->
        match r.queryParam Path.Store.browseKey with
        | Choice1Of2 genre -> 
            Db.getContext()
            |> Db.getAlbumsForGenre genre
            |> View.browse genre
            |> html
        | Choice2Of2 msg -> BAD_REQUEST msg)

let details id =
    let albumDetails =  id |> Db.getAlbumDetailById <| Db.getContext()
    match albumDetails with
    | Some album ->
        html (View.details album)
    | None ->
        never

let webPart = 
    choose [
        path Path.Admin.manage >=> manage
        path Path.home >=> html View.home
        path Path.Store.overview >=> overview
        path Path.Store.browse >=> browse
        pathScan Path.Store.details details

        pathRegex "(.*)\.(css|png)" >=> Files.browseHome
        html View.notFound
    ]


//let name = System.Reflection.Assembly.GetCallingAssembly().GetName().Name
//Process.GetProcessesByName("FSharpSuave_Test") |> Array.iter (fun p -> p.Close())
System.Diagnostics.Process.Start("http://localhost:8083") |> ignore
startWebServer defaultConfig webPart
