namespace OtrWeb

open OtrWeb.Options
open Microsoft.Extensions.Options
open Newtonsoft.Json.Linq
open System
open System.Net
open System.Net.Http
open System.Net.Http.Headers
open System.Text.RegularExpressions

type MovieDbApi(options : IOptions<MovieDbOptions>)=

    let apiClient = new HttpClient()
    member this.Options = options.Value

    member private this.Get url = async {
        let requestUrl = sprintf "%s%s&api_key=%s" this.Options.ApiUrl url this.Options.ApiKey
        let request = new HttpRequestMessage(HttpMethod.Get, Uri(requestUrl))
        let! response = ((apiClient.SendAsync(request)) |> Async.AwaitTask)

        let! responseString = ((response.Content.ReadAsStringAsync()) |> Async.AwaitTask)
        return JObject.Parse(responseString)
    }

    member this.SearchMovie name = async {
        let movieName = Uri.EscapeDataString(name)
        let! searchResponse = this.Get ("/search/movie?query=" + movieName)

        let results = searchResponse.["results"]
        let movies = results |> Seq.map(fun r -> Movie(r.Value<string>("original_title"), r.Value<string>("release_date"), [||]))

        return movies
    }