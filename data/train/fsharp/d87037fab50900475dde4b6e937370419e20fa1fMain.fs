open System

type Config = {
  ApiKey: string
  Username: string
}

type Scrobble = {
  ArtistName: string
  ArtistMbid: string
  AlbumName: string
  AlbumMbid: string
  TrackName: string
  TrackMbid: string
  Time: DateTime
  Loved: bool
}

type Page = {
  TotalPages: int
  Scrobbles: Scrobble[]
}

let getUri (config: Config) (limit: int) (page: int) : Uri =
  let baseUri = "https://ws.audioscrobbler.com/2.0"
  let query = [
        "method=user.getrecenttracks"
        "user=" + config.Username
        "api_key=" + config.ApiKey
        "format=json"
        "extended=1"
        "limit=" + limit.ToString()
        "page=" + page.ToString()
      ]
  new Uri(baseUri) // TODO: include query part.

[<EntryPoint>]
let main argv =
  printfn "Hi"
  0
