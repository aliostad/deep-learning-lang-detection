namespace DataProviders

module private BingApi =
    open System.Net
    open System.Net.Http
    open Newtonsoft.Json
    open System
    open System.IO

    let api = "1Op/dRVrnhPR1HuVXYPxeD/1n8jUqNqoW+BGAbjjFro"

    type Response = { d: D }
    and D = { results: Result array }
    and Result = { Thumbnail: Thumbnail }
    and Thumbnail = { MediaUrl: string }

    let get search =
        use handler = new HttpClientHandler(Credentials = new NetworkCredential(api, api))
        use client = new HttpClient(handler)
        let url = sprintf "https://api.datamarket.azure.com/Bing/Search/Image?$top=5&$format=json&Query=%%27%s%%27" search

        async {
            let! response = Async.AwaitTask(client.GetAsync(url))
            return! Async.AwaitTask(response.Content.ReadAsStringAsync())
        }

    let parse str = 
        JsonConvert.DeserializeObject<Response>(str)
        |> fun x -> x.d.results 
        |> Array.map (fun r -> r.Thumbnail.MediaUrl)

    let getImg uri =
        let url = new Uri(uri)
        use client = new WebClient()
        async {
            let! data = client.DownloadDataTaskAsync(url) |> Async.AwaitTask 
            return new MemoryStream(data) :> Stream
        }

module BingImageProvider =

    let id = { name = "bing"; icon = None }
    
    let suggest str = async {
        let! content = str |> BingApi.get 
        let! imgs = 
            content 
            |> BingApi.parse 
            |> Seq.map BingApi.getImg
            |> Async.Parallel

        return { Suggestions.Nothing id with images = Some (imgs |> Array.toList) }}
