module StockFighter.Api.Settings

open Newtonsoft.Json

type Settings = {
    ApiKey: string
    Account: string
    Venue: string
    Symbol: string
    InstanceId: int
}

let createSettings apiKey (response : StartGameResponse) =
    {
        ApiKey = apiKey;
        Account = response.Account;
        Venue = response.Venues |> Seq.head;
        Symbol = response.Tickers |> Seq.head
        InstanceId = response.InstanceId
    }

let createTestSettings apiKey =
    { ApiKey = apiKey; Account = ""; Venue = "TESTEX"; Symbol = "FOOBAR"; InstanceId = 0 }

let serializeSettings settings =
    JsonConvert.SerializeObject(settings)

let deserializeSettings json =
    JsonConvert.DeserializeObject<Settings>(json)