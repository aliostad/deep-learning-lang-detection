#r "../packages/FSharp.Data/lib/net40/FSharp.Data.dll"

module OpenWeatherMapData =
    open FSharp.Data

    type WeatherForecastData = JsonProvider<"http://api.openweathermap.org/data/2.5/forecast/daily?q=London&cnt=1&appid=1f7bf8a24c17cad9e14f4f9a3c29e911">

    let getData city = async {
        let! forecastResult = 
            sprintf "http://api.openweathermap.org/data/2.5/forecast/daily?q=%s&cnt=16&appid=1f7bf8a24c17cad9e14f4f9a3c29e911" city
            |> WeatherForecastData.AsyncLoad
        return forecastResult
    }
