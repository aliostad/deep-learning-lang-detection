module ResourceAdmin

open System
open RestSharp

let e = Uri.EscapeDataString
let json = "application/json"

type RabbitMQResource() =
    member val name = "" with get, set
    member val vhost = "" with get, set

    member this.url resourceType =
        "/api/" + resourceType + "/" + e(this.vhost) + "/" + e(this.name)

let listResources (client:RestClient) resourceType =
    client.Execute<ResizeArray<RabbitMQResource>>(new RestRequest ("/api/" + resourceType))

let deleteResource (client:RestClient) resourceType (resources:RabbitMQResource seq) =
    resources |> Seq.iter (fun resource -> client.Execute (new RestRequest(resource.url resourceType, Method.DELETE)) |> ignore)

let filterDevelopmentObjects = Seq.filter (fun (x:RabbitMQResource) -> Seq.exists (fun y-> x.name.StartsWith y) ["subscriber";"ADP."; "Sales."; "Shipping."; "MvcApplication";"Messages"; "System"; "Billing" ; "CRM"; "LeadManager"])

let clearOutQueues client =
    let exchanges = listResources client "exchanges"
    exchanges.Data |> filterDevelopmentObjects |> deleteResource client "exchanges"
    (listResources client "queues").Data |> Seq.map (fun x-> x.name) |> Seq.iter (printfn "%s")
    let queues = listResources client "queues"
    queues.Data |> filterDevelopmentObjects |> deleteResource client "queues"

let createDefaultUpstream (client:RestClient) (hostname:string) =
    (new RestRequest("/api/parameters/federation-upstream/%2f/host_" + hostname.Replace(".", "_"), Method.PUT)).AddParameter(json, sprintf "{\"value\":{\"uri\":\"amqp://guest:guest@%s\"}}" hostname, ParameterType.RequestBody)
        |>  client.Execute |> ignore

let setupFederation auth =
    let centralBrokerClient = new RestClient "http://192.168.116.205:15672"
    centralBrokerClient.Authenticator <- auth
    createDefaultUpstream centralBrokerClient "192.168.116.215"
    (new RestRequest("/api/policies/%2f/fawad-fed", Method.PUT)).AddParameter(json, "{\"pattern\":\"^federated\.\", \"definition\": {\"federation-upstream-set\":\"all\"}}", ParameterType.RequestBody)
        |>  centralBrokerClient.Execute |> ignore
    0
