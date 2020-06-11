namespace MarsDemo

open WebSharper

// NASA DOCS: https://api.nasa.gov/api.html#assets
module Mars =

  open FSharp.Data
  open System

  type MarsSchema = JsonProvider<"MarsSchema.json">
  
  let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
  
  type Photo =
    {
      Description : string
      PhotoUrl: string
    }

  [<Rpc>]
  let get (sol:string) =
    
    match Int32.TryParse(sol) with
    | false, _ -> async.Return [||]
    | true, sol ->

      let headers =
        [|
          "Accept", "application/json"
        |]

      let query =
        [
          "sol", string sol
          "api_key", "DEMO_KEY"
        ]

      async {
        try
          let! json = Http.AsyncRequestString(url, headers = headers, query = query)
          let photos = MarsSchema.Parse json
          let grouped =
            photos.Photos            
            |> Seq.map (fun x -> {Description = sprintf "%s : %s" x.Rover.Name x.Camera.Name; PhotoUrl = x.ImgSrc})
            |> Seq.groupBy (fun x -> x.Description)
            |> Seq.map (fun (g,xs) -> g, xs |> Seq.toArray)
            |> Seq.toArray
          return grouped
        with e -> return [||]
      }
