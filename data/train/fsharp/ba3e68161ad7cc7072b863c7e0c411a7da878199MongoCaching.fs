module MongoCaching

open System
open FSharp.MongoDB
open FSharp.MongoDB.Bson.Serialization
open FSharp.MongoDB.Driver.Quotations
open FSharp.MongoDB.Driver
open FSharp.MongoDB.Bson
open Types
open MongoDB.Bson
open NLog

type MongoCacheRecord = {
    _id : Option<BsonObjectId>
    DateCached : DateTime
    ApiRequest : SkyScannerApi.ApiRequest
    SearchResults : Option<List<SearchResult>>
}



let private logger = LogManager.GetLogger("Caching")
let private connectionString = "mongodb://localhost"
let private client = MongoClient() :> IMongoClient
let private database = client.GetDatabase("SkyScanner")
let private collection = database.GetCollection<MongoCacheRecord>("SearchResults")


let GetSearchResult (apiRequest:SkyScannerApi.ApiRequest) = 
    let dest = apiRequest.Destination
    let outboundDate = apiRequest.OutboundDate.Date 
    let inboundDate =  apiRequest.InboundDate.Date 
    let query = 
        <@ fun (x : MongoCacheRecord) -> 
            x.ApiRequest.Destination = dest
            && x.ApiRequest.OutboundDate = outboundDate
            && x.ApiRequest.InboundDate = inboundDate
        @> 
        |> bson

    let result = collection.Find(query)
    match result with
    | r when r |> Seq.length = 1 -> 
        logger.Debug(sprintf "Hit for %A" apiRequest)
        ((r |> Seq.head)).SearchResults
    | r when r |> Seq.length > 1 -> 
        failwith "Too many cache results"
    | _ -> 
        logger.Debug(sprintf "Miss for %A" apiRequest)
        None



let StoreSearchResult apiRequest searchResults =
    let toInsert = {
        _id = None
        DateCached = DateTime.Now
        ApiRequest = apiRequest
        SearchResults = searchResults
    }
    collection.Insert(toInsert)
        |> ignore

    logger.Debug(sprintf "Cached %i results for %A" (searchResults |> Option.get).Length apiRequest)
    ()

