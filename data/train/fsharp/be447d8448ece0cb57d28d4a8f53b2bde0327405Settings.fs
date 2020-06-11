module Settings

open System
open System.Net.Http

type ProducerSettings = {
    Broker : string
    Topic : string
    Timeout : int
}

let baseConfigurationKey = "Microservices/Producer"

let getSettingFromConsul key = 
    async {
        use httpClient = new HttpClient()

        let! response = 
            sprintf "http://consul:8500/v1/kv/%s/%s?raw" baseConfigurationKey key 
            |> httpClient.GetAsync 
            |> Async.AwaitTask

        return! response.Content.ReadAsStringAsync() |> Async.AwaitTask
    } |> Async.RunSynchronously

let getSettingsItem() =
    let item = {
        Broker = getSettingFromConsul "KafkaBroker"
        Topic = getSettingFromConsul "KafkaTopic"
        Timeout = getSettingFromConsul "Timeout" |> Int32.Parse
    }

    printfn "Read settings item from Consul %A" item
    item