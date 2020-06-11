module TrackApiTests

open Xunit
open FsUnit.Xunit
open PiwikApiParameter
open PiwikMethodDefs
open PiwikCallBuilder

let apiUri ="test.com"
let contains (testFor:string) (result:string)= result.Contains(testFor)


[<Fact>]
let ``addMethod(TrackAPI(Track(123,"www.test.com/index","test","userId",None,None,None,None,None,None,None,None,None,None,None,None,None,None,None,None,None))) should add ?idsite=123&rec=1&url=www.test.com/index&action_name=test&_id=12 to uri`` () =
    let testCallResult = apiUri |> addMethod(TrackAPI(Track(123,"www.test.com/index/test?p=asd&p=t t","test","12",None,None,None,None,None,None,None,None,None,None,None,None,None,None,None,None,None)))
    testCallResult |> System.Console.WriteLine
    testCallResult |> contains "&idsite=123&url=www.test.com/index/test?p=asd&p=t%20t&action_name=test&_id=12" |> should be True





