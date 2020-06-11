namespace YogRobot

[<AutoOpen>]
module TokenServiceClient = 
    open Newtonsoft.Json
    
    let GetMasterTokenWithKey(key : MasterKeyToken) = 
        let apiUrl = "api/tokens/master"
        Agent.GetWithMasterKey key apiUrl
    
    let GetMasterToken masterKey = async { let! response = GetMasterTokenWithKey masterKey |> Agent.ContentOrFail
                                           return JsonConvert.DeserializeObject<string>(response) }
    
    let GetDeviceGroupTokenWithKey botKey deviceGroupId = 
        let (DeviceGroupId deviceGroupId) = deviceGroupId
        let apiUrl = "api/tokens/device-group"
        Agent.GetWithDeviceGroupKey botKey (DeviceGroupId deviceGroupId) apiUrl
    
    let GetDeviceGroupToken botKey deviceGroupId = async { let! response = GetDeviceGroupTokenWithKey botKey deviceGroupId |> Agent.ContentOrFail
                                           return JsonConvert.DeserializeObject<string>(response) }
    
    let GetSensorTokenWithKey sensorKey deviceGroupId = 
        let (DeviceGroupId deviceGroupId) = deviceGroupId
        let apiUrl = "api/tokens/sensor"
        Agent.GetWithSensorKey sensorKey (DeviceGroupId deviceGroupId) apiUrl
    
    let GetSensorToken sensorKey deviceGroupId =
        async { let! response = GetSensorTokenWithKey sensorKey deviceGroupId |> Agent.ContentOrFail
                return JsonConvert.DeserializeObject<string>(response) }
