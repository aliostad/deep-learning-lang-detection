module Dazzle.Service.Tests

open XLCatlin.DataLab.XCBRA
open XLCatlin.DataLab.XCBRA.Dazzle
open XLCatlin.DataLab.XCBRA.DomainModel
open XLCatlin.DataLab.XCBRA.MemoryDb
open Expecto

// =====================
// Tests to check that Dazzle service works.
//
// These tests talk directly to the service, bypassing Suave. 
// The tests use mocks and dummy data, so there is no I/O.
//
// For tests that go through Suave, see Command.WebService.Tests in a different project
// =====================

open XLCatlin.DataLab.XCBRA.MemoryDb


// ==========================================
// Test 
// ==========================================

// set very short for testing
let defaultDuration = 100<Ms>

let newService() =
    MockDazzle.setDuration defaultDuration 
    let readModelStore = newReadModelStore() 
    ApiDazzleService(readModelStore) :> IApiDazzleService    

let calcIdA = DazzleCalculationId "A"
let calcIdB = DazzleCalculationId "B"
let input = ""

let cmd = {DazzleStartCommand.Id=calcIdA; Input=input}

let isInProcess status  = 
    match status with
    | InProcess _ -> true
    | Completed _ -> false

let isCompleted status  = 
    status |> isInProcess |> not


[<Tests>]   
let dazzle = 
    testList "Dazzle.Service.Tests" [
            
        testCase "when Create calculation, expect status is InProcess" <| fun () ->
            let service = newService() 
            
            asyncResult {
                let! status = service.Start cmd 
                Expect.isTrue (isInProcess status) "isInProcess status"
            } 
            |> Async.RunSynchronously
            |> notExpectingError

        testCase "when check Status after creation, expect status is InProcess" <| fun () ->
            let service = newService() 
            asyncResult {
                let! _ = service.Start cmd
                let! status = service.Status calcIdA 
                Expect.isTrue (isInProcess status) "isInProcess status"
            } 
            |> Async.RunSynchronously
            |> notExpectingError

        testCase "when check Status of missing id, expect Error" <| fun () ->
            let service = newService() 
            asyncResult {
                let! _ = service.Start cmd
                let! _ = service.Status calcIdB  // different id
                notExpectedToGetHere()
            } 
            |> Async.RunSynchronously
            |> expectErrorWithValue (function
                | DazzleError.DazzleError _ -> asExpected()
                | _ -> notExpectedToGetHere()
                )

        //TODO working standalone but not in build -- deleted until understood
        testCase "when check Status after duration, expect status is Completed" <| fun () ->
            let service = newService() 
            asyncResult {
                let! _ = service.Start cmd
                let! status1 = service.Status calcIdA 
                Expect.isTrue (isInProcess status1) "isInProcess status1"
                // wait 3x as long
                do! AsyncResult.sleep (defaultDuration * 3<_>) 
                let! status2 = service.Status calcIdA 
                Expect.isTrue (isCompleted status2) "isCompleted status2"
            } 
            |> Async.RunSynchronously
            |> notExpectingError


    // END testlist
    ]





