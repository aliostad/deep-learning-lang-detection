#light
#r "System.ServiceModel"
#r "System.Runtime.Serialization"
open System
open System.ServiceModel
open System.ServiceModel.Channels
open System.ServiceModel.Description
open System.ServiceModel.Dispatcher


[<ServiceContract>]
type ICalculator =
    [<OperationContract>]
    abstract Divide : double * double -> double


type Calculator() =
    interface ICalculator with
        member this.Divide(n1, n2) =
            match n2 with
            | 0.0  ->
                raise (new DivideByZeroException())
            | _    -> n1 / n2


type MyErrorHandler() =
    interface IErrorHandler with
        member this.HandleError(error) =
            printfn "MyErrorHandler.HandleError()"
            false
        
        member this.ProvideFault(error, version, fault) =
            printfn "MyErrorHandler.ProvideFault(): %A" fault


type ErrorServiceBehavior() =
    interface IServiceBehavior with
        member this.AddBindingParameters(serviceDescription, serviceHostBase, endpoints, bindingParameters) =
            ()
            
        member this.ApplyDispatchBehavior(serviceDescription, serviceHostBase) =
            for cd in serviceHostBase.ChannelDispatchers do
                (cd :?> ChannelDispatcher).ErrorHandlers.Add(new MyErrorHandler())

        member this.Validate(serviceDescription, serviceHostBase) =
            ()


let uri = new Uri("net.tcp://localhost")
let binding = new NetTcpBinding()
let host = new ServiceHost(typeof<Calculator>, [| uri |])
host.AddServiceEndpoint(typeof<ICalculator>, binding, "")
host.Description.Behaviors.Add(new ErrorServiceBehavior())
host.Open()

let proxy = ChannelFactory<ICalculator>.CreateChannel(binding, new EndpointAddress(string uri))

try
    proxy.Divide(4.0, 0.0) |> ignore
with ex ->
    printfn "%A: %s\n\n" (ex.GetType()) ex.Message
    printfn "Proxy state = %A\n\n" (proxy :?> ICommunicationObject).State

try
    (proxy :?> ICommunicationObject).Close()
with _ -> ()
host.Close()

Threading.Thread.Sleep(100)
