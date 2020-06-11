module SuaveMusicStore.View

open Suave.Html
open Suave.Successful
open Suave.Operators
open Suave
open System
open Suave.Form
open Suave.Model

let divId id = divAttr [ "id", id ]
let divClass c = divAttr [ "class", c ]
let h1 xml = tag "h1" [] xml
let aHref href = tag "a" [ "href", href ]

let cssLink href = 
    linkAttr [ "href", href
               "rel", "stylesheet"
               "type", "text,css" ]

let ul xml = tag "ul" [] (flatten xml)
let li = tag "li" []
let h2 s = tag "h2" [] (text s)
let imgSrc src = imgAttr [ "src", src ]
let em s = tag "em" [] (text s)
let formatDec (d : decimal) = d.ToString(Globalization.CultureInfo.InvariantCulture)
let form x = tag "form" [ "method", "POST" ] (flatten x)
let fieldset x = tag "fieldset" [] (flatten x)
let legend txt = tag "legend" [] (text txt)


let ulAttr attr xml = tag "ul" attr (flatten xml)
let partNav =
    ulAttr ["id", "navlist"] [
        li (aHref Path.home (text "Home"))
        li (aHref Path.Store.overview (text "Store"))
        li (aHref Path.Admin.manage (text "Admin"))
    ]

let submitInput value = 
    inputAttr [ "type", "submit"
                "value", value ]

type Field<'a> = 
    { Label : string
      Xml : Form<'a> -> Xml }

type Fieldset<'a> = 
    { Legend : string
      Fields : Field<'a> list }

type FormLayout<'a> = 
    { Fieldsets : Fieldset<'a> list
      SubmitText : string
      Form : Form<'a> }

let renderForm (layout : FormLayout<_>) = 
    form [ for set in layout.Fieldsets -> 
               fieldset [ yield legend set.Legend
                          for field in set.Fields do
                              yield divClass "editor-label" [ text field.Label ]
                              yield divClass "editor-field" [ field.Xml layout.Form ] ]
           yield submitInput layout.SubmitText ]

let home = [ h2 "Home" ]

let browse genre (albums : Db.Album list) = 
    [ h2 (sprintf "Genre: %s" genre)
      ul [ for a in albums -> li (aHref (sprintf Path.Store.details a.AlbumId) (text a.Title)) ] ]

let details (album : Db.AlbumDetails) = 
    [ h2 album.Title
      p [ imgSrc album.AlbumArtUrl ]
      divId "album-details" [ for (caption, t) in [ "Genre:", album.Genre
                                                    "Artist:", album.Artist
                                                    "Price", formatDec album.Price ] -> 
                                  p [ em caption
                                      text t ] ] ]
let partUser (user: string option) =
    divId "part-user" [
        match user with
        | Some user ->
            yield text (sprintf "Logged on as %s, " user)
            yield aHref Path.Account.logoff (text "Log off")
        | None ->
            yield aHref Path.Account.logon (text "Log on")
    ]

let index partUser container = 
    html [ head [ title "Suave Music Store"
                  cssLink "/Site.css" ]
           body [ divId "header" [
                        h1 (aHref Path.home (text "F# Suave Music Store"))        
                        partNav
                        partUser
                    ]
                  divId "main" container
                  divId "footer" [ text "built with "
                                   aHref "http://fsharp.org" <| text "F#"
                                   text " and "
                                   aHref "http://suave.io" <| text "Suave.IO" ] ] ]
    |> xmlToString

let store genres = 
    [ h2 "Browse Genres"
      p [ text (sprintf "Select from %d genres:" (List.length genres)) ]
      ul [ for g in genres -> li (aHref (Path.Store.browse |> Path.withParam (Path.Store.browseKey, g)) (text g)) ] ]

let notFound = 
    [ h2 "Page not found"
      p [ text "Could not find the requested resource" ]
      p [ text "Back to "
          aHref Path.home (text "Home") ] ]

let table x = tag "table" [] (flatten x)
let th x = tag "th" [] (flatten x)
let tr x = tag "tr" [] (flatten x)
let td x = tag "td" [] (flatten x)

let truncate k (s : string) = 
    if s.Length > k then s.Substring(0, k - 3) + "..."
    else s

let manage (albums : Db.AlbumDetails list) = 
    [ h2 "Index"
      p [ aHref Path.Admin.createAlbum (text "Create new") ]
      table [ yield tr [ for t in [ "Artist"; "Title"; "Genre"; "Price" ] -> th [ text t ] ]
              for album in albums -> 
                  tr [ for t in [ truncate 25 album.Artist
                                  truncate 25 album.Title
                                  album.Genre
                                  formatDec album.Price ] -> td [ text t ]
                       yield td [ 
                        aHref (sprintf Path.Admin.editAlbum album.AlbumId) (text "Edit")
                        text " | "
                        aHref (sprintf Path.Store.details album.AlbumId) (text "Details")
                        text " | "
                        aHref (sprintf Path.Admin.deleteAlbum album.AlbumId) (text "Delete")] ] ] ]

let strong s = tag "strong" [] (text s)

let deleteAlbum albumTitle = 
    [ h2 "Delete Confirmation"
      p [ text "Are you sure you want to delete the album titled"
          br
          strong albumTitle
          text "?" ]
      form [ submitInput "Delete" ]
      div [ aHref Path.Admin.manage (text "Back to list") ] ]

let createAlbum genres artists = 
    [ h2 "Create"
      renderForm { Form = Form.album
                   Fieldsets = 
                       [ { Legend = "Album"
                           Fields = 
                               [ { Label = "Genre"
                                   Xml = selectInput (fun f -> <@ f.GenreId @>) genres None }
                                 { Label = "Artist"
                                   Xml = selectInput (fun f -> <@ f.ArtistId @>) artists None }
                                 { Label = "Title"
                                   Xml = input (fun f -> <@ f.Title @>) [] }
                                 { Label = "Price"
                                   Xml = input (fun f -> <@ f.Price @>) [] }
                                 { Label = "Album Art Url"
                                   Xml = input (fun f -> <@ f.ArtUrl @>) [ "value", "/placeholder.gif" ] } ] } ]
                   SubmitText = "Create" }
      div [ aHref Path.Admin.manage (text "Back to list") ] ]

let editAlbum (album : Db.Album) genres artists = 
    [ h2 "Edit"
      renderForm { Form = Form.album
                   Fieldsets = 
                       [ { Legend = "Album"
                           Fields = 
                               [ { Label = "Genre"
                                   Xml = selectInput (fun f -> <@ f.GenreId @>) genres (Some(decimal album.GenreId)) }
                                 { Label = "Artist"
                                   Xml = selectInput (fun f -> <@ f.ArtistId @>) genres (Some(decimal album.ArtistId)) }
                                 { Label = "Title"
                                   Xml = input (fun f -> <@ f.Title @>) [ "value", album.Title ] }
                                 { Label = "Price"
                                   Xml = input (fun f -> <@ f.Price @>) [ "value", formatDec album.Price ] }
                                 { Label = "Album Art Url"
                                   Xml = input (fun f -> <@ f.ArtUrl @>) [ "value", "/placeholder.gif" ] } ] } ]
                   SubmitText = "Save Changes" }
      div [ aHref Path.Admin.manage (text "Back to list") ] ]

let logon msg = 
    [ h2 "Log On"
      p [ text " Please enter your user name and password." ]
      divId "logon-message" [ text msg ]
      renderForm { Form = Form.logon
                   Fieldsets = 
                       [ { Legend = "Account Information"
                           Fields = [ { Label = "User Name"
                                        Xml = input (fun f -> <@ f.Username @>) [] } 
                                      { Label = "Password"
                                        Xml = input (fun f -> <@ f.Password @>) [] } ] }]
                   SubmitText = "Log On" } ]

