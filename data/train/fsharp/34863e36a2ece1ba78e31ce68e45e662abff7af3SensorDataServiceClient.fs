namespace YogRobot

[<AutoOpen>]
module SensorDataServiceClient = 
    open System.Globalization
    open Microsoft.FSharp.Data.UnitSystems.SI.UnitSymbols
    
    let PostSensorData key deviceGroupId (sensorEvent : SensorData) = 
        let apiUrl = "api/sensor-data"
        async { return! Agent.PostWithSensorKey key deviceGroupId apiUrl sensorEvent }

    let PostMeasurement key deviceGroupId deviceId (measurement : Measurement) =        
        let sensorEvent = 
          { event = "sensor data"
            gatewayId = ""
            channel = ""
            sensorId = deviceId
            sensorName = ""
            data = []
            batteryVoltage = ""
            rssi = "" }
        let event = sensorEvent |> WithMeasurement(measurement)
        async { return! PostSensorData key deviceGroupId event }
