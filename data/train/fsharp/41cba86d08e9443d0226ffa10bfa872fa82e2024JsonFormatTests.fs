module FormatTests

open Expecto
open Serilog
open System
open Newtonsoft.Json.Linq

type Test = { Foo : string }

[<Tests>]
let tests =

  use testApi = new TestApi()

  let uri = testApi.Start()

  let logger = LoggerConfiguration().MinimumLevel.Verbose().WriteTo.Scalyr("token", "host", "app", Nullable 1, TimeSpan.FromMilliseconds 100. |> Nullable, scalyrUri = uri).CreateLogger()

  logger.Information("{@foo}", { Foo = "Bar" })

  testApi.Continue.WaitOne(1000) |> ignore

  let actual = testApi.Received.[0] |> getFirstEvent |> getAttrs |> getObject "foo"

  let expected = JObject.Parse "{\"Foo\":\"Bar\"}"

  testCase "foo is set" <| fun _ -> Expect.isTrue (JToken.DeepEquals(actual, expected)) (sprintf "%O : %O" actual expected)