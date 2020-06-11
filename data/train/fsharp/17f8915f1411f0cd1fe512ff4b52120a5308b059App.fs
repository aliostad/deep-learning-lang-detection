﻿module SuaveMusicStore.App

open Suave
open Suave.Operators
open Suave.Web
open Suave.Filters
open Suave.RequestErrors
open View
open Suave.Model
open Suave.Form
open Suave.Authentication
open Suave.State.CookieStateStore
open Suave.Cookie
open System.Security.Cryptography
open System
open SuaveMusicStore.Form
open Suave.Successful

let passHash (pass:string) =
    use sha = SHA256.Create()
    Text.Encoding.UTF8.GetBytes(pass)
    |> sha.ComputeHash
    |> Array.map (fun b -> b.ToString("x2"))
    |> String.concat ""

let session f =
    statefulForSession
    >=> context (fun x ->
        match x |> HttpContext.state with
        | None -> f NoSession
        | Some state ->
            match state.get "username", state.get "role" with
            | Some username, Some role -> f (UserLoggedOn {Username=username; Role=role})
            | _ -> f NoSession
    )

let html container =
    let result user =
        OK (View.index (partUser user) container)
    >=> Writers.setMimeType "text/Html; charset=utf-8"

    session (fun x ->
    match x with
    | UserLoggedOn {Username = username} ->
        result (Some username)
    | _ -> result None
    )

let sessionStore setF = context (fun x ->
    match HttpContext.state x with
    | Some state -> setF state
    | None -> never )

let returnpathOrHome =
    request (fun x ->
        let path =
            match (x.queryParam "returnPath") with
            | Choice1Of2 path -> path
            | _ -> Path.home
        Redirection.FOUND path )

let overview = warbler (fun _ ->
    Db.getContext()
    |> Db.getGenres
    |> List.map (fun g -> g.Name)
    |> View.store
    |> html)

let bindToForm form handler =
    bindReq (bindForm form) handler BAD_REQUEST

let details id =
    match Db.getAlbumDetails id (Db.getContext()) with
    | Some album ->
        html (View.details album)
    | None -> never

let manage = warbler (fun _ ->
    Db.getContext()
    |> Db.getAlbumsDetails
    |> View.manage
    |> html)

let deleteAlbum id =
    let ctx = Db.getContext()
    match Db.getAlbum id ctx with
    | Some album -> 
        choose [
            GET >=> warbler (fun _ ->
                html (View.deleteAlbum album.Title))
            POST >=> warbler(fun _ ->
                Db.deleteAlbum album ctx;
                Redirection.FOUND Path.Admin.manage)
        ]
    | None -> never

let createAlbum =
    let ctx = Db.getContext()
    choose [
        GET >=> warbler ( fun _ ->
            let genres =
                Db.getGenres ctx
                |> List.map (fun g -> decimal g.GenreId, g.Name)
            let artists =
                Db.getArtists ctx
                |> List.map (fun g -> decimal g.ArtistId, g.Name)
            html (View.createAlbum genres artists)
        )
        POST >=> bindToForm Form.album (fun form ->
            Db.createAlbum (int form.ArtistId, int form.GenreId, form.Price, form.Title) ctx
            Redirection.FOUND Path.Admin.manage)
    ]

let editAlbum id =
    let ctx = Db.getContext()
    match Db.getAlbum id ctx with
    | Some album ->
        choose [
            GET >=> warbler (fun _ ->
                let genres =
                    Db.getGenres ctx
                    |> List.map (fun g -> decimal g.GenreId, g.Name)
                let artists =
                    Db.getArtists ctx
                    |> List.map (fun g -> decimal g.ArtistId, g.Name)
                html (View.editAlbum album genres artists)
            )
            POST >=> bindToForm Form.album (fun form ->
                Db.updateAlbum album (int form.ArtistId, int form.GenreId, form.Price, form.Title) ctx
                Redirection.FOUND Path.Admin.manage
            )
        ]
    | None -> never

let browse =
    request (fun r -> 
        match r.queryParam Path.Store.browseKey with
        | Choice1Of2 genre ->
            Db.getContext()
            |> Db.getAlbumsForGenre genre
            |> View.browse genre
            |> html
        | Choice2Of2 msg -> BAD_REQUEST msg)

let logon =
    choose [
        GET >=> (View.logon "" |> html)
        POST >=> bindToForm Form.logon (fun form ->
            let ctx = Db.getContext()
            let (Password password) = form.Password
            match Db.validateUser(form.Username, passHash password) ctx with
            | Some user ->
                authenticated Cookie.CookieLife.Session false
                >=> session (fun _ -> succeed)
                >=> sessionStore (fun store ->
                    store.set "username" user.UserName
                    >=> store.set "role" user.Role)
                >=> returnpathOrHome
            | None -> View.logon "Username or password is invalid" |> html
        )
    ]

let reset =
    unsetPair SessionAuthCookie
    >=> unsetPair StateCookie
    >=> Redirection.FOUND Path.home

let redirectWithReturnPath redirection =
    request (fun x ->
        let path = x.url.AbsolutePath
        Redirection.FOUND (redirection |> Path.withParam ("returnPath", path))
    )

let loggedOn f_success =
    authenticate
        Cookie.CookieLife.Session
        false
        (fun () -> Choice2Of2 (redirectWithReturnPath Path.Account.logon))
        (fun _ -> Choice2Of2 reset)
        f_success

let admin f_success =
    loggedOn (session (function
        | UserLoggedOn {Role = "admin"} -> f_success
        | UserLoggedOn _ -> FORBIDDEN "Only for admin"
        | _ -> UNAUTHORIZED "Not logged in"
    ))

let webPart : WebPart =
    choose [
        path Path.home >=> html View.home
        path Path.Store.overview >=> overview
        path Path.Store.browse >=> browse
        path Path.Admin.manage >=> admin manage
        path Path.Admin.createAlbum >=> admin createAlbum
        path Path.Account.logon >=> logon
        path Path.Account.logoff >=> reset

        pathScan Path.Admin.deleteAlbum (fun id ->admin (deleteAlbum id))
        pathScan Path.Admin.editAlbum (fun id -> admin (editAlbum id))
        pathScan Path.Store.details details

        pathRegex "(.*)\.(css|png)" >=> Files.browseHome

        html View.notFound
    ]

startWebServer defaultConfig webPart