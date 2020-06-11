module SuaveMusicStore.App
//#r "packages/Suave/lib/net40/Suave.dll"
//#r "packages/Suave.Experimental/lib/net40/Suave.Experimental.dll"

open Suave                 // always open suave
open Suave.Successful      // for OK-result
open Suave.Web             // for config
open Suave.Filters
open Suave.Operators
open Suave.RequestErrors
open Suave.Form
open Suave.RequestErrors
open Suave.Model.Binding

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
    | Choice2Of2 msg -> BAD_REQUEST msg
  )



let overview = warbler (fun _ ->
  Db.getContext()
  |> Db.getGenres
  |> List.map (fun g -> g.Name)
  |> View.store
  |> html
)


let details id =
  match Db.getAlbumDetails id (Db.getContext()) with
  | Some album ->
    html (View.details album)
  | None ->
    never


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
        POST >=> warbler (fun _ ->
          Db.deleteAlbum album ctx;
          Redirection.FOUND Path.Admin.manage)
      ]

    | None ->
      never


let bindToForm form handler =
  bindReq (bindForm form) handler BAD_REQUEST

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
        html (View.editAlbum album genres artists))
      POST >=> bindToForm Form.album (fun form ->
        Db.updateAlbum album (int form.ArtistId, int form.GenreId, form.Price, form.Title) ctx
        Redirection.FOUND Path.Admin.manage)
    ]
  | None -> never


let createAlbum =
  let ctx = Db.getContext()
  choose [
    GET >=> warbler (fun _ ->
      let genres =
          Db.getGenres ctx
          |> List.map (fun g -> decimal g.GenreId, g.Name)
      let artists =
          Db.getArtists ctx
          |> List.map (fun g -> decimal g.ArtistId, g.Name)
      html (View.createAlbum genres artists))
    POST >=> bindToForm Form.album (fun form ->
      Db.createAlbum (int form.ArtistId, int form.GenreId, form.Price, form.Title) ctx
      Redirection.FOUND Path.Admin.manage)
  ]




let webPart =
  choose [
    path Path.home >=> html View.home
    path Path.Store.overview >=> overview
    path Path.Store.browse >=> browse
    pathScan Path.Store.details details


    path Path.Admin.manage >=> manage
    pathScan Path.Admin.deleteAlbum deleteAlbum
    path Path.Admin.createAlbum >=> createAlbum
    pathScan Path.Admin.editAlbum editAlbum

    pathRegex "(.*)\.(css|png|gif)" >=> Files.browseHome
    html View.notFound
  ]







startWebServer defaultConfig webPart
