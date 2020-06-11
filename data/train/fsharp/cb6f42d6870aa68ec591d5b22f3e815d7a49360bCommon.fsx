#I __SOURCE_DIRECTORY__
#r "../packages/Http.fs-prerelease/lib/net40/HttpFs.dll"
#r "../packages/Newtonsoft.Json/lib/net45/Newtonsoft.Json.dll"

#load "../StockFighter.API/WebSockets.fs"
#load "../StockFighter.API/DtoTypes.fs"
#load "../StockFighter.API/Settings.fs"
#load "../StockFighter.API/DomainTypes.fs"
#load "../StockFighter.API/Functions.fs"

#r "System.Core.dll"
#r "System.dll"
#r "System.Numerics.dll"

open System
open StockFighter.Api
open StockFighter.Api.Settings
open StockFighter.Api.Stocks

let apiKeyFile = @"C:\Users\james\Dropbox\dev\stockfighter\apikey.txt"
let logFileLocation = @"C:\Users\james\Documents"
let instanceSettingsFile = @"instance_settings.txt" //FSI in Visual Studio will put this in the user's temp folder
let apiKey = IO.File.ReadAllText(apiKeyFile)

let startLevel logger level = async {
    let! response = GamesMaster.startLevel logger apiKey level
    let settings = createSettings apiKey response
    IO.File.WriteAllText(instanceSettingsFile, (serializeSettings settings));
    return settings
}

//for less typing in fsi
let sync f =
    f |> Async.RunSynchronously

let testStockTicker logger =
    let settings = createTestSettings apiKey
    StockTicker.create logger settings.Account settings.Venue

let createLogger () =
    let logFile = sprintf "%s/stockfighter_log_%s.txt" logFileLocation (DateTime.UtcNow.ToString("yy-MM-dd-HH-mm-ss"))
    let logWriter = new IO.StreamWriter(logFile) //using from fsi so not disposing

    let log (msg:string) = 
        logWriter.WriteLine(msg)
        logWriter.Flush()

    log