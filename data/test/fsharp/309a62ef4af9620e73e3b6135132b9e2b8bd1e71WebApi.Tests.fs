module WebApi.Tests

// Test the WebApi directly using the webApi

open System
open Expecto
open Suave
open WebTestUtilities
open XLCatlin.DataLab.XCBRA
open XLCatlin.DataLab.XCBRA.DomainModel
open XLCatlin.DataLab.XCBRA.Command
open XLCatlin.DataLab.XCBRA.Query
open XLCatlin.DataLab.XCBRA.Dazzle
open XLCatlin.DataLab.XCBRA.MemoryDb.SampleData
open UnitTestData

// be sure to make a new one each time, using empty data
let webApi() = 
    let eventStore = MemoryDbDataStore.eventStore()
    let readModelStore = MemoryDbDataStore.readModelStore()
    let commandStatusStore = MemoryDbDataStore.commandStatusStore()
    let commandService = ApiCommandService(eventStore,readModelStore,commandStatusStore) :> IApiCommandExecutionService 
    let queryService = ApiQueryService(readModelStore) :> IApiQueryService
    let dazzleService = ApiDazzleService(readModelStore) :> IApiDazzleService
    XLCatlin.DataLab.XCBRA.WebApi.routes(eventStore,readModelStore,commandService,queryService,commandStatusStore,dazzleService)

// =============================================
// Command tests
// =============================================

[<Tests>]
let commandTests = 
    let commandPath = "/command"

    testList "WebApi.Tests/Command" [
    
        testCase "when createLocation succeeds, expect 200" <| fun () ->
            let webApi = webApi()
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath 
            
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
        testCase "when createLocation is malformed succeeds, expect 400" <| fun () ->
            let webApi = webApi()
            let jsonRequest = cmdCreate() |> ApiSerialization.serialize 
            // make it malformed
            let malformedJsonRequest = jsonRequest.Replace("Any","XXX") 
            let postRequest = 
                malformedJsonRequest |> createPostRequest commandPath 
            
            postRequest 
            |> executeWebPart webApi 
            |> checkExpectation "createLocation malformed" expect400 

        testCase "when createLocation fails, expect 400" <| fun () ->
            let webApi = webApi()
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath 
            
            postRequest 
            |> executeWebPart webApi
            |> checkExpectation "createLocation first time" expect200 

            // do it again - expect an error now because the record already exists
            postRequest 
            |> executeWebPart webApi
            |> checkExpectation "createLocation second time" expect400 
    
        testCase "when createLocation followed by changeProperty, expect 200" <| fun () ->
            let webApi = webApi()

            let postRequest1 = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath 
            postRequest1
            |> executeWebPart webApi
            |> checkExpectation "createLocation" expect200 

            let postRequest2 = 
                cmdChangeProperty "NewName" |> ApiSerialization.serialize |> createPostRequest commandPath 
            postRequest2
            |> executeWebPart webApi
            |> checkExpectation "changeProperty" expect200 
    
   
    ]

// =============================================
// Command Queue tests
// =============================================

[<Tests>]
let commandQueueTests = 
    let commandPath = "/commandqueue"

    testList "WebApi.Tests/CommandQueue" [
    
        testCase "when createLocation succeeds, expect 202" <| fun () ->
            let webApi = webApi()
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath 
            
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect202 
  
    ]

// =============================================
// CommandStatus tests
// =============================================

[<Tests>]
let commandStatusTests = 
    let commandPath = "/command"
    let commandStatusPath id = sprintf "/commandstatus/%A" id
    // test
    // System.Guid.NewGuid() |> commandStatusPath  

    testList "WebApi.Tests/CommandStatus" [
    
        testCase "when createLocation succeeds, expect commandStatus=Success" <| fun () ->
            let webApi = webApi()
            let cmd = cmdCreate() 
            let postRequest = 
                cmd |> ApiSerialization.serialize |> createPostRequest commandPath 
            
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
            // query for the status
            let statusRequest = 
                cmd.commandId |> commandStatusPath |> createGetRequest // path not used
            let result =
                statusRequest 
                |> executeWebPart webApi

            result 
            |> checkExpectation "commandStatus: 200" expect200 
            result 
            |> checkExpectation "commandStatus: Success" (expectContentLike ApiCommandStatus.Success)

        testCase "when createLocation is malformed, expect commandStatus=NotFound" <| fun () ->
            let webApi = webApi()
            let cmd = cmdCreate() 
            let jsonRequest = cmd |> ApiSerialization.serialize 
            // make it malformed
            let malformedJsonRequest = jsonRequest.Replace("Any","XXX") 
            let postRequest = 
                malformedJsonRequest |> createPostRequest commandPath 
            
            postRequest 
            |> executeWebPart webApi 
            |> checkExpectation "createLocation malformed" expect400 

            let statusRequest = 
                cmd.commandId |> commandStatusPath |> createGetRequest // path not used
            let result =
                statusRequest 
                |> executeWebPart webApi

            result 
            |> checkExpectation "commandStatus: 404" expect404 

        testCase "when createLocation fails, expect commandStatus=Failure" <| fun () ->
            let cmd = cmdCreate() // it's ok to reuse the same command id, as we only care about the second one
            let webApi = webApi()
            let postRequest = 
                cmd |> ApiSerialization.serialize |> createPostRequest commandPath 
            
            postRequest 
            |> executeWebPart webApi
            |> checkExpectation "createLocation first time" expect200 

            // do it again - expect an error now because the record already exists
            postRequest 
            |> executeWebPart webApi
            |> checkExpectation "createLocation second time" expect400 

            let statusRequest = 
                cmd.commandId |> commandStatusPath |> createGetRequest // path not used
            let result =
                statusRequest 
                |> executeWebPart webApi

            result 
            |> checkExpectation "commandStatus: 200" expect200 
            result 
            |> checkExpectation "commandStatus: Failure" (expectContentContains "Failure")
            result 
            |> checkExpectation "commandStatus: already exists" (expectContentContains "already exists")
    
    // END testlist
    ]


// =============================================
// Query tests
// =============================================

[<Tests>]
let queryLocationByIdTests = 

    let commandPath = "/command"
    let queryPath id = sprintf "/location/%s" id

    testList "WebApi.Tests/Query" [
            
        testCase "when CreateLocation, expect QueryLocationById to return same value" <| fun () ->
            let webApi = webApi()
            // send the Create command
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath 
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
            // query for the result
            let queryRequest = 
                locationA.id.Value |> queryPath |> createGetRequest 
            let result =
                queryRequest
                |> executeWebPart webApi

            result 
            |> checkExpectation "queryLocationById status" expect200 

            result 
            |> checkExpectation "queryLocationById context" (expectContentLike locationA) 

        testCase "when query is malformed, expect 400" <| fun () ->
            let webApi = webApi()

            // send the Create command
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
            // query for the result
            let queryRequest = 
                "" |> queryPath |> createGetRequest 
            let result =
                queryRequest
                |> executeWebPart webApi 

            result 
            |> checkExpectation "queryLocationById status" expect400 


        testCase "when location doesnt exist, expect 400" <| fun () ->
            let webApi = webApi()

            // send the Create command
            let postRequest = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath
            postRequest
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
            // query for a different Id
            let queryRequest = 
                locationB.id.Value |> queryPath |> createGetRequest 
            let result =
                queryRequest
                |> executeWebPart webApi 

            result 
            |> checkExpectation "queryLocationById status" expect400 


        testCase "when CreateLocation, then ChangeProperty, expect QueryLocationById to reflect changed value" <| fun () ->
            let webApi = webApi()

            // send the Create command
            let postRequest1 = 
                cmdCreate() |> ApiSerialization.serialize |> createPostRequest commandPath
            postRequest1
            |> executeWebPart webApi 
            |> checkExpectation "createLocation" expect200 
    
            // send the ChangeProperty command
            let postRequest2 = 
                cmdChangeProperty "NewName" |> ApiSerialization.serialize |> createPostRequest commandPath
            postRequest2
            |> executeWebPart webApi 
            |> checkExpectation "changeProperty" expect200

            // query for the result
            let queryRequest = 
                locationA.id.Value |> queryPath |> createGetRequest 
            let result =
                queryRequest
                |> executeWebPart webApi 

            result 
            |> checkExpectation "queryLocationById status" expect200 

            let newLocation = {locationA with name = "NewName"}
            result 
            |> checkExpectation "queryLocationById context" (expectContentLike newLocation) 
    
    // END testlist
    ]

// =============================================
// Dazzle tests
// =============================================

[<Tests>]
let dazzleTests = 

    let commandPath = "/dazzle"
    let queryPath id = sprintf "/dazzle/%s" id
    
    // set very short for testing
    let defaultDuration = 100<Ms>
    MockDazzle.setDuration defaultDuration 

    let newCmd() = {
        // make the id unique
        DazzleStartCommand.Id = DazzleCalculationId <| Guid.NewGuid().ToString()
        Input = ""
        }

    testList "WebApi.Tests/Dazzle" [

        testCase "when Start, expect OK" <| fun () ->
            let webApi = webApi()
            let cmd = newCmd()

            let postRequest = 
                cmd |> ApiSerialization.serialize |> createPostRequest commandPath 

            let result1 = 
                postRequest
                |> executeWebPart webApi 
            result1 |> checkExpectation "start" expect200 
            result1 |> checkExpectation "status returned from Start" (expectContentContains "InProcess")

            // check status 
            let queryRequest = 
                cmd.Id.Value |> queryPath |> createGetRequest 

            queryRequest
            |> executeWebPart webApi 
            |> checkExpectation "status before completed" (expectContentContains "InProcess")


        testCase "when Start, then wait, then check Status, expect OK" <| fun () ->
            let webApi = webApi()
            let cmd = newCmd()

            let postRequest = 
                cmd |> ApiSerialization.serialize |> createPostRequest commandPath 

            let result1 = 
                postRequest
                |> executeWebPart webApi 
            result1 |> checkExpectation "start" expect200 
            result1 |> checkExpectation "status returned from Start" (expectContentContains "InProcess")

            // check status 
            let queryRequest = 
                cmd.Id.Value |> queryPath |> createGetRequest 

            queryRequest
            |> executeWebPart webApi 
            |> checkExpectation "status before completed" (expectContentContains "InProcess")

            // wait 3x as long
            System.Threading.Thread.Sleep (defaultDuration * 3<_>) 

            // check status again
            queryRequest
            |> executeWebPart webApi 
            |> checkExpectation "status after completed" (expectContentContains "Completed")

    // END testlist
    ]

