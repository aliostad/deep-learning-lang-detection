namespace ActuarialMathematics.WebAPI

open System.Web.Http
//open System.ServiceModel.Web
open System
open Newtonsoft.Json
open FSharp.Collections.ParallelSeq
open ActuarialMathematics.FunctionsLibrary

type gl_data = {t: int; mortality: float}

type gl_At_Age = {age: int; GLData: gl_data list}

[<RoutePrefix ("api/SurvivalModels")>]
type SurvivalModelsController() =
    inherit ApiController()

    // GET: api/SurvivalModels/Gompertz_law?B=B&c=c&x=x
    [<HttpGet>]
    [<Route ("Gompertz_law?B={b}&c={c}&x={x}")>]
    member __.Gompertz_law (b, c, x)  =  SurvivalModels.Gompertz_law (b, c) x

    [<HttpGet>]
    member __.MyTest() =
        true
       
