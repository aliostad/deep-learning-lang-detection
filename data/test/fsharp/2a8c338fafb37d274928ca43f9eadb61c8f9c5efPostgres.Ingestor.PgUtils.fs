module Postgres.Ingestor.PgUtils

open Fable.Core.JsInterop
open Fable.Import.Pg
open Fable.Import
open Fable.PowerPack.Fetch
open Fable.PowerPack
open Postgres.Ingestor.Env

///  Creates a connection to the chroma DB.
///  Uses the passed in npm config settings.
let createConnection () =
  let config = createEmpty<PoolConfig>
 
  config.user <- Some env.npm_package_config_db_user
  config.database <- Some env.npm_package_config_db_name
  config.host <- Some env.npm_package_config_db_host
  config.password <- Some env.npm_package_config_db_pass
  config

let createPool config =
  Pg.Pool.Create config
let createClient config =
  Pg.Client.Create config

type ApiKey = {
  username: string;
  key: string
}

let getApiKey (pool:Pool):JS.Promise<ApiKey> =
  pool.query("SELECT * from api_key();")
    |> Promise.map (fun x -> Array.head x.rows)
    |> Promise.catch (fun _ -> failwith "Could not not find api key, check your database")

let createApiAuthorizationHeader (x:ApiKey) =
  (sprintf "Authorization: apikey %s:%s" x.username x.key)

let getApiKeyAuthorizationHeader (pool:Pool):JS.Promise<string> =
  getApiKey(pool)
    |> Promise.map createApiAuthorizationHeader
  