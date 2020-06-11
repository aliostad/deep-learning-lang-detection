module Http

open Git
open RDF
open Suave
open Suave.Web
open Suave.Http
open Suave.Http.Successful
open Suave.Http.RequestErrors
open Suave.Http.Applicatives
open Suave.Types

let parts = function 
    | Repository r -> 
        (*Match file version entities and return content*)
        let content : WebPart = 
            url_scan "/%s/tree/%s/commit/%s/%s" (fun (rn, b, c, p) -> 
                let b = r.Branches.[b]
                OK "")
        choose [ content
                 NOT_FOUND "No handler" ]

let serve r p = 
    parts r |> web_server { default_config with bindings = 
                                                    [ HttpBinding.mk' HTTP 
                                                          ("0.0.0.0") p ]
                                                error_handler = 
                                                    default_error_handler
                                                listen_timeout = 
                                                    System.TimeSpan.FromMilliseconds 
                                                        2000.
                                                ct = 
                                                    Async.DefaultCancellationToken
                                                buffer_size = 2048
                                                max_ops = 100 }
