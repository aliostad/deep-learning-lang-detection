namespace CsvConnector.Tests

open FlexSearch.Api.Model
open FlexSearch.Api.Constants
open FlexSearch.Core
open FlexSearch.CsvConnector
open Swensen.Unquote
open System

type ``Basic Tests``() = 
    member __.``Should return success response`` (indexName : string, csvHandler : CsvHandler) = 
        let requestContext = RequestContext.Create(null, "index", indexName)
        let csvRequest = new CsvIndexingRequest(IndexName = indexName,
                                                HasHeaderRecord = true,
                                                Path = AppDomain.CurrentDomain.BaseDirectory + @"\test.csv" )
        test <@ csvHandler.Process(requestContext, csvRequest |> Some) |> isSuccessResponse @>