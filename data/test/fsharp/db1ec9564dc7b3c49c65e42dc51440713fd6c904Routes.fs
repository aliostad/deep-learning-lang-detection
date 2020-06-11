module Speedtest.Api.Host.Routes

open System
open Microsoft.AspNetCore.Http
open Giraffe.HttpHandlers
open Giraffe.Tasks
open Giraffe.HttpContextExtensions

open Speedtest.Api.Model.SpeedtestModel.Speedtest
open Speedtest.Api.Host.Storage

let table = cloudTable

let getSpeedtests (next : HttpFunc) (ctx : HttpContext) =
    task {
        return! json (getSpeedtests (allSpeedtests table)) next ctx
    }

let postSpeedtests (next : HttpFunc) (ctx : HttpContext) =
    task {
        let! speedtest = ctx.BindJson<Speedtest>()
        return! json (postSpeedtests (storeSpeedtest table) speedtest) next ctx
    }

let routeHandler : HttpHandler =
    choose [
        route "/speedtests" >=>
            choose [
                GET >=> getSpeedtests
                POST >=> postSpeedtests]
        setStatusCode 404 >=> text "Not Found"
    ]
