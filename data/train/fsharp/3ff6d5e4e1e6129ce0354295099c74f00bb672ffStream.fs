[<RequireQualifiedAccess>]
module GetStream
open Chessie.ErrorHandling
open Stream

type Config = {
  ApiSecret : string
  ApiKey : string
  AppId : string
}

type Client = {
  Config : Config
  StreamClient : StreamClient
}

let newClient config = {
  StreamClient = 
    new StreamClient(config.ApiKey, config.ApiSecret)
  Config = config
}

let userFeed getStreamClient userId =
  getStreamClient.StreamClient.Feed("user", userId)
let mapNewActivityResponse response =
  match response with
  | Choice1Of2 _ -> ok ()
  | Choice2Of2 ex -> fail ex