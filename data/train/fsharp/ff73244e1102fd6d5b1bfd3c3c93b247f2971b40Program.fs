// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.
open FSharp.Data
open HttpClient
type ApiStatus = FSharp.Data.JsonProvider<"ApiStatus.json">
type Venues = FSharp.Data.JsonProvider<"Venues.json">
type Level = FSharp.Data.JsonProvider<"Level.json">
let authget url key = 
    createRequest Get url
    |> withHeader (Custom {name="X-Starfighter-Authorization";value=key})
    |> getResponseBody
    |> fun t -> new System.IO.StringReader(t)
let authpost url key = 
    createRequest Post url
    |> withHeader (Custom {name="X-Starfighter-Authorization";value=key})
    |> getResponseBody
    |> fun t -> new System.IO.StringReader(t)
let complete_level_one key =
    //start the level
    printfn "Starting level One"
    let responsestr = authpost "https://www.stockfighter.io/gm/levels/first_steps" key |> fun t -> t.ReadToEnd()
    printfn "%s" (responsestr)
    let t = Level.Load(new System.IO.StringReader(responsestr))
    printfn "Account number: %s" t.Account
    printfn "Instance ID:    %i" t.InstanceId
    printfn "Tickers:        "; (t.Tickers |> Array.iter (fun t -> printfn "    %s" t))
    printfn "Venues:         "; (t.Venues  |> Array.iter (fun t -> printfn "    %s" t))
    printfn "Instructions    %s" t.Instructions.Instructions
    printfn "              %s"  t.Instructions.OrderTypes
    //now lets get the order book for the stock
    while true do
        authget <| sprintf "https://api.stockfighter.io/ob/api/venues/%s/stocks/%s" t.Venues.[0] t.Tickers.[0] <| key |> fun t -> printfn "%s" <| t.ReadToEnd()
        System.Threading.Thread.Sleep(500)
    //end the level
    authpost <| sprintf "https://www.stockfighter.io/gm/instances/%i/stop" t.InstanceId <| key |> ignore
[<EntryPoint>]
let main _ = 
    //get the api key
    let key =
        try
            printfn "Getting API key"
            System.IO.File.ReadAllLines("APIkey.txt").[0] |> Some
        with _ -> 
            None
    match key with
    |Some(key) ->
        printfn "using API key: -%s-" key
        printfn "Testing if API is up"
        //lets test if the API is up
        let resp = ApiStatus.Load("https://api.stockfighter.io/ob/api/heartbeat")
        if resp.Ok=true then
            printfn "The API is up"
            complete_level_one key
        else
            printfn "The API is down - error is %s" resp.Error
        ()
    |None -> 
        printfn "Failed to get API key - quitting"
    //
    printfn "Done"
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    System.Console.ReadKey() |> ignore
    0 // return an integer exit code
