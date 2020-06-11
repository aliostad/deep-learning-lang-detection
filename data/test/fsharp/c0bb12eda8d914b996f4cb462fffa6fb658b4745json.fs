module json
#if INTERACTIVE
#r "../packages/FSharp.Data/lib/net40/FSharp.Data.dll"
#endif

open FSharp.Data

type Weather = JsonProvider<"http://api.openweathermap.org/data/2.5/weather?id=2172797&appid=2de143494c0b295cca9337e1e96b00e0">

let data1 = Weather.Load "http://api.openweathermap.org/data/2.5/weather?q=Poznan&units=metric&appid=2de143494c0b295cca9337e1e96b00e0"
let data2 = Weather.Load "http://api.openweathermap.org/data/2.5/weather?q=Austin,au&units=metric&appid=2de143494c0b295cca9337e1e96b00e0"

let display (w : Weather.Root) =
    printfn "Country: %s\tCity: %s\tTemp: %A\tPressure: %A" w.Sys.Country w.Name w.Main.Temp w.Main.Pressure

display data1
display data2