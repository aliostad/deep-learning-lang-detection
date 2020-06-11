
open Suave.Types

//Set pwd to the directory containing this script
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__



let BaseUrl = "http://alpha.api.nice.org.uk/services/search"
let Query (term) = "/results?q=" + term + "&pa=1&ps=&s="
let ApiKey = "3a0d112f-f924-47cb-b04a-b8f7c86bad6d"


type EvidenceTypeProvider = JsonProvider<"../HDAS/Schemas/EvidenceSearch.json">


let simpleSearchRequest term = Http.RequestString( BaseUrl + Query (term), httpMethod = "GET",
                                   query   = [ "api-key", ApiKey],
                                   headers = [ "Accept", "application/json" ])



let search = simpleSearchRequest >> EvidenceTypeProvider.Parse 


let abstracts = search("pain").SearchResult.Documents |> Array.map (fun d -> d.Abstract) 

printfn "%s" (abstracts |> String.concat "<br/>")

