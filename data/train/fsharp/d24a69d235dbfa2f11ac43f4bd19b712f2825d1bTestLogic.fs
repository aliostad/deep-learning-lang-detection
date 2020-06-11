module TestLogic
open System.Collections.Concurrent
open NUnit.Framework
open FsUnit

open FSharpGameBase

[<Literal>]
let TresholdNotFound = 20

let first_val_1:ResultTypes.UserAction = { 
    who = "nick_1"
    what = "what 1"
    where = "where 1"
    value_new = (TresholdNotFound + 1)
    }

let first_val_record:ResultTypes.UserAction = { 
    who = "nick_1"
    what = "what 1"
    where = "where 1"
    value_new = (TresholdNotFound + 3)
    }

let found_nothing:ResultTypes.UserAction = { 
    who = "nick_1"
    what = "what 1"
    where = "where 1"
    value_new = (TresholdNotFound-2) // less than 10
    }

[<Test>]
let``test first insert``()=
    let rslt = ProcessUser.ProcessFoundNotFound first_val_1 TresholdNotFound
    
    rslt.result |> should equal ResultTypes.FoundNew
    rslt.nickname |> should equal first_val_1.who
    rslt.what |> should equal first_val_1.what
    rslt.where |> should equal first_val_1.where
    rslt.value_old |> should equal 0
    rslt.value_new |> should equal first_val_1.value_new

[<Test>]
let``test found existing``()=
    let rslt_0 = ProcessUser.ProcessFoundNotFound first_val_1 TresholdNotFound
    let rslt = ProcessUser.ProcessFoundNotFound first_val_1 TresholdNotFound

    rslt.result |> should equal ResultTypes.Found
    rslt.nickname |> should equal first_val_1.who
    rslt.what |> should equal first_val_1.what
    rslt.where |> should equal first_val_1.where
    rslt.value_old |> should equal first_val_1.value_new
    rslt.value_new |> should equal first_val_1.value_new

[<Test>]
let``test new record reached``()=
    let rslt_0 = ProcessUser.ProcessFoundNotFound first_val_1 TresholdNotFound
    let rslt = ProcessUser.ProcessFoundNotFound first_val_record TresholdNotFound

    rslt.result |> should equal ResultTypes.FoundRecord
    rslt.nickname |> should equal first_val_record.who
    rslt.what |> should equal first_val_record.what
    rslt.where |> should equal first_val_record.where
    rslt.value_old |> should equal first_val_1.value_new
    rslt.value_new |> should equal first_val_record.value_new

[<Test>]
let``test found nothing``()=
    let rslt = ProcessUser.ProcessFoundNotFound found_nothing TresholdNotFound

    rslt.result |> should equal ResultTypes.FoundNothing
    rslt.nickname |> should equal found_nothing.who
    rslt.what |> should equal found_nothing.what
    rslt.where |> should equal found_nothing.where
    rslt.value_old |> should equal 0
    rslt.value_new |> should equal found_nothing.value_new

let diggRecords = new ConcurrentDictionary<string, int>()
let diggRecInsert (dict :ConcurrentDictionary<string, int>) (what :string) (age :int) = 
    dict.AddOrUpdate(what, age, (fun _ _ -> age ))


//    rslt.what |> should equal found_nothing.what
//    rslt.where |> should equal found_nothing.where
//    rslt.value_old |> should equal 0
//    rslt.value_new |> should equal found_nothing.value_new