module Tests

open Expecto
open Serilog
open System
open Newtonsoft.Json.Linq
open System.Text.RegularExpressions

type SessionInfo = { location : string }

[<Tests>]
let tests =

  let isGuid value = Regex.IsMatch(value, "[a-f0-9]{32}")

  let startTs = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() * 1000000L

  use testApi = new TestApi()

  let uri = testApi.Start()

  let logger = LoggerConfiguration().MinimumLevel.Verbose().WriteTo.Scalyr("token", "host", "app", Nullable 1, TimeSpan.FromMilliseconds 100. |> Nullable, scalyrUri = uri, sessionInfo = { location = "Earth" }).CreateLogger()

  logger.Verbose("Verbose {foo}", "bar")
  logger.Debug "Debug"
  logger.Information "Information"
  logger.Warning "Warning"
  logger.Error "Error"
  logger.Fatal "Fatal"

  testApi.Continue.WaitOne(1000) |> ignore

  let verboseLog = testApi.Received.[0]

  let sessionInfo = verboseLog.["sessionInfo"].ToObject()

  testList "Information" [

    testCase "token is set" <| fun _ -> Expect.equal (verboseLog |> getValue "token") "token" ""

    testCase "session is a guid" <| fun _ -> Expect.isTrue (verboseLog |> getValue "session" |> isGuid) ""

    testCase "serverHost is set" <| fun _ -> Expect.equal (sessionInfo |> getValue "serverHost") "host" ""

    testCase "logfile is set" <| fun _ -> Expect.equal (sessionInfo |> getValue "logfile") "app" ""

    testCase "location is set from sessioninfo object" <| fun _ -> Expect.equal (sessionInfo |> getValue "location") "Earth" ""

    testCase "api received 6 logs" <| fun _ -> Expect.equal testApi.Received.Count 6 ""

    testCase "events have incrementing ts" <| fun _ -> Expect.isTrue (testApi.Received |> Seq.map (getFirstEvent >> getValue "ts" >> int64) |> Seq.mapFold (fun state next -> next > state, next) startTs |> fst |> Seq.forall id) ""

    testCase "events have incrementing sev" <| fun _ -> Expect.equal (testApi.Received |> Seq.map (getFirstEvent >> getValue "sev" >> int) |> Seq.toList) [ 1; 2; 3; 4; 5; 6 ] ""

    testCase "message attr is set" <| fun _ -> Expect.equal (verboseLog |> getFirstEvent |> getAttrs |> getValue "message") "Verbose \"bar\"" ""

    testCase "foo attr is set" <| fun _ -> Expect.equal (verboseLog |> getFirstEvent |> getAttrs |> getValue "foo") "bar" ""

  ]
