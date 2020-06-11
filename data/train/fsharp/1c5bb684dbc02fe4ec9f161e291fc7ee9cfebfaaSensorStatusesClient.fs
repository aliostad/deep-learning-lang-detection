namespace YogRobot

[<AutoOpen>]
module SensorStatusesClient = 
    open Newtonsoft.Json
    
    let GetSensorStatusesResponse token = 
        let apiUrl = "api/sensors"
        Agent.Get token apiUrl
    
    let GetSensorStatuses token = 
        let response = GetSensorStatusesResponse token
        async { let! content = response |> Agent.ContentOrFail
                let result = JsonConvert.DeserializeObject<List<SensorStatus>>(content)
                return result |> Seq.toList }
    
    let GetSensorHistoryResponse token sensorId = 
        let apiUrl = sprintf "api/sensor/%s/history" sensorId
        Agent.Get token apiUrl
    
    let GetSensorHistory token sensorId = 
        let response = GetSensorHistoryResponse token sensorId
        async { let! content = response |> Agent.ContentOrFail
                return JsonConvert.DeserializeObject<SensorHistory>(content) }
