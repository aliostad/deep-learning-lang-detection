open System
open System.Net.Security
open System.ServiceModel
open System.Runtime.Serialization


[<MessageContract>]
type MyMessage() =
    let mutable apiKey = ""
    let mutable requestValue = ""

    [<MessageHeader(Namespace = "")>]
    member this.ApiKey = apiKey
    member this.ApiKey with set v = apiKey <- v

    [<MessageBodyMember(Namespace = "", ProtectionLevel = ProtectionLevel.EncryptAndSign)>]
    member this.RequestValue = requestValue
    member this.RequestValue with set v = requestValue <- v


[<ServiceContract>]
type IMyContract =
    [<OperationContract>]
    abstract MyOperation : MyMessage -> unit


[<ServiceBehavior(IncludeExceptionDetailInFaults = true)>]
type MyService() =
    interface IMyContract with
        member this.MyOperation(msg) = ()


let host = new ServiceHost(typeof<MyService>, new Uri("net.tcp://localhost"))
host.Open()

let proxy = ChannelFactory<IMyContract>.CreateChannel(host.Description.Endpoints.[0].Binding, host.Description.Endpoints.[0].Address)
proxy.MyOperation(new MyMessage(ApiKey = "abcdefg", RequestValue = "1"))

(proxy :?> ICommunicationObject).Close()
host.Close()
Console.ReadLine() |> ignore
