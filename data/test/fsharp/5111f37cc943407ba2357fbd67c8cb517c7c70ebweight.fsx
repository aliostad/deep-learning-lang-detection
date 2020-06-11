// Before running any code, invoke Paket to get the dependencies.
//
// You can either build the project (Ctrl + Alt + B in VS) or run
// '.paket/paket.bootstrap.exe' and then '.paket/paket.exe install'
// (if you are on a Mac or Linux, run the 'exe' files using 'mono')
//
// Once you have packages, use Alt+Enter (in VS) or Ctrl+Enter to
// run the following in F# Interactive. You can ignore the project
// (running it doesn't do anything, it just contains this script)
#load "packages/FsLab/FsLab.fsx"

#I "packages/Google.Apis/lib/net45"
#I "packages/Google.Apis.Core/lib/net45"
#I "packages/Google.Apis.Auth/lib/net45"
#I "packages/Google.Apis.Fitness.v1/lib/portable-net45+sl50+netcore45+wpa81+wp8"
#I "packages/Zlib.Portable.Signed/lib/portable-net4+sl5+wp8+win8+wpa81+MonoTouch+MonoAndroid"

#r "Google.Apis.dll"
#r "Google.Apis.Core.dll"
#r "Google.Apis.Auth.dll"
#r "Google.Apis.Auth.PlatformServices.dll"
#r "Google.Apis.Fitness.v1.dll"
#r "Zlib.Portable.dll"

open System
open System.IO
open System.Threading
open System.Threading.Tasks

open FSharp.Data
open Deedle
open XPlot.GoogleCharts
//open XPlot.GoogleCharts.Deedle

open Google.Apis.Auth.OAuth2
open Google.Apis.Services
open Google.Apis.Fitness.v1
open Google.Apis.Fitness.v1.Data

open FSharp.Linq.NullableOperators

type ClientSecretsPath = ClientSecretsPath of string

let secrets_path = ClientSecretsPath "client_secret_102940999636-r4h5p0qo7vqu3nrpotv194vf1itmkks7.apps.googleusercontent.com.json"

let unix_time (millis: int64) =
    (new DateTimeOffset(1970, 1, 1, 0, 0, 0, TimeSpan.FromHours(0.0))).AddMilliseconds(float(millis))

let local_time millis = (unix_time millis).ToLocalTime()

let unix_millis (date: DateTimeOffset) =
    let diff = date.ToUniversalTime() - new DateTimeOffset(1970, 1, 1, 0, 0, 0, TimeSpan.FromHours(0.0))
    int64(diff.TotalMilliseconds)

let getUserCredential (ClientSecretsPath path) =
    GoogleWebAuthorizationBroker.AuthorizeAsync(
        File.OpenRead(path),
        [ FitnessService.Scope.FitnessBodyRead; FitnessService.Scope.FitnessActivityRead ],
        "user",
        CancellationToken.None)
        |> Async.AwaitTask

let initializeFitness credential =
    new FitnessService(new BaseClientService.Initializer(HttpClientInitializer = credential))

let fitness = Async.RunSynchronously <| async {
    let! user = getUserCredential secrets_path
    
    return initializeFitness user
}

let aggregateResponse = Async.RunSynchronously <| async {
    let today = (new DateTimeOffset(DateTime.Today)).AddDays(1.0)
    
    let weight_request = new AggregateRequest(
                            AggregateBy = [|
                                new AggregateBy(DataTypeName = "com.google.weight");
                                new AggregateBy(DataTypeName = "com.google.calories.expended")
                            |],
                            StartTimeMillis = (Nullable << unix_millis <| today.AddDays(float(1 - today.DayOfYear))),
                            EndTimeMillis = (Nullable << unix_millis <| today),
                            BucketByTime = new BucketByTime(DurationMillis = Nullable(24L * 3600L * 1000L))
    )
    
    return! fitness.Users.Dataset.Aggregate(weight_request, "me").ExecuteAsync() |> Async.AwaitTask    
}

type BodyMeasurement =
    | Weight of Date: DateTimeOffset * Weight: float
    | CaloriesExpended of Date: DateTimeOffset * CaloriesExpended: float

let wc_data = seq {
    for b in aggregateResponse.Bucket do
        let date = local_time(b.StartTimeMillis.GetValueOrDefault(0L))
        if b.Dataset <> null then
            for d in b.Dataset do
                if d.Point <> null then
                    for p in d.Point do
                        // for calories expended there will be single value, for weight take first (average) of three
                        let value = Seq.head(p.Value).FpVal.GetValueOrDefault(0.0)
                        match p.DataTypeName with
                        | "com.google.calories.expended" -> yield CaloriesExpended(date, value)
                        | "com.google.weight.summary" -> yield Weight(date, value)
                        | _ -> ()
}

let weight_data =
    wc_data
    |> Seq.choose (fun item -> match item with
                               | Weight(_, _) -> Some item
                               | _ -> None)
    |> List.ofSeq

let calorie_data =
    wc_data
    |> Seq.choose (fun item -> match item with
                               | CaloriesExpended(_, _) -> Some item
                               | _ -> None)
    |> List.ofSeq

let activityResponse = Async.RunSynchronously <| async {
    let today = (new DateTimeOffset(DateTime.Today)).AddDays(1.0)
    
    let weight_request = new AggregateRequest(
                            AggregateBy = [| new AggregateBy(DataTypeName = "com.google.activity.segment") |],
                            StartTimeMillis = (Nullable << unix_millis <| today.AddDays(float(1 - today.DayOfYear))),
                            EndTimeMillis = (Nullable << unix_millis <| today),
                            BucketByTime = new BucketByTime(DurationMillis = Nullable(24L * 3600L * 1000L))
    )
    
    return! fitness.Users.Dataset.Aggregate(weight_request, "me").ExecuteAsync() |> Async.AwaitTask    
}

[<Literal>]
let GoogleFitActivityRunning = 8

let r_data = seq {
    for b in activityResponse.Bucket do
    if b.Dataset <> null then
        for d in b.Dataset do
            if d.Point <> null then
                for p in d.Point do
                    if p.DataTypeName = "com.google.activity.summary" then
                        let [activity; duration; num_segments] = p.Value |> List.ofSeq
                        if activity.IntVal ?= GoogleFitActivityRunning && duration.IntVal ?>= 25 * 60 * 1000 then
                            yield (b.StartTimeMillis.GetValueOrDefault(0L), duration.IntVal.GetValueOrDefault(0))
}

let running_data =
    r_data
    |> Seq.map (fun (d, dur) -> (local_time(d), TimeSpan.FromMilliseconds(float(dur))))
    |> List.ofSeq



let alpha = 0.7

let weight_data_ema =
    Seq.scan (fun (Weight(unused, state)) (Weight(date, weight)) -> Weight(date, alpha * weight + (1.0 - alpha) * state))
    <| List.head weight_data
    <| List.tail weight_data

let data = [ calorie_data :> seq<_>; weight_data :> seq<_>; weight_data_ema ]
           |> List.map (fun data -> seq { for item in data ->
                                            match item with
                                            | Weight(d, w) -> (d.Date, w)
                                            | CaloriesExpended(d, c) -> (d.Date, c)  
                                        })

data
|> Chart.Combo
|> Chart.WithLabels ["Calories Expended"; "Weight"; "Trend"]
|> Chart.WithOptions (Options(
                        curveType = "function",
                        interpolateNulls = true,
                        theme = "maximized",
                        //trendlines = [| Trendline(); Trendline(``type`` = "linear"); Trendline() |],
                        colors = [| "#f6e7cb"; "#dd9787"; "#74d3ae"; "#678d58"; "#a6c48a" |],
                        series = [|
                            Series("line", targetAxisIndex = 1);
                            Series("scatter", pointSize = 3);
                            Series("line");
                            Series("scatter", targetAxisIndex = 2)
                        |],
                        vAxes = [|
                            Axis(title = "Weight");
                            Axis(title = "Calories", ticks = [| 1000; 2000; 3000; 4000; 5000 |]);
                            Axis(title = "X")
                        |]                        
))

(*
https://www.googleapis.com/auth/fitness.body.read
com.google.weight	The user's weight.	Body	weight (float—kg)

https://www.googleapis.com/auth/fitness.activity.read
com.google.calories.expended	Total calories expended over a time interval.	Activity	calories (float—kcal)
*)