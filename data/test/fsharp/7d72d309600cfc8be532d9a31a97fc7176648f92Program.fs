module Program

open Suave
open Suave.Http
open Suave.Successful
open Suave.RequestErrors
open Suave.Operators
open Suave.Filters
open System.Text
open InMemory
open CommandApi
open CafeApp.Result
let commandApiHandler eventStore (context: HttpContext) = async {
    let payload = 
        Encoding.UTF8.GetString context.request.rawForm
    let! response = 
        handleCommandRequest
            inMemoryQueries eventStore payload            
    match response with
    | Ok (state, events) -> 
        return! OK (sprintf "%A" state) context
    | Failure error -> 
        return! BAD_REQUEST error.Message context 
}

let commandApi eventStore = 
    path "/command"
        >=> POST
        >=> commandApiHandler eventStore

[<EntryPoint>]
let main argv =
    let app =
        let eventStore = inMemoryEventStore ()
        choose [
            commandApi eventStore
        ]
    let cfg = 
        { defaultConfig with
            bindings = [ HttpBinding.createSimple HTTP "0.0.0" 8083 ] }
    startWebServer cfg app
    0