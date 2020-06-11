module SuaveMusicStore.App

open Suave
open Suave.Successful
open Suave.Filters
open Suave.Operators
open Suave.RequestErrors
open Suave.Form
open Suave.Model.Binding


let bindToForm form handler =
    bindReq (bindForm form) handler BAD_REQUEST

let html container =
    OK (View.index container)
    >=> Writers.setMimeType "text/html; charset=utf-8"

let details id =
    match Db.getAlbumDetails id with
    | Some album ->
        html (View.details album)
    | None ->
        never

let overview = warbler (fun _ ->
    Db.getGenres 
    |> List.map (fun g -> g.Name) 
    |> View.store 
    |> html)

let browse =
    request (fun r ->
        match r.queryParam Path.Store.browseKey with
        | Choice1Of2 genre -> 
            Db.getAlbumsForGenre genre
            |> View.browse genre
            |> html
        | Choice2Of2 msg -> BAD_REQUEST msg)

let manage = warbler (fun x ->
    let a = x
    Db.getAlbumsDetails ()
    |> View.manage
    |> html)

let deleteAlbum id =
    
    match Db.getAlbum id  with
    | Some album ->
        choose [ 
            GET >=> warbler (fun _ -> 
                html (View.deleteAlbum album.Title))
            POST >=> warbler (fun _ -> 
                Db.deleteAlbum album ; 
                Redirection.FOUND Path.Admin.manage)
        ]
    | None ->
        never

let createAlbum =
    choose [
        GET >=> warbler (fun _ -> 
            let genres = 
                Db.getGenres 
                |> List.map (fun g -> decimal g.GenreId, g.Name)
            let artists = 
                Db.getArtists ()
                |> List.map (fun g -> decimal g.ArtistId, g.Name)
            html (View.createAlbum genres artists))
        POST >=> bindToForm Form.album (fun form ->
            Db.createAlbum (int form.ArtistId, int form.GenreId, form.Price, form.Title)
            Redirection.FOUND Path.Admin.manage)
    ]

let webPart = 
    choose [
        path Path.home >=> html View.home
        path Path.Store.overview >=> overview
        path Path.Store.browse >=> browse
        pathScan Path.Store.details details
        pathScan Path.Admin.deleteAlbum deleteAlbum
        path Path.Admin.manage >=> manage
        path Path.Admin.createAlbum >=> createAlbum
        pathRegex "(.*)\.(css|png)" >=> Files.browseHome
        html View.notFound
    ]
    
startWebServer defaultConfig webPart