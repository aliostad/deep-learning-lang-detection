module WebApplication

(*#################

    Dies ist Ihre Anwendung.
    Hier orchestrieren Sie die Infrastruktur dieser WebApp

    Aufgaben:
    |_| Asynchroner Rückkanal für Javascript, um notifications in die Ui pushen zu können. (If you dare)

#################*)


open Suave
open Suave.Web
open Suave.Http
open Suave.Http.Applicatives
open Suave.Http.Writers
open Suave.Http.Files
open Suave.Http.Successful
open Suave.Types
open Suave.Session
open Suave.Log

open FDDD
open Domain
open CommandHandlers
open Html

open ToyInMemoryEventStore

let logger = Loggers.sane_defaults_for Debug

let getValue (field : string) (raw_form : string) =
    let data =
        raw_form.Split '&'
        |> Array.map (fun s -> let [|key; value|] (* Diese Warnung regt zum nachdenken an *) = s.Split '=' in key, value)
        |> dict
    data.[field]

let eventHandler = new EventHandler()
let store =
    create()
    |> subscribe eventHandler.Handle


let handle = Commandhandler.create (readStream store) (appendToStream store)


let domainRoutes = 
    [
        GET >>= choose
            [ url "/warenkorb" >>= request (fun x ->
                        OK (Html.Frame "FDDD"
                                    (Html.combine (Html.Produkte eventHandler.Eintraege) Html.Warenkorb_formular)))
              url "/lager" >>= 
                        OK "" ];

        POST >>= choose
            [ url "/warenkorb_anlegen" >>= request (fun x -> 
                        handle (Lege_Warenkorb_an { Warenkorb = Warenkorb 1; Kunde = (getValue "kunde" (ASCII.to_string' x.raw_form)) })
                        Redirection.redirect "/warenkorb") ;
            ]; 
    ]
    
let basicRoutes =
    [
        log logger log_format >>= never
        GET >>= url "/" >>= OK (Html.Frame "FDDD" Html.Link_Warenkorb)
        GET >>= url "/redirect" >>= Redirection.redirect "/redirected"
        GET >>= url "/redirected" >>=  OK "You have been redirected."
        GET >>= browse
        GET >>= dir
        RequestErrors.NOT_FOUND "Found no handlers"
    ]

let routes = List.concat [ domainRoutes; basicRoutes ]