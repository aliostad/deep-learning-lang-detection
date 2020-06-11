module CommonTests

open Xunit
open FsUnit.Xunit
open PiwikApiParameter
open PiwikMethodDefs
open PiwikCallBuilder

let apiUri ="test.com"
let contains (testFor:string) (result:string)= result.Contains(testFor)

[<Fact>]
let ``addParameter param val should add &param=val to uri`` () =
    apiUri |> addParameter ("param", "val") |> contains "&param=val" |> should be True

[<Fact>]
let ``addParameter (param,val) twice  should fail`` () =
    try
        apiUri |> addParameter ("param", "val") |> addParameter ("param", "val") |> ignore 
        true |> should be False |> ignore
    with
    | ParameterDuplicationException(p, v) ->
                        p |> should equal "param"
                        v |> should equal "val"
[<Fact>]
let ``addParam param val should add val.Command to uri`` () =
    apiUri |> addParam({ 
                                new ApiParameter with
                                    member this.Command="&testName=testCommand"
                                    member this.Name ="testName"
                                }) |> contains "&testName=testCommand" |> should be True

[<Fact>]
let ``addParam param twice shoul fail`` () =
    try
        apiUri |> addParam({ 
                                new ApiParameter with
                                    member this.Command="&testName=testCommand"
                                    member this.Name ="testName"
                                }) 
                                |> addParam({ 
                                                new ApiParameter with
                                                    member this.Command="&testName=testCommand"
                                                    member this.Name ="testName"
                                })  |> ignore

    with
    | ParameterDuplicationException(p, v) ->
                        p |> should equal "testName"
                        v |> should equal "testCommand"                          
[<Fact>]
let ``start should add ?module=API `` () =
    start "test.com" |> contains "?module=API" |> should be True

[<Fact>]
let ``addAuth should add token_auth to uri`` () =
    apiUri |> addAuth "token" |> contains "&token_auth=token" |> should be True

[<Fact>]
let ``addSite 1 should add &idSite= to uri`` () =
    apiUri |> addSite(Single 1) |> contains "&idSite=1" |> should be True

[<Fact>]
let ``addSite [|1,2,3|] should add &idSite=1,2,3 to uri`` () =
    apiUri |> addSite(Many [|1;2;3|]) |> contains "&idSite=1,2,3" |> should be True

[<Fact>]
let ``addSite all should add &idSite=all to uri`` () =
    apiUri |> addSite All |> contains "&idSite=all" |> should be True

[<Fact>]
let ``addSite twice  should fail`` () =
    try
        apiUri |> addSite All |> addSite All |> ignore 
        true |> should be False |> ignore
    with
    | ParameterDuplicationException(p, v) ->
                        p |> should equal "idSite"
                        v |> should equal "all"
                        

