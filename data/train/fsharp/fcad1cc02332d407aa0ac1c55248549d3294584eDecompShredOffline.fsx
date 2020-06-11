
#r @"C:\Users\inter\OneDrive\Projects(Comp)\Dev_2017\IOT_2017\iot-samples-master\DecompressShred\fsharp\packages\WindowsAzure.ServiceBus.4.0.0\lib\net45-full\Microsoft.ServiceBus.dll"
//#r "Microsoft.ServiceBus.dll"
#r "System.Runtime.Serialization.dll"

open System
open System.Text
open System.IO
open System.Diagnostics
open System.IO.Compression
open Microsoft.ServiceBus.Messaging
open System.Runtime.Serialization

let decompress (data : string) = 
    let gzipBuffer = Convert.FromBase64String(data)
    (   use memoryStream = new MemoryStream()
        let dataLength = BitConverter.ToInt32(gzipBuffer, 0)
        memoryStream.Write(gzipBuffer, 4, gzipBuffer.Length - 4)
        let buffer = Array.zeroCreate<byte> (int(dataLength))
        memoryStream.Position <- 0L
        (   use zip = new GZipStream(memoryStream, CompressionMode.Decompress)
            zip.Read(buffer, 0, buffer.Length) |> ignore)
        Encoding.UTF8.GetString(buffer)
    )

let compress (data : string) = 
            let buffer = Encoding.UTF8.GetBytes(data)
            let ms = new MemoryStream()
            (   use zip = new GZipStream(ms, CompressionMode.Compress, true)
                zip.Write(buffer, 0, buffer.Length) )
            ms.Position <- 0L
            let compressed = Array.zeroCreate<byte> (int(ms.Length))
            ms.Read(compressed, 0, compressed.Length) |> ignore
            let gzipBuffer = Array.zeroCreate<byte> (int(compressed.Length) + 4)
            Buffer.BlockCopy(compressed, 0, gzipBuffer, 4, compressed.Length)
            Buffer.BlockCopy(BitConverter.GetBytes(buffer.Length), 0, gzipBuffer, 0, 4)
            Convert.ToBase64String gzipBuffer



let eventHubName = "postshredeh1"
let connectionString = "Endpoint=sb://postshred.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=MzaH763+cCvIVvxr9fkWwTrqkk6S6t5p3dfpiOkfOxQ="
//Endpoint=sb://[namespace].servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=[key]

(*
let Run (input: string, log: TraceWriter) = 
    let groupedData = decompress input
    let eventHubClient = EventHubClient.CreateFromConnectionString(connectionString, eventHubName)
    
    groupedData.Split([|"|"|], StringSplitOptions.RemoveEmptyEntries)
    |> Array.iter (fun data -> 
        eventHubClient.Send(new EventData(Encoding.UTF8.GetBytes(data)))
        log.Info(sprintf "F# Queue trigger function processed: '%s'" data)
        )
*)
let input1="""{"location":{"Latitude":40.572785337127179,"Longitude":73.94234667988286,"Altitude":"NaN","HorizontalAccuracy":"NaN","VerticalAccuracy":"NaN","Speed":"NaN","Course":"NaN","IsUnknown":false},"deviceId":"DeviceId0","windSpeed":10.904973079871839,"obsTime":"2016-11-28T20:14:07.4050906Z"}"""

//let input2="2016-11-28T20:14:07.4050906Z"
let input=compress(input1)
//let a2=compress(input2)

// Convert the array to a base 64 sring.
//Convert.FromBase64String(input)
//Convert.FromBase64String(a2)

let groupedData = decompress input

let eventHubClient = EventHubClient.CreateFromConnectionString(connectionString, eventHubName)

eventHubClient.GetRuntimeInformation() 
eventHubClient.GetDefaultConsumerGroup()
eventHubClient.GetRuntimeInformation() 

groupedData.Split([|"|"|], StringSplitOptions.RemoveEmptyEntries)
    |> Array.iter (fun data -> 
        eventHubClient.Send(new EventData(Encoding.UTF8.GetBytes(data)))
        //log.Info(sprintf "F# Queue trigger function processed: '%s'" data)
        )







