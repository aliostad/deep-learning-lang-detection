module Settings

open System
open System.Net.Http

type ConsumerSettings = {
    KafkaUrl : string
    Topic : string
    ConsumeTimeout : TimeSpan
}

let baseConfigurationKey = "Microservices/Consumer"

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
        KafkaUrl = getSettingFromConsul "KafkaBroker"
        Topic = getSettingFromConsul "KafkaTopic"
        ConsumeTimeout = getSettingFromConsul "ConsumeTimeout" |> Double.Parse |> TimeSpan.FromMilliseconds
    }

    printfn "Read settings item from Consul %A" item
    item