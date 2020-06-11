module HDASUI.EvidenceProvider

open FSharp.Data

let BaseUrl = "http://alpha.api.nice.org.uk/services/search"
let Query (term) = "/results?q=" + term + "&pa=1&ps=&s="
let ApiKey = "3a0d112f-f924-47cb-b04a-b8f7c86bad6d"


type  EvidenceTypeProvider= JsonProvider<"Schemas/EvidenceSearch.json">


let simpleSearchRequest (term) = Http.RequestString( BaseUrl + Query (term), httpMethod = "GET",
                                   query   = [ "api-key", ApiKey],
                                   headers = [ "Accept", "application/json" ])


let search = simpleSearchRequest >> EvidenceTypeProvider.Parse

let abstracts term = search(term).SearchResult.Documents |> Array.map(fun d -> d.Abstract)
