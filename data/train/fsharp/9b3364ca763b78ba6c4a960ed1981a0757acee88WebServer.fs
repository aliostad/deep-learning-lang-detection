module Api.WebServer

open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.Writers

let start connectionString =
    let app = 
        choose [
            GET >=> choose [
                path "/api/wines" >=> Wines.getAllWines connectionString
            ]
            POST >=> choose [
                path "/api/wines/" >=> Wines.addNewWine
            ]
        ]
    let config =
        { defaultConfig with 
            bindings = [ HttpBinding.createSimple HTTP "0.0.0.0" 8083 ]
        }
    
    startWebServer config app
