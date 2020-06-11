﻿module SuaveMusicStore.App

open Suave
open Suave.Successful
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.RequestErrors

let html container =
    OK (View.index container)
    >=> Writers.setMimeType "text/html; charset=utf-8"

let browse =
    request (fun r ->
        match r.queryParam Path.Store.browseKey with
        | Choice1Of2 genre ->
             Db.getContext()
             |> Db.getAlbumsForGenre genre
             |> View.browse genre
             |> html
        | Choice2Of2 msg -> BAD_REQUEST msg)

let overview = warbler (fun _ ->
    Db.getContext()
    |> Db.getGenres
    |> List.map (fun g -> g.Name)
    |> View.store
    |> html)

let details id =
    match Db.getAlbumDetails id (Db.getContext()) with
    | Some album -> html (View.details album)
    | None -> never

let manage = warbler (fun _ ->
    Db.getContext()
    |> Db.getAlbumsDetails
    |> View.Admin.manage
    |> html)

let deleteAlbum id =
    let ctx = Db.getContext()
    match Db.getAlbum id ctx with
    | Some album ->
        choose [
            GET >=> warbler (fun _ ->
                html (View.Admin.deleteAlbum album.Title)
            )
            POST >=> warbler (fun _ ->
                Db.deleteAlbum album ctx
                Redirection.FOUND Path.Admin.manage
            )
        ]
    | None -> never

let webPart =
    choose [
        path Path.home >=> html View.home
        path Path.Store.overview >=> overview
        path Path.Store.browse >=> browse
        path Path.Admin.manage >=> manage
        pathScan Path.Store.details details
        pathScan Path.Admin.deleteAlbum deleteAlbum
        pathRegex "(.*)\.(css|png|gif)" >=> Files.browseHome
        html View.notFound
    ]

startWebServer defaultConfig webPart
